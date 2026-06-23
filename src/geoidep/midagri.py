"""Datos del MIDAGRI — sectores estadísticos y áreas de palma aceitera.

Equivalente Python de ``R/get_midagri_data.R`` (actualmente marcado como
deprecated en el paquete R original).
"""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import download_file, extract_zip, find_first
from ._endpoints import get_midagri_link, list_midagri_layers

if TYPE_CHECKING:
    import geopandas as gpd

__all__ = ["get_midagri_data", "list_midagri_layers"]


def get_midagri_data(
    layer: str,
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    quiet: bool = True,
) -> gpd.GeoDataFrame:
    """Descarga una capa del MIDAGRI (Ministerio de Desarrollo Agrario y Riego).

    Parameters
    ----------
    layer
        Una de: ``"agriculture_sector"`` o ``"oil_palm_areas"``.
    dsn
        Ruta opcional.
    show_progress
        Mostrar barra de progreso.
    quiet
        Suprimir mensajes informativos.

    Returns
    -------
    geopandas.GeoDataFrame
        Capa solicitada.
    """
    import geopandas as gpd

    url = get_midagri_link(layer)
    zip_path = download_file(url, dsn=dsn, show_progress=show_progress, timeout=120)
    extract_dir = extract_zip(zip_path)

    # Buscar shapefile o gpkg
    shp = find_first(extract_dir, "*.shp")
    return gpd.read_file(shp)
