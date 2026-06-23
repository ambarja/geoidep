"""Paletas de colores oficiales de MapBiomas Perú.

Equivalente Python de las funciones ggplot2:
- ``scale_fill_mapbiomas_peru_lulc_d``
- ``scale_fill_mapbiomas_peru_fire_d``

En lugar de scales de ggplot2, devolvemos diccionarios ``{codigo: hex}``
para usar con matplotlib, plotly, o cualquier librería de visualización.
"""

from __future__ import annotations

from .mapbiomas import get_mapbiomas_peru_fire_legend, get_mapbiomas_peru_legend


def mapbiomas_peru_lulc_palette(lang: str = "en") -> dict:
    """Paleta de colores oficial de MapBiomas Perú LULC.

    Parameters
    ----------
    lang
        ``"en"`` (inglés) o ``"es"`` (español). Solo afecta las claves
        del diccionario.

    Returns
    -------
    dict
        ``{class_name: hex_color}``
    """
    legend = get_mapbiomas_peru_legend()
    label_col = "class_en" if lang == "en" else "class_es"
    return dict(zip(legend[label_col], legend["hex"], strict=True))


def mapbiomas_peru_lulc_palette_by_id() -> dict[int, str]:
    """Paleta de colores MapBiomas Perú LULC por código numérico.

    Returns
    -------
    dict[int, str]
        ``{id: hex_color}``
    """
    legend = get_mapbiomas_peru_legend()
    return dict(zip(legend["id"], legend["hex"], strict=True))


def mapbiomas_peru_fire_palette(product: str, lang: str = "en") -> dict:
    """Paleta de colores oficial de MapBiomas Fuego Perú.

    Parameters
    ----------
    product
        Nombre del producto (ej. ``"frequency_burned"``).
    lang
        ``"en"`` o ``"es"``.

    Returns
    -------
    dict
        ``{class_name: hex_color}``
    """
    legend = get_mapbiomas_peru_fire_legend(product)
    label_col = "class_en" if lang == "en" else "class_es"
    return dict(zip(legend[label_col], legend["hex"], strict=True))


def mapbiomas_peru_fire_palette_by_id(product: str) -> dict[int, str]:
    """Paleta de colores MapBiomas Fuego Perú por código numérico.

    Returns
    -------
    dict[int, str]
        ``{id: hex_color}``
    """
    legend = get_mapbiomas_peru_fire_legend(product)
    return dict(zip(legend["id"], legend["hex"], strict=True))


__all__ = [
    "mapbiomas_peru_lulc_palette",
    "mapbiomas_peru_lulc_palette_by_id",
    "mapbiomas_peru_fire_palette",
    "mapbiomas_peru_fire_palette_by_id",
]
