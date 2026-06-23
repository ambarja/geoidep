"""Datos del SERFOR — Unidad de Monitoreo Satelital."""

from __future__ import annotations

from pathlib import Path
from typing import TYPE_CHECKING

from ._download import as_datetime, download_file
from ._endpoints import get_forest_fire_link, get_heat_spot_link

if TYPE_CHECKING:
    import geopandas as gpd

#: Columnas que vienen como timestamps en milisegundos desde Epoch (UTC).
_DATE_COLUMNS = ("FECREG", "FECHA", "created_date", "last_edited_date")


def _fetch_arcgis_layer(
    url: str,
    *,
    dsn: str | Path | None,
    show_progress: bool,
    timeout: int,
) -> gpd.GeoDataFrame:
    """Helper: descarga un layer ArcGIS como GeoJSON y normaliza fechas."""
    import geopandas as gpd
    import pandas as pd

    geojson_path = download_file(
        url + "?where=1%3D1&outFields=*&f=geojson",
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )
    gdf = gpd.read_file(geojson_path)
    for col in _DATE_COLUMNS:
        if col in gdf.columns:
            gdf[col] = gdf[col].apply(as_datetime)
            # Convertir a dtype datetime64 si los valores no son None
            gdf[col] = pd.to_datetime(gdf[col], errors="coerce", utc=True)
    return gdf


def get_hotspots_data(
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 120,
) -> gpd.GeoDataFrame:
    """Descarga los puntos de calor del SERFOR (Unidad de Monitoreo Satelital).

    Returns
    -------
    geopandas.GeoDataFrame
        Puntos de calor con columnas de fecha ya convertidas a
        ``datetime`` UTC.
    """
    return _fetch_arcgis_layer(
        get_heat_spot_link(),
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )


def get_forest_fire_data(
    dsn: str | Path | None = None,
    *,
    show_progress: bool = True,
    timeout: int = 120,
) -> gpd.GeoDataFrame:
    """Descarga los focos de incendios forestales del SERFOR.

    Returns
    -------
    geopandas.GeoDataFrame
        Focos de incendio con columnas de fecha convertidas a
        ``datetime`` UTC.
    """
    return _fetch_arcgis_layer(
        get_forest_fire_link(),
        dsn=dsn,
        show_progress=show_progress,
        timeout=timeout,
    )
