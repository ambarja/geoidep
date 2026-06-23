"""Datos del SIGRID — peligros y riesgos de desastres.

Equivalente Python de ``R/get_sigrid_data.R`` (``get_hazard_data`` en R).
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import download_file

if TYPE_CHECKING:
    import geopandas as gpd
from ._endpoints import get_sigrid_link, list_sigrid_layers

__all__ = ["get_hazard_data", "list_sigrid_layers"]


def get_hazard_data(
    layer: str,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 60,
    quiet: bool = True,
) -> gpd.GeoDataFrame:
    """Descarga una capa de peligros del SIGRID (CENEPRED).

    Parameters
    ----------
    layer
        Nombre de la capa. Usa ``list_sigrid_layers()`` para ver opciones
        (ej. ``"inundacion_inventario"``, ``"movimiento_masa_inventario"``).
    dsn
        Ruta opcional.
    show_progress
        Mostrar barra de progreso.
    timeout
        Timeout en segundos.
    quiet
        Suprimir mensajes.

    Returns
    -------
    geopandas.GeoDataFrame
        Capa de peligro solicitada.
    """
    import geopandas as gpd

    url = get_sigrid_link(layer)
    query_url = f"{url}?where=1%3D1&outFields=*&f=geojson"
    file_path = download_file(query_url, dsn=dsn, show_progress=show_progress, timeout=timeout)
    return gpd.read_file(file_path)
