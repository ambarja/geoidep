"""Pruebas de las funciones de visualización plot_mapbiomas_*.

Usan el backend Agg de matplotlib (sin display) y datos sintéticos.
"""
from __future__ import annotations

import matplotlib
matplotlib.use("Agg")

import numpy as np
import pytest


def _make_raster(ids):
    """Crea un DataArray 2D simulado con los IDs de clase dados.

    Asegura al menos 2 filas × 2 columnas para que
    ``np.squeeze`` mantenga 2D.
    """
    import xarray as xr
    arr = np.array(ids, dtype=np.int16)
    n = arr.size
    ncols = min(max(n, 2), 3)
    nrows = max(2, int(np.ceil(n / ncols)))
    total = nrows * ncols
    if total > n:
        arr = np.pad(arr, (0, total - n), constant_values=0)
    arr = arr.reshape(nrows, ncols)
    return xr.DataArray(arr, dims=("y", "x"))


def test_plot_lulc_returns_figure():
    import geoidep as gd
    import matplotlib.figure

    da = _make_raster([3, 4, 5, 27, 1])
    fig = gd.plot_mapbiomas_lulc(da)
    assert isinstance(fig, matplotlib.figure.Figure)


def test_plot_lulc_custom_figsize():
    import geoidep as gd

    da = _make_raster([3, 4, 5])
    fig = gd.plot_mapbiomas_lulc(da, figsize=(6, 4))
    assert fig.get_size_inches().tolist() == [6.0, 4.0]


def test_plot_lulc_legend_kwds():
    import geoidep as gd
    import matplotlib.figure

    da = _make_raster([3, 4, 5])
    fig = gd.plot_mapbiomas_lulc(da, legend_kwds={"fontsize": 10, "title": "Test"})
    assert isinstance(fig, matplotlib.figure.Figure)


def test_plot_lulc_ids_fuera_de_leyenda():
    """IDs que no están en la leyenda no deben causar error."""
    import geoidep as gd
    import matplotlib.figure

    da = _make_raster([999, 888, 777])
    fig = gd.plot_mapbiomas_lulc(da)
    assert isinstance(fig, matplotlib.figure.Figure)


def test_plot_lulc_con_banda_extra():
    """DataArray con dimensión extra (band, y, x)."""
    import geoidep as gd
    import matplotlib.figure
    import xarray as xr

    arr = np.array([[3, 4, 5], [6, 7, 8]], dtype=np.int16).reshape(1, 2, 3)
    da = xr.DataArray(arr, dims=("band", "y", "x"))
    fig = gd.plot_mapbiomas_lulc(da)
    assert isinstance(fig, matplotlib.figure.Figure)


def test_plot_fire_returns_figure():
    """Cada producto de fuego debe poder graficarse."""
    import geoidep as gd
    import matplotlib.figure

    for product in ["annual_burned", "frequency_burned", "year_last_fire", "monthly_burned"]:
        da = _make_raster([1, 2, 3])
        fig = gd.plot_mapbiomas_fire(da, product)
        assert isinstance(fig, matplotlib.figure.Figure), f"Fallo para {product}"


def test_plot_fire_custom_params():
    import geoidep as gd

    da = _make_raster([1])
    fig = gd.plot_mapbiomas_fire(da, "annual_burned", figsize=(8, 6), legend_kwds={"title": "Fuego"})
    assert fig.get_size_inches().tolist() == [8.0, 6.0]


def test_plot_fire_product_invalido():
    import geoidep as gd

    da = _make_raster([1])
    with pytest.raises(ValueError):
        gd.plot_mapbiomas_fire(da, "producto_inexistente")


def test_plot_fire_coverage_product():
    """annual_burned_coverage usa la leyenda LULC."""
    import geoidep as gd
    import matplotlib.figure

    da = _make_raster([3, 4, 5])
    fig = gd.plot_mapbiomas_fire(da, "annual_burned_coverage")
    assert isinstance(fig, matplotlib.figure.Figure)


def test_plot_fire_annual_burned_scar_size():
    import geoidep as gd
    import matplotlib.figure

    da = _make_raster([1, 2, 3, 4, 5])
    fig = gd.plot_mapbiomas_fire(da, "annual_burned_scar_size_range")
    assert isinstance(fig, matplotlib.figure.Figure)
