"""Catálogo de proveedores y capas disponibles (mirror del CSV original)."""

from __future__ import annotations

from typing import TYPE_CHECKING

from ._download import DEFAULT_HEADERS

if TYPE_CHECKING:
    import pandas as pd

#: CSV con la lista canónica de fuentes mantenida en el repo R original.
SOURCES_CSV_URL = (
    "https://raw.githubusercontent.com/ambarja/geoidep/main/"
    "inst/sources-idep/sources_geoidep.csv"
)


def _read_sources() -> pd.DataFrame:
    """Lee el CSV remoto con la lista de fuentes (equivalente de ``get_data``)."""
    import requests
    resp = requests.get(SOURCES_CSV_URL, timeout=30, headers=DEFAULT_HEADERS)
    resp.raise_for_status()
    from io import StringIO
    return pd.read_csv(StringIO(resp.text))


def get_data_sources(query: str | list[str] | None = None) -> pd.DataFrame:
    """Lista proveedores, descripción, año y enlace de cada capa.

    Parameters
    ----------
    query
        Nombre (o lista de nombres) de proveedor para filtrar. Si es
        ``None`` se devuelve la tabla completa.

    Returns
    -------
    pandas.DataFrame
        Con columnas como ``provider``, ``category``, ``layer``,
        ``layer_can_be_actived``, ``admin_en``, ``year``, ``link_geoportal``.

    Examples
    --------
    >>> from geoidep import get_data_sources
    >>> df = get_data_sources()
    >>> df.head()
    """
    df = _read_sources()
    if query is None:
        return df

    available = set(df["provider"].unique())
    queries = [query] if isinstance(query, str) else list(query)
    invalid = [q for q in queries if q not in available]
    if invalid:
        raise ValueError(
            f"Proveedor(es) no válido(s): {invalid}. "
            f"Disponibles: {sorted(available)}"
        )
    return df.loc[df["provider"].isin(queries)].reset_index(drop=True)


def get_providers() -> pd.DataFrame:
    """Lista los proveedores y el número de capas disponibles por cada uno.

    Returns
    -------
    pandas.DataFrame
        Con columnas ``provider`` y ``layer_count`` ordenadas alfabéticamente.
    """
    df = _read_sources()
    out = (
        df.groupby("provider", as_index=False)
          .size()
          .rename(columns={"size": "layer_count"})
          .sort_values("provider", ignore_index=True)
    )
    return out
