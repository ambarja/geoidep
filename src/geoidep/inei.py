"""Capas oficiales de límites político-administrativos del INEI.

Equivalente de ``R/get_departaments.R``, ``R/get_provinces.R`` y
``R/get_districts.R``.
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import download_file, extract_rar, find_first
from ._endpoints import get_inei_link

if TYPE_CHECKING:
    import geopandas as gpd


def _get_inei_boundary(
    level: str,
    *,
    nombre: str | list[str] | None = None,
    nombre_col: str,
    dsn: str | Path | None = None,
    show_progress: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame:
    """Lógica común: descarga el .rar, extrae el .gpkg y filtra por nombre."""
    import geopandas as gpd

    url = get_inei_link(level)
    rar_path = download_file(
        url,
        dsn=None,                     # forzamos temp .rar interno
        show_progress=show_progress,
        timeout=timeout,
    )
    out_dir = extract_rar(rar_path)
    gpkg = find_first(out_dir, "*.gpkg")
    gdf = gpd.read_file(gpkg)

    if nombre is not None:
        nombres = [nombre] if isinstance(nombre, str) else list(nombre)
        nombres_upper = [n.upper() for n in nombres]
        gdf = gdf.loc[gdf[nombre_col].str.upper().isin(nombres_upper)].reset_index(drop=True)

    if dsn is not None:
        dsn = Path(dsn)
        dsn.parent.mkdir(parents=True, exist_ok=True)
        if dsn.suffix.lower() != ".gpkg":
            dsn = dsn.with_suffix(".gpkg")
        gdf.to_file(dsn, driver="GPKG")

    return gdf


def get_departaments(
    departamento: str | list[str] | None = None,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame:
    """Descarga los límites departamentales oficiales del INEI.

    Parameters
    ----------
    departamento
        Nombre del departamento (case-insensitive) o lista. Si es
        ``None`` devuelve los 24 departamentos + Callao.
    dsn
        Ruta opcional ``.gpkg`` donde guardar el resultado.
    show_progress
        Mostrar barra de progreso de descarga.
    timeout
        Timeout en segundos.

    Returns
    -------
    geopandas.GeoDataFrame
        Con columnas como ``ccdd``, ``nombdep``, ``fuente``, ``geometry``.
        CRS: EPSG:4326 (WGS 84).
    """
    return _get_inei_boundary(
        "departamento",
        nombre=departamento,
        nombre_col="nombdep",
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )


# Alias en inglés "correcto" (la R-package mantiene el typo histórico).
get_departments = get_departaments


def get_provinces(
    provincia: str | list[str] | None = None,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame:
    """Descarga los límites provinciales oficiales del INEI.

    Las provincias del Perú (~196). Devuelve un GeoDataFrame con
    ``ccdd``, ``ccpp``, ``nombprov``, ``nombdep`` y geometría.
    """
    return _get_inei_boundary(
        "provincia",
        nombre=provincia,
        nombre_col="nombprov",
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )


def get_districts(
    distrito: str | list[str] | None = None,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame:
    """Descarga los límites distritales oficiales del INEI (~1.870 distritos)."""
    return _get_inei_boundary(
        "distrito",
        nombre=distrito,
        nombre_col="nombdist",
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )
