"""Acceso a datos de MapBiomas Perú: LULC, Alerta, Fuego, imágenes.

Equivalente Python de los módulos R:
- ``R/get_mapbiomas_peru_lulc.R``
- ``R/get_mapbiomas_peru_lulc_series.R``
- ``R/get_mapbiomas_peru_alerta.R``
- ``R/get_mapbiomas_peru_fire.R``
- ``R/get_mapbiomas_peru_fire_legend.R``
- ``R/get_mapbiomas_alert_images.R``

Funcionalidades LULC, Alerta y Fire son **opcionales** (requieren extras).
"""

from __future__ import annotations

from datetime import date
from pathlib import Path
from typing import TYPE_CHECKING, Any

from ._download import DEFAULT_HEADERS, download_file
from ._endpoints import (
    MAPBIOMAS_ALERTA_TYPE_NAME,
    MAPBIOMAS_ALERTA_WFS,
    get_mapbiomas_peru_lulc_url,
)

if TYPE_CHECKING:
    import geopandas as gpd
    import matplotlib.pyplot as plt
    import pandas as pd
    import xarray as xr


# ────────────────────────────────────────────────────────────
# Utilidades internas
# ────────────────────────────────────────────────────────────

def _require_rioxarray() -> Any:
    try:
        import rioxarray  # noqa: F401
        import xarray as xr
        return xr
    except ImportError as e:
        raise ImportError(
            "Esta función requiere `rioxarray` y `rasterio`. "
            'Instala los extras: `pip install "geoidep[mapbiomas]"`'
        ) from e


def _validate_date(x: str | None, arg_name: str) -> date | None:
    if x is None:
        return None
    try:
        return date.fromisoformat(x)
    except ValueError:
        raise ValueError(
            f"Fecha inválida para '{arg_name}': {x!r}. "
            "Use formato YYYY-MM-DD (ej. 2024-01-31)."
        ) from None


FIRE_PRODUCTS = [
    {"product": "annual_burned", "description_en": "Annual burned area", "description_es": "Área quemada anual", "temporal": "annual"},
    {"product": "annual_burned_coverage", "description_en": "Annual burned area by land cover", "description_es": "Área quemada anual por cobertura", "temporal": "annual"},
    {"product": "monthly_burned", "description_en": "Monthly burned area", "description_es": "Área quemada mensual", "temporal": "annual"},
    {"product": "accumulated_burned", "description_en": "Accumulated burned area", "description_es": "Área quemada acumulada", "temporal": "range"},
    {"product": "accumulated_burned_coverage", "description_en": "Accumulated burned area by cover", "description_es": "Área quemada acumulada por cobertura", "temporal": "range"},
    {"product": "frequency_burned", "description_en": "Burned area frequency", "description_es": "Frecuencia de área quemada", "temporal": "range"},
    {"product": "annual_burned_scar_size_range", "description_en": "Annual burned scar size", "description_es": "Tamaño de cicatriz anual", "temporal": "annual"},
    {"product": "year_last_fire", "description_en": "Year of last fire", "description_es": "Año del último fuego", "temporal": "annual"},
]

FIRE_FILE_MAP = {
    "annual_burned":                 ("mbfire_col1_peru_annual_burned",                "burned_area"),
    "annual_burned_coverage":        ("mbfire_col1_peru_annual_burned_coverage",       "burned_coverage"),
    "monthly_burned":                ("mbfire_col1_peru_monthly_burned",               "burned_monthly"),
    "accumulated_burned":            ("mbfire_col1_peru_accumulated_burned",           "fire_accumulated"),
    "accumulated_burned_coverage":   ("mbfire_col1_peru_accumulated_burned_coverage",  "fire_accumulated"),
    "frequency_burned":              ("mbfire_col1_peru_frequency_burned",             "fire_frequency"),
    "annual_burned_scar_size_range": ("mbfire_col1_peru_annual_burned_scar_size_range", "scar_area_ha"),
    "year_last_fire":                ("mbfire_col1_peru_year_last_fire",               "classification"),
}


