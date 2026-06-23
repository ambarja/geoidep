"""Datos de Geobosque (MINAM): pérdida histórica y alertas tempranas."""

from __future__ import annotations

import json
from typing import TYPE_CHECKING, Any

from ._download import DEFAULT_HEADERS
from ._endpoints import get_early_warning_link, get_geobosque_link

if TYPE_CHECKING:
    import geopandas as gpd
    import pandas as pd
    from shapely.geometry.base import BaseGeometry

# Longitudes esperadas del ubigeo según el nivel administrativo
_UBIGEO_LENGTH = {
    "stock_bosque_perdida_distrito":     6,
    "stock_bosque_perdida_provincia":    4,
    "stock_bosque_perdida_departamento": 2,
}


def get_forest_loss_data(
    layer: str,
    ubigeo: str,
    *,
    timeout: int = 60,
) -> pd.DataFrame:
    """Pérdida de bosque histórica por distrito, provincia o departamento.

    Equivalente de ``get_forest_loss_data()`` en R. Hace un ``POST``
    al API de Geobosque con un cuerpo JSON ``{"ubigeo": "..."}``.

    Parameters
    ----------
    layer
        Una de:

        - ``"stock_bosque_perdida_distrito"`` (ubigeo de 6 dígitos)
        - ``"stock_bosque_perdida_provincia"`` (ubigeo de 4 dígitos)
        - ``"stock_bosque_perdida_departamento"`` (ubigeo de 2 dígitos)
    ubigeo
        Código de ubicación geográfica. La longitud debe coincidir con
        el nivel elegido.
    timeout
        Timeout en segundos.

    Returns
    -------
    pandas.DataFrame
        Con columnas ``anio``, ``perdida``, ``rango1``..``rango5``,
        ``tipobosque`` y ``ubigeo``.

    Examples
    --------
    >>> from geoidep import get_forest_loss_data
    >>> df = get_forest_loss_data(
    ...     "stock_bosque_perdida_distrito", ubigeo="010101")
    """
    import pandas as pd
    import requests

    if layer not in _UBIGEO_LENGTH:
        raise ValueError(
            f"Capa '{layer}' inválida. Use una de: {list(_UBIGEO_LENGTH)}"
        )
    expected_len = _UBIGEO_LENGTH[layer]
    if not (isinstance(ubigeo, str) and len(ubigeo) == expected_len):
        raise ValueError(
            f"El ubigeo debe ser una cadena de {expected_len} caracteres "
            f"para la capa {layer}."
        )

    url = get_geobosque_link(layer)
    resp = requests.post(
        url,
        json={"ubigeo": ubigeo},
        headers=DEFAULT_HEADERS,
        timeout=timeout,
    )
    resp.raise_for_status()

    # El servicio ocasionalmente antepone un BOM UTF-8
    text = resp.content.decode("utf-8-sig", errors="replace")
    payload: dict[str, Any] = json.loads(text)

    rangos = payload.get("perdida_rangos", [])
    df = pd.DataFrame(rangos)
    # Quitar guiones bajos colgantes en nombres de columnas
    df = df.rename(columns=lambda c: c.rstrip("_"))
    # Convertir columnas numéricas almacenadas como string
    for c in df.columns:
        df[c] = pd.to_numeric(df[c], errors="ignore")
    df["ubigeo"] = ubigeo
    return df


def get_early_warning(
    region: gpd.GeoDataFrame | gpd.GeoSeries | BaseGeometry,
    *,
    as_sf: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame | pd.DataFrame:
    """Alertas tempranas de deforestación de la última semana.

    Equivalente de ``get_early_warning()`` en R. Recibe un polígono en
    WGS 84 (EPSG:4326) y devuelve los puntos de alerta detectados dentro.

    Parameters
    ----------
    region
        Polígono (GeoDataFrame, GeoSeries o geometría Shapely) en
        EPSG:4326. El paquete extrae los vértices y los envía al API.
    as_sf
        Si ``True`` devuelve un GeoDataFrame en EPSG:4326. Si ``False``
        devuelve un DataFrame con columnas ``lng`` y ``lat``.
    timeout
        Timeout en segundos.

    Returns
    -------
    geopandas.GeoDataFrame | pandas.DataFrame
        Puntos de alerta de deforestación.
    """
    import geopandas as gpd
    import pandas as pd
    import requests
    from shapely.geometry.base import BaseGeometry

    # Normalizar entrada → GeoSeries en EPSG:4326
    if isinstance(region, BaseGeometry):
        geom = gpd.GeoSeries([region], crs="EPSG:4326")
    elif isinstance(region, gpd.GeoDataFrame):
        geom = region.geometry
    elif isinstance(region, gpd.GeoSeries):
        geom = region
    else:
        raise TypeError(
            "`region` debe ser GeoDataFrame, GeoSeries o geometría Shapely."
        )

    if geom.crs is None or geom.crs.to_epsg() != 4326:
        raise ValueError("La capa debe estar en EPSG:4326 (WGS 84).")

    # Aplanar a puntos y armar la cadena "lon lat, lon lat, ..."
    coords_str = ", ".join(
        f"{x} {y}" for poly in geom for x, y in poly.exterior.coords
    ) if any(g.geom_type == "Polygon" for g in geom) else ", ".join(
        f"{p.x} {p.y}"
        for p in geom.explode(ignore_index=True).geometry
        for _ in [None]
    )

    url = get_early_warning_link("warning_last_week")
    resp = requests.post(
        url,
        json={"coords": coords_str},
        headers=DEFAULT_HEADERS,
        timeout=timeout,
    )
    resp.raise_for_status()

    text = resp.content.decode("utf-8-sig", errors="replace")
    payload = json.loads(text)
    datos = payload.get("datos", [])

    df = pd.DataFrame(datos).rename(columns=lambda c: c.rstrip("_"))
    if df.empty:
        df = pd.DataFrame(columns=["lng", "lat", "descrip"])
    else:
        # El API devuelve 2 columnas: las renombramos a lng/lat
        df.columns = ["lng", "lat"][: df.shape[1]]
        df["lng"] = pd.to_numeric(df["lng"], errors="coerce")
        df["lat"] = pd.to_numeric(df["lat"], errors="coerce")
        df["descrip"] = "Warning points"

    if not as_sf:
        return df

    return gpd.GeoDataFrame(
        df,
        geometry=gpd.points_from_xy(df["lng"], df["lat"]),
        crs="EPSG:4326",
    )
