"""Datos del MTC — Ministerio de Transportes y Comunicaciones.

Equivalente Python de ``R/get_mtc_data.R``.
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import download_file

if TYPE_CHECKING:
    import geopandas as gpd
from ._endpoints import get_mtc_link, list_mtc_layers

__all__ = ["get_mtc_data", "list_mtc_layers"]


def get_mtc_data(
    layer: str,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 30,
    quiet: bool = True,
) -> gpd.GeoDataFrame:
    """Descarga una capa del geoportal del MTC.

    Parameters
    ----------
    layer
        Nombre de la capa. Usa ``list_mtc_layers()`` para ver opciones
        (ej. ``"aerodromos_2023"``, ``"red_vial_nacional_2023"``).
    dsn
        Ruta opcional donde guardar el archivo descargado.
    show_progress
        Mostrar barra de progreso.
    timeout
        Timeout en segundos. El servidor MTC puede ser lento.
    quiet
        Suprimir mensajes informativos.

    Returns
    -------
    geopandas.GeoDataFrame
        Capa solicitada en EPSG:4326 con nombres de columna en minúscula.
    """
    import geopandas as gpd

    url = get_mtc_link(layer, output_format="json")
    file_path = download_file(url, dsn=dsn, show_progress=show_progress, timeout=timeout)

    gdf = gpd.read_file(file_path)
    if "gml_id" in gdf.columns:
        gdf = gdf.drop(columns=["gml_id"])

    non_geom = [c for c in gdf.columns if c.lower() not in ("geom", "geometry")]
    gdf = gdf.rename(columns={c: c.lower() for c in non_geom})
    if gdf.crs is None:
        gdf = gdf.set_crs("EPSG:4326")
    return gdf