# ────────────────────────────────────────────────────────────
# LULC
# ────────────────────────────────────────────────────────────

def get_mapbiomas_peru_lulc(
    year: int,
    crop_to: gpd.GeoDataFrame | gpd.GeoSeries | None = None,
    *,
    collection: int = 3,
    masked: bool = True,
) -> xr.DataArray:
    """Lee perezosamente el raster LULC de MapBiomas Perú para un año.

    Equivalente de ``get_mapbiomas_peru_lulc()`` en R.

    Parameters
    ----------
    year
        Año de la clasificación (1985–2024 en la colección 3).
    crop_to
        Geometría opcional (en cualquier CRS) usada para recortar.
    collection
        Número de colección (1, 2 o 3). Por defecto 3.
    masked
        Si ``True`` aplica máscara (clip) usando ``crop_to``.

    Returns
    -------
    xarray.DataArray
        Raster ``classification_<year>`` con CRS WGS84.
    """
    import geopandas as gpd

    xr_mod = _require_rioxarray()
    import rioxarray  # noqa: F401

    url = get_mapbiomas_peru_lulc_url(year=year, collection=collection)
    vsi_url = f"/vsicurl/{url}"

    da = xr_mod.open_dataarray(vsi_url, engine="rasterio")
    da.name = f"classification_{year}"

    if crop_to is not None:
        if isinstance(crop_to, gpd.GeoDataFrame):
            geom = crop_to.to_crs(da.rio.crs).geometry
        elif isinstance(crop_to, gpd.GeoSeries):
            geom = crop_to.to_crs(da.rio.crs)
        else:
            raise TypeError("`crop_to` debe ser GeoDataFrame o GeoSeries.")

        bounds = geom.total_bounds
        da = da.rio.clip_box(*bounds)

        if masked:
            da = da.rio.clip(geom, drop=True, all_touched=True, invert=False)

    return da


def get_mapbiomas_peru_lulc_series(
    years: list[int],
    crop_to: gpd.GeoDataFrame | gpd.GeoSeries | None = None,
    *,
    collection: int = 3,
) -> xr.DataArray:
    """Apila múltiples años de LULC en un único DataArray.

    Parameters
    ----------
    years
        Lista de años (ej. ``[2018, 2020, 2024]``).
    crop_to
        Área de interés opcional.
    collection
        Colección de MapBiomas Perú (1, 2 o 3).

    Returns
    -------
    xarray.DataArray
        Cubo con coordenada ``year``.
    """
    _require_rioxarray()
    layers = [
        get_mapbiomas_peru_lulc(year=y, crop_to=crop_to, collection=collection)
        for y in years
    ]
    import xarray as xr_mod
    stacked = xr_mod.concat(layers, dim="year")
    stacked = stacked.assign_coords(year=years)
    stacked.name = "lulc_series"
    return stacked


# ────────────────────────────────────────────────────────────
# Alerta (deforestación)
# ────────────────────────────────────────────────────────────

