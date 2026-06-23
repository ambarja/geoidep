"""Datos del INAIGEM — glaciares y lagunas de origen glaciar.

Equivalente Python de ``R/get_inaigem_data.R``.
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import download_file

if TYPE_CHECKING:
    import geopandas as gpd
from ._endpoints import get_inaigem_link, list_inaigem_layers

__all__ = ["get_inaigem_data", "list_inaigem_layers"]


def get_inaigem_data(
    layer: str,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 60,
    quiet: bool = True,
) -> gpd.GeoDataFrame:
    """Descarga una capa del geoportal del INAIGEM.

    Parameters
    ----------
    layer
        Nombre de la capa. Usa ``list_inaigem_layers()`` para ver opciones
        (ej. ``"glaciares_1989"``, ``"lagunas_con_riesgo_desborde"``).
    dsn
        Ruta opcional para guardar el GeoJSON descargado.
    show_progress
        Mostrar barra de progreso.
    timeout
        Timeout en segundos.
    quiet
        Suprimir mensajes informativos.

    Returns
    -------
    geopandas.GeoDataFrame
        Capa solicitada con nombres de columna en minúscula.
    """
    import geopandas as gpd

    url = get_inaigem_link(layer)
    query_url = f"{url}?where=1%3D1&outFields=*&f=geojson"
    file_path = download_file(query_url, dsn=dsn, show_progress=show_progress, timeout=timeout)

    gdf = gpd.read_file(file_path)
    non_geom = [c for c in gdf.columns if c.lower() not in ("geom", "geometry")]
    gdf = gdf.rename(columns={c: c.lower() for c in non_geom})
    return gdf
