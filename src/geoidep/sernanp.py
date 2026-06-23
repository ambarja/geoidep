"""Capas del SERNANP (áreas naturales protegidas y servicios afines)."""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import download_file
from ._endpoints import get_sernanp_link, list_sernanp_layers

if TYPE_CHECKING:
    import geopandas as gpd

__all__ = ["get_sernanp_data", "list_sernanp_layers"]


def get_sernanp_data(
    layer: str,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 120,
) -> gpd.GeoDataFrame:
    """Descarga una capa del visor geográfico del SERNANP.

    Usa el endpoint ArcGIS REST ``/query`` con ``f=geojson`` y
    ``where=1=1`` para traer todos los registros.

    Parameters
    ----------
    layer
        Nombre de la capa. Usa :func:`list_sernanp_layers` para ver
        las opciones (ej. ``"anp_nacional"``, ``"zonificacion_anp"``,
        ``"comunidades_nativas"``).
    dsn
        Ruta opcional donde guardar el GeoJSON. Si es ``None``, se usa
        un archivo temporal.
    show_progress
        Mostrar barra de progreso.
    timeout
        Timeout en segundos (los geoservicios del SERNANP pueden ser lentos).

    Returns
    -------
    geopandas.GeoDataFrame
        La capa solicitada con todos sus atributos.

    Examples
    --------
    >>> from geoidep import get_sernanp_data
    >>> anp = get_sernanp_data("anp_nacional")
    """
    import geopandas as gpd

    url = get_sernanp_link(layer)
    geojson_path = download_file(
        url + "?where=1%3D1&outFields=*&f=geojson",
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )
    return gpd.read_file(geojson_path)