def get_mapbiomas_peru_alerta(
    region: gpd.GeoDataFrame,
    from_date: str | None = None,
    to_date: str | None = None,
    dsn: str | Path | None = None,
    *,
    method: str = "within",
    show_progress: bool = True,
    quiet: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame:
    """Descarga alertas de deforestación de MapBiomas Alerta Perú.

    Equivalente de ``get_mapbiomas_peru_alerta()`` en R.

    Parameters
    ----------
    region
        Área de interés en EPSG:4326.
    from_date
        Fecha inicial (YYYY-MM-DD). Opcional.
    to_date
        Fecha final (YYYY-MM-DD). Opcional.
    dsn
        Ruta opcional para guardar el GeoJSON.
    method
        Predicado espacial: ``"within"``, ``"intersects"``, ``"contains"``,
        ``"crosses"``, ``"touches"``.
    show_progress
        Mostrar barra de progreso.
    quiet
        Suprimir mensajes.
    timeout
        Timeout en segundos.

    Returns
    -------
    geopandas.GeoDataFrame
        Alertas con geometría y columnas ``id``, ``detected_at``,
        ``before_image_url``, ``after_image_url``.
    """
    import geopandas as gpd
    import pandas as pd
    import requests

    if region.crs is None or region.crs.to_epsg() != 4326:
        raise ValueError("La región debe estar en EPSG:4326 (WGS 84).")

    bbox = region.total_bounds  # [minx, miny, maxx, maxy]
    bbox_str = f"{bbox[1]},{bbox[0]},{bbox[3]},{bbox[2]},urn:ogc:def:crs:EPSG::4326"

    params = {
        "service": "WFS",
        "version": "2.0.0",
        "request": "GetFeature",
        "typeName": MAPBIOMAS_ALERTA_TYPE_NAME,
        "outputFormat": "application/json",
        "bbox": bbox_str,
    }

    resp = requests.get(
        MAPBIOMAS_ALERTA_WFS,
        params=params,
        headers=DEFAULT_HEADERS,
        timeout=timeout,
    )
    resp.raise_for_status()

    spatial_formats = gpd.read_file(resp.text)
    if spatial_formats.empty:
        return spatial_formats

    if "bbox" in spatial_formats.columns:
        spatial_formats = spatial_formats.drop(columns=["bbox"])

    spatial_formats = spatial_formats.set_crs("EPSG:4326")

    # Filtro por fechas
    from_d = _validate_date(from_date, "from_date")
    to_d = _validate_date(to_date, "to_date")

    if "detected_at" in spatial_formats.columns:
        spatial_formats["detected_at"] = pd.to_datetime(spatial_formats["detected_at"]).dt.date

        if from_d is not None and to_d is not None and from_d > to_d:
            raise ValueError("`from_date` debe ser anterior o igual a `to_date`.")

        if from_d is not None:
            spatial_formats = spatial_formats.loc[spatial_formats["detected_at"] >= from_d]
        if to_d is not None:
            spatial_formats = spatial_formats.loc[spatial_formats["detected_at"] <= to_d]

    # Filtro espacial
    predicate_map = {
        "within": gpd.sjoin,
        "intersects": lambda left, r, **kw: gpd.sjoin(left, r, predicate="intersects", **kw),
        "contains": lambda left, r, **kw: gpd.sjoin(left, r, predicate="contains", **kw),
        "crosses": lambda left, r, **kw: gpd.sjoin(left, r, predicate="crosses", **kw),
        "touches": lambda left, r, **kw: gpd.sjoin(left, r, predicate="touches", **kw),
    }

    if method == "within":
        spatial_info = gpd.sjoin(spatial_formats, region, predicate="within", how="inner")
    elif method in predicate_map:
        spatial_info = predicate_map[method](spatial_formats, region, how="inner")
    else:
        raise ValueError(f"Método espacial inválido: {method!r}")

    if dsn is not None:
        spatial_info.to_file(dsn, driver="GPKG")

    # URLs de imágenes
    if "id" in spatial_info.columns:
        spatial_info["before_image_url"] = spatial_info["id"].apply(
            lambda i: f"https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{i}/before_deforestation.png"
        )
        spatial_info["after_image_url"] = spatial_info["id"].apply(
            lambda i: f"https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{i}/after_deforestation.png"
        )

    non_geom = [c for c in spatial_info.columns if c.lower() not in ("geom", "geometry")]
    spatial_info = spatial_info.rename(columns={c: c.lower() for c in non_geom})
    return spatial_info


# ────────────────────────────────────────────────────────────
# Alert images
# ────────────────────────────────────────────────────────────

def get_mapbiomas_alert_images(
    alert_ids: list[str] | list[int],
    download_dir: str | Path | None = None,
    *,
    image_type: str = "both",
    show_progress: bool = True,
    overwrite: bool = False,
    timeout: int = 120,
) -> pd.DataFrame:
    """Descarga imágenes satelitales before/after de alertas MapBiomas.

    Equivalente de ``get_mapbiomas_alert_images()`` en R.

    Parameters
    ----------
    alert_ids
        IDs de alerta.
    download_dir
        Directorio destino. Si es ``None``, se crea uno temporal.
    image_type
        ``"both"``, ``"before"`` o ``"after"``.
    show_progress
        Mostrar barra de progreso.
    overwrite
        Sobrescribir archivos existentes.
    timeout
        Timeout por imagen.

    Returns
    -------
    pandas.DataFrame
        Columnas: alert_id, image_type, url, local_path, status, error_message.
    """
    import pandas as pd

    if not alert_ids:
        raise ValueError("`alert_ids` no puede estar vacío.")

    alert_ids = [str(a) for a in alert_ids]

    if download_dir is None:
        download_dir = Path.cwd() / "mapbiomas_alerts_images"
    else:
        download_dir = Path(download_dir)
    download_dir.mkdir(parents=True, exist_ok=True)

    if image_type not in ("both", "before", "after"):
        raise ValueError("`image_type` debe ser 'both', 'before' o 'after'.")

    types = ["before", "after"] if image_type == "both" else [image_type]

    results = []
    total = len(alert_ids) * len(types)

    from tqdm.auto import tqdm
    pbar = tqdm(total=total, desc="Downloading images", unit="img") if show_progress else None

    for aid in alert_ids:
        for itype in types:
            filename = f"alert_{aid}_{itype}_deforestation.png"
            url = f"https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{aid}/{itype}_deforestation.png"
            local_path = download_dir / filename

            if local_path.exists() and not overwrite:
                results.append({
                    "alert_id": aid, "image_type": itype, "url": url,
                    "local_path": str(local_path), "status": "skipped",
                    "error_message": "",
                })
            else:
                try:
                    download_file(url, dsn=local_path, show_progress=False, timeout=timeout)
                    results.append({
                        "alert_id": aid, "image_type": itype, "url": url,
                        "local_path": str(local_path), "status": "success",
                        "error_message": "",
                    })
                except Exception as e:
                    results.append({
                        "alert_id": aid, "image_type": itype, "url": url,
                        "local_path": str(local_path), "status": "failed",
                        "error_message": str(e),
                    })

            if pbar:
                pbar.update(1)

    if pbar:
        pbar.close()

    df = pd.DataFrame(results)
    success = (df["status"] == "success").sum()
    failed = (df["status"] == "failed").sum()
    skipped = (df["status"] == "skipped").sum()

    print(f"Download summary: {success} OK, {failed} failed, {skipped} skipped")  # noqa: T201
    return df


# ────────────────────────────────────────────────────────────
# Fire products
# ────────────────────────────────────────────────────────────

def get_mapbiomas_peru_fire_products() -> pd.DataFrame:
    """Lista los productos disponibles de MapBiomas Fuego Perú.

    Returns
    -------
    pandas.DataFrame
        Columnas: product, description_en, description_es, temporal.
    """
    import pandas as pd

    return pd.DataFrame(FIRE_PRODUCTS)


def get_mapbiomas_peru_fire_legend(product: str) -> pd.DataFrame:
    """Devuelve la leyenda (códigos, nombres, colores) para un producto de fuego.

    Parameters
    ----------
    product
        Nombre del producto (ej. ``"frequency_burned"``, ``"year_last_fire"``).

    Returns
    -------
    pandas.DataFrame
        Columnas: id, class_en, class_es, hex.
    """
    import pandas as pd

    products_df = get_mapbiomas_peru_fire_products()
    if product not in products_df["product"].values:
        raise ValueError(f"Producto inválido '{product}'. Opciones: {list(products_df['product'])}")

    if product in ("annual_burned", "accumulated_burned"):
        return pd.DataFrame([
            {"id": 1, "class_en": "Burned area", "class_es": "Área quemada", "hex": "#ff5340"},
        ])

    if product in ("annual_burned_coverage", "accumulated_burned_coverage"):
        return get_mapbiomas_peru_legend()

    if product == "monthly_burned":
        return pd.DataFrame([
            {"id": 1, "class_en": "January", "class_es": "Enero", "hex": "#CC00FF"},
            {"id": 2, "class_en": "February", "class_es": "Febrero", "hex": "#6600FF"},
            {"id": 3, "class_en": "March", "class_es": "Marzo", "hex": "#0000FF"},
            {"id": 4, "class_en": "April", "class_es": "Abril", "hex": "#00CCFF"},
            {"id": 5, "class_en": "May", "class_es": "Mayo", "hex": "#00FFCC"},
            {"id": 6, "class_en": "June", "class_es": "Junio", "hex": "#FFFF00"},
            {"id": 7, "class_en": "July", "class_es": "Julio", "hex": "#FF9900"},
            {"id": 8, "class_en": "August", "class_es": "Agosto", "hex": "#FF3300"},
            {"id": 9, "class_en": "September", "class_es": "Setiembre", "hex": "#CC0000"},
            {"id": 10, "class_en": "October", "class_es": "Octubre", "hex": "#00CC00"},
            {"id": 11, "class_en": "November", "class_es": "Noviembre", "hex": "#009900"},
            {"id": 12, "class_en": "December", "class_es": "Diciembre", "hex": "#66FF66"},
        ])

    if product == "frequency_burned":
        return pd.DataFrame([
            {"id": 1, "class_en": "Burned once", "class_es": "Quemado 1 vez", "hex": "#FAF3CD"},
            {"id": 2, "class_en": "Burned twice", "class_es": "Quemado 2 veces", "hex": "#F9E676"},
            {"id": 3, "class_en": "Burned 3 times", "class_es": "Quemado 3 veces", "hex": "#F1CD38"},
            {"id": 4, "class_en": "Burned 4 times", "class_es": "Quemado 4 veces", "hex": "#DDA71C"},
            {"id": 5, "class_en": "Burned 5 times", "class_es": "Quemado 5 veces", "hex": "#C77E14"},
            {"id": 6, "class_en": "Burned 6 times", "class_es": "Quemado 6 veces", "hex": "#B0540F"},
            {"id": 7, "class_en": "Burned 7 times", "class_es": "Quemado 7 veces", "hex": "#992A0A"},
            {"id": 8, "class_en": "Burned 8 times", "class_es": "Quemado 8 veces", "hex": "#7B1208"},
            {"id": 9, "class_en": "Burned 9 times", "class_es": "Quemado 9 veces", "hex": "#5C0407"},
            {"id": 10, "class_en": "Burned 10 times", "class_es": "Quemado 10 veces", "hex": "#440508"},
            {"id": 11, "class_en": "Burned 11 times", "class_es": "Quemado 11 veces", "hex": "#260405"},
            {"id": 12, "class_en": "Burned 12+ times", "class_es": "Quemado 12+ veces", "hex": "#040101"},
        ])

    if product == "year_last_fire":
        return pd.DataFrame([
            {"id": y, "class_en": str(y), "class_es": str(y), "hex": h}
            for y, h in [
                (2013, "#010079"), (2014, "#00287F"), (2015, "#004D86"),
                (2016, "#07728F"), (2017, "#239B9C"), (2018, "#74B29A"),
                (2019, "#AD9963"), (2020, "#C25407"), (2021, "#AF2A13"),
                (2022, "#A01D1A"), (2023, "#911416"), (2024, "#810000"),
            ]
        ])

    if product == "annual_burned_scar_size_range":
        return pd.DataFrame([
            {"id": 1, "class_en": "< 25 ha", "class_es": "< 25 ha", "hex": "#D9B646"},
            {"id": 2, "class_en": "25 - 50 ha", "class_es": "25 - 50 ha", "hex": "#E58B2F"},
            {"id": 3, "class_en": "50 - 500 ha", "class_es": "50 - 500 ha", "hex": "#D46B27"},
            {"id": 4, "class_en": "500 - 5000 ha", "class_es": "500 - 5000 ha", "hex": "#96352A"},
            {"id": 5, "class_en": "> 5000 ha", "class_es": "> 5000 ha", "hex": "#2B110C"},
        ])

    raise ValueError(f"No hay leyenda definida para el producto '{product}'.")


def get_mapbiomas_peru_fire(
    product: str,
    year: int,
    crop_to: gpd.GeoDataFrame | gpd.GeoSeries | None = None,
    *,
    collection: int = 1,
) -> xr.DataArray:
    """Lee perezosamente un raster de MapBiomas Fuego Perú.

    Equivalente de ``get_mapbiomas_peru_fire()`` en R.

    Parameters
    ----------
    product
        Producto (ej. ``"annual_burned"``, ``"frequency_burned"``).
    year
        Año (para productos anuales) o año final (para productos de rango).
    crop_to
        Geometría opcional para recortar.
    collection
        Colección (solo 1 disponible actualmente).

    Returns
    -------
    xarray.DataArray
        Raster del producto solicitado.
    """
    import geopandas as gpd
    import requests

    xr_mod = _require_rioxarray()
    import rioxarray  # noqa: F401

    products_df = get_mapbiomas_peru_fire_products()
    if product not in products_df["product"].values:
        raise ValueError(f"Producto inválido '{product}'.")

    if collection != 1:
        raise ValueError("Solo la colección 1 está disponible para MapBiomas Fuego.")

    temporal = products_df.loc[products_df["product"] == product, "temporal"].iloc[0]
    folder, suffix = FIRE_FILE_MAP[product]

    base_url = (
        f"https://storage.googleapis.com/shared-development-storage/"
        f"COLLECTIONS/PERU/FIRE/COLLECTION{collection}/{folder}/{folder}-{suffix}"
    )

    if temporal == "range":
        if year < 2014:
            raise ValueError(f"Año {year} inválido para rango. Use >= 2014.")
        url = f"{base_url}_2013_{year}.tif"
    else:
        if year < 1999:
            raise ValueError(f"Año {year} inválido. Productos anuales desde 1999.")
        url = f"{base_url}_{year}.tif"

    # Verificar que existe
    head_resp = requests.head(url, timeout=30)
    head_resp.raise_for_status()

    vsi_url = f"/vsicurl/{url}"
    da = xr_mod.open_dataarray(vsi_url, engine="rasterio")
    da.name = f"{product}_{year}"

    if crop_to is not None:
        if isinstance(crop_to, gpd.GeoDataFrame):
            geom = crop_to.to_crs(da.rio.crs).geometry
        elif isinstance(crop_to, gpd.GeoSeries):
            geom = crop_to.to_crs(da.rio.crs)
        else:
            raise TypeError("`crop_to` debe ser GeoDataFrame o GeoSeries.")
        da = da.rio.clip(geom, drop=True, from_disk=True, all_touched=True)

    return da


def get_mapbiomas_peru_legend() -> pd.DataFrame:
    """Leyenda oficial de MapBiomas Perú (Colección 3).

    Returns
    -------
    pandas.DataFrame
        Columnas: id, class_en, class_es, hex.
    """
    import pandas as pd

    return pd.DataFrame([
        {"id": 1, "class_en": "Forest formation", "class_es": "Formación boscosa", "hex": "#1f8d49"},
        {"id": 3, "class_en": "Forest", "class_es": "Bosque", "hex": "#1f8d49"},
        {"id": 4, "class_en": "Dry forest", "class_es": "Bosque seco", "hex": "#7dc975"},
        {"id": 5, "class_en": "Mangrove", "class_es": "Manglar", "hex": "#04381d"},
        {"id": 6, "class_en": "Flooded forest", "class_es": "Bosque inundable", "hex": "#026975"},
        {"id": 10, "class_en": "Non-forest formation", "class_es": "Formación natural no boscosa", "hex": "#d6bc74"},
        {"id": 11, "class_en": "Swamp or Flooded Grassland", "class_es": "Zona pantanosa o pastizal inundable", "hex": "#519799"},
        {"id": 12, "class_en": "Grasslands / herbaceous", "class_es": "Pastizal / herbazal", "hex": "#d6bc74"},
        {"id": 29, "class_en": "Rocky Outcrop", "class_es": "Afloramiento rocoso", "hex": "#ffaa5f"},
        {"id": 66, "class_en": "Scrubland", "class_es": "Matorral", "hex": "#a89358"},
        {"id": 70, "class_en": "Fog oasis", "class_es": "Loma costera", "hex": "#be9e00"},
        {"id": 13, "class_en": "Other non-forest formations", "class_es": "Otra formación no boscosa", "hex": "#d89f5c"},
        {"id": 14, "class_en": "Agricultural area", "class_es": "Área agropecuaria", "hex": "#ffefc3"},
        {"id": 15, "class_en": "Pasture", "class_es": "Pasto", "hex": "#edde8e"},
        {"id": 18, "class_en": "Agriculture", "class_es": "Agricultura", "hex": "#e974ed"},
        {"id": 35, "class_en": "Oil palm", "class_es": "Palma aceitera", "hex": "#9065d0"},
        {"id": 40, "class_en": "Rice", "class_es": "Arroz", "hex": "#c71585"},
        {"id": 72, "class_en": "Other crops", "class_es": "Otros cultivos", "hex": "#910046"},
        {"id": 9, "class_en": "Planted forest", "class_es": "Plantación forestal", "hex": "#7a5900"},
        {"id": 21, "class_en": "Mosaic of agriculture and pasture", "class_es": "Mosaico agropecuario", "hex": "#ffefc3"},
        {"id": 22, "class_en": "Non-vegetated area", "class_es": "Área sin vegetación", "hex": "#d4271e"},
        {"id": 23, "class_en": "Beach", "class_es": "Playa", "hex": "#ffa07a"},
        {"id": 24, "class_en": "Infrastructure", "class_es": "Infraestructura urbana", "hex": "#d4271e"},
        {"id": 30, "class_en": "Mining", "class_es": "Minería", "hex": "#9c0027"},
        {"id": 32, "class_en": "Coastal Salt flat", "class_es": "Salina costera", "hex": "#fc8114"},
        {"id": 61, "class_en": "Salt flat", "class_es": "Salar", "hex": "#f5d5d5"},
        {"id": 68, "class_en": "Other natural non vegetated area", "class_es": "Otra área natural sin vegetación", "hex": "#E97A7A"},
        {"id": 25, "class_en": "Other non vegetated area", "class_es": "Otra área sin vegetación", "hex": "#db4d4f"},
        {"id": 26, "class_en": "Water body", "class_es": "Cuerpo de agua", "hex": "#2532e4"},
        {"id": 33, "class_en": "River, lake or ocean", "class_es": "Río, lago u océano", "hex": "#2532e4"},
        {"id": 31, "class_en": "Aquaculture", "class_es": "Acuicultura", "hex": "#091077"},
        {"id": 34, "class_en": "Glacier", "class_es": "Glaciar", "hex": "#93dfe6"},
        {"id": 27, "class_en": "Not observed", "class_es": "No observado", "hex": "#ffffff"},
    ])


# ────────────────────────────────────────────────────────────
# Visualización
# ────────────────────────────────────────────────────────────


def _plot_raster_rgb(
    da: xr.DataArray,
    legend: pd.DataFrame,
    figsize: tuple[int, int] = (12, 10),
    legend_kwds: dict | None = None,
    legend_title: str = "",
    label_col: str = "class_es",
) -> plt.Figure:
    """Renderiza un raster clasificado como RGB con su leyenda."""
    import matplotlib.pyplot as plt
    import numpy as np
    from matplotlib.colors import to_rgb
    from matplotlib.patches import Patch

    id_to_hex = dict(zip(legend["id"], legend["hex"], strict=True))

    classes = np.squeeze(da.values)
    unique_ids = np.unique(classes)
    unique_ids = unique_ids[np.isin(unique_ids, list(id_to_hex.keys()))]

    h, w = classes.shape
    rgb = np.zeros((h, w, 3), dtype=np.uint8)
    for cid in unique_ids:
        mask = classes == cid
        rgb[mask] = np.array(to_rgb(id_to_hex[cid])) * 255

    fig, ax = plt.subplots(figsize=figsize)
    ax.imshow(rgb)
    ax.set_aspect("equal")
    ax.axis("off")

    kw = {
        "loc": "lower left",
        "bbox_to_anchor": (1.02, 0),
        "frameon": False,
        "title": legend_title,
        "fontsize": 6,
        "title_fontsize": 8,
    }
    if legend_kwds:
        kw.update(legend_kwds)

    patches = [Patch(color=row["hex"], label=row[label_col]) for _, row in legend.iterrows()]
    ax.legend(handles=patches, **kw)
    plt.tight_layout()
    return fig


def plot_mapbiomas_lulc(
    da: xr.DataArray,
    figsize: tuple[int, int] = (12, 10),
    legend_kwds: dict | None = None,
) -> plt.Figure:
    """Visualiza un raster LULC de MapBiomas Perú con su leyenda.

    Parameters
    ----------
    da
        DataArray devuelto por :func:`get_mapbiomas_peru_lulc`.
    figsize
        Tamaño de la figura (ancho, alto).
    legend_kwds
        Argumentos adicionales para ``ax.legend()`` (ej. ``fontsize``, ``title``).

    Returns
    -------
    matplotlib.figure.Figure
    """
    legend = get_mapbiomas_peru_legend()
    return _plot_raster_rgb(
        da, legend, figsize=figsize, legend_kwds=legend_kwds,
        legend_title="Cobertura",
    )


def plot_mapbiomas_fire(
    da: xr.DataArray,
    product: str,
    figsize: tuple[int, int] = (12, 10),
    legend_kwds: dict | None = None,
) -> plt.Figure:
    """Visualiza un raster de MapBiomas Fuego Perú con su leyenda.

    Parameters
    ----------
    da
        DataArray devuelto por :func:`get_mapbiomas_peru_fire`.
    product
        Nombre del producto (ej. ``"annual_burned"``, ``"frequency_burned"``).
    figsize
        Tamaño de la figura (ancho, alto).
    legend_kwds
        Argumentos adicionales para ``ax.legend()`` (ej. ``fontsize``, ``title``).

    Returns
    -------
    matplotlib.figure.Figure
    """
    legend = get_mapbiomas_peru_fire_legend(product)
    products_df = get_mapbiomas_peru_fire_products()
    title = products_df.loc[products_df["product"] == product, "description_es"].iloc[0]
    return _plot_raster_rgb(
        da, legend, figsize=figsize, legend_kwds=legend_kwds,
        legend_title=title,
    )


__all__ = [
    "get_mapbiomas_peru_lulc",
    "get_mapbiomas_peru_lulc_series",
    "get_mapbiomas_peru_lulc_url",
    "get_mapbiomas_peru_alerta",
    "get_mapbiomas_alert_images",
    "get_mapbiomas_peru_fire",
    "get_mapbiomas_peru_fire_products",
    "get_mapbiomas_peru_fire_legend",
    "get_mapbiomas_peru_legend",
    "plot_mapbiomas_fire",
    "plot_mapbiomas_lulc",
]
