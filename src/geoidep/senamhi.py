"""Alertas meteorológicas del SENAMHI.

Equivalente Python de ``R/get_senamhi.R``.
"""

from __future__ import annotations

import re
from pathlib import Path
from typing import TYPE_CHECKING

from ._download import DEFAULT_HEADERS, download_file, extract_zip
from ._endpoints import SENAMHI_URLS

if TYPE_CHECKING:
    import geopandas as gpd
    import pandas as pd


def senamhi_get_meteorological_table() -> pd.DataFrame:
    """Obtiene la tabla de avisos meteorológicos vigentes del SENAMHI.

    Hace scraping de la página web de avisos meteorológicos.

    Returns
    -------
    pandas.DataFrame
        Columnas: aviso, nro, emision, inicio, fin, duracion, nivel.
    """
    import pandas as pd
    import requests
    from bs4 import BeautifulSoup

    url = SENAMHI_URLS["aviso_meteorologico"]
    resp = requests.get(url, timeout=60, headers=DEFAULT_HEADERS)
    resp.raise_for_status()

    soup = BeautifulSoup(resp.text, "html.parser")
    tables = soup.find_all("table")
    if not tables:
        raise ValueError("No se encontraron tablas en la página del SENAMHI.")

    rows = []
    for tr in tables[0].find_all("tr")[1:]:
        cells = [td.get_text(strip=True) for td in tr.find_all("td")]
        if len(cells) >= 7:
            rows.append(cells[:7])

    if not rows:
        return pd.DataFrame(columns=["aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel"])

    df = pd.DataFrame(rows, columns=["aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel"])
    df["nro"] = df["nro"].str.replace(r"\D", "", regex=True)
    return df


def senamhi_alert_by_number(data: pd.DataFrame, nro: int | str | list[int]) -> pd.DataFrame:
    """Filtra avisos meteorológicos por número(s) de aviso.

    Parameters
    ----------
    data : pd.DataFrame
        Tabla de avisos (output de ``senamhi_get_meteorological_table``).
    nro : int or str or list of int
        Número(s) de aviso a filtrar.

    Returns
    -------
        pd.DataFrame
        Filas filtradas.
    """
    import pandas as pd

    df = data.copy()
    df["nro_clean"] = pd.to_numeric(df["nro"].str.replace(r"\D", "", regex=True), errors="coerce")
    nros = [nro] if isinstance(nro, (int, str)) else list(nro)
    nros_clean = [int(re.sub(r"\D", "", str(n))) for n in nros]
    return df.loc[df["nro_clean"].isin(nros_clean)].drop(columns=["nro_clean"]).reset_index(drop=True)


def senamhi_alerts_by_year(data: pd.DataFrame, year: int) -> pd.DataFrame:
    """Filtra avisos meteorológicos por año de emisión.

    Parameters
    ----------
    data : pd.DataFrame
        Tabla de avisos.
    year : int
        Año a filtrar.

    Returns
    -------
    pd.DataFrame
        Filas filtradas.
    """
    return data.loc[data["emision"].str.startswith(str(year))].reset_index(drop=True)


def senamhi_get_spatial_alerts(
    data: pd.DataFrame | None = None,
    *,
    nro: int | str | None = None,
    year: int | None = None,
    dsn: str | Path | None = None,
    show_progress: bool = True,
    timeout: int = 60,
) -> gpd.GeoDataFrame:
    """Descarga la geometría de un aviso meteorológico del SENAMHI.

    Parameters
    ----------
    data : pd.DataFrame, opcional
        Tabla con una única fila de aviso (con columnas ``nro`` y ``emision``).
    nro : int or str, opcional
        Número de aviso (si no se provee ``data``).
    year : int, opcional
        Año del aviso (si no se provee ``data``).
    dsn : str or Path, opcional
        Ruta para guardar el zip descargado.
    show_progress : bool
        Mostrar barra de progreso.
    timeout : int
        Timeout en segundos.

    Returns
    -------
    geopandas.GeoDataFrame
        Geometría del aviso.
    """
    import geopandas as gpd

    if data is not None:
        nro_val = int(re.sub(r"\D", "", str(data["nro"].iloc[0])))
        year_val = int(data["emision"].iloc[0][:4])
    elif nro is not None and year is not None:
        nro_val = int(re.sub(r"\D", "", str(nro)))
        year_val = int(year)
    else:
        raise ValueError("Debe proporcionar `data` o ambos `nro` y `year`.")

    base_url = SENAMHI_URLS["aviso_meterologico_geom"]
    url = (
        f"{base_url}?"
        f"service=WFS&version=1.0.0&request=GetFeature"
        f"&typeName=g_aviso:view_aviso"
        f"&format_options=filename:shp_aviso_{nro_val}_1_{year_val}.zip"
        f"&maxFeatures=50"
        f"&viewparams=qry:{nro_val}_1_{year_val}"
        f"&outputFormat=SHAPE-ZIP"
    )

    zip_path = download_file(url, dsn=dsn, show_progress=show_progress, timeout=timeout)
    extract_dir = extract_zip(zip_path)
    shp_files = list(Path(extract_dir).rglob("*.shp"))
    if not shp_files:
        raise FileNotFoundError(f"No se encontró archivo .shp en {extract_dir}")
    return gpd.read_file(shp_files[0])


def senamhi_geometry_by_level(sf_data: gpd.GeoDataFrame, level: int | str | list[int]) -> gpd.GeoDataFrame:
    """Filtra geometrías de aviso por nivel de peligro (1-4).

    Parameters
    ----------
    sf_data : geopandas.GeoDataFrame
        Geometrías descargadas con ``senamhi_get_spatial_alerts``.
    level : int, str, or list
        Nivel(es) a filtrar (1, 2, 3, 4 o 'Nivel 1', etc.).

    Returns
    -------
        geopandas.GeoDataFrame
        Geometrías filtradas.
    """
    import geopandas as gpd

    if not isinstance(sf_data, gpd.GeoDataFrame):
        raise TypeError("El input debe ser un GeoDataFrame.")

    if isinstance(level, list):
        levels = [f"Nivel {lev}" if isinstance(lev, int) else lev for lev in level]
    elif isinstance(level, int):
        levels = [f"Nivel {level}"]
    else:
        levels = [level]

    return sf_data.loc[sf_data["nivel"].isin(levels)].reset_index(drop=True)


__all__ = [
    "senamhi_get_meteorological_table",
    "senamhi_alert_by_number",
    "senamhi_alerts_by_year",
    "senamhi_get_spatial_alerts",
    "senamhi_geometry_by_level",
]
