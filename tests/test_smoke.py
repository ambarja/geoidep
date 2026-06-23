"""Tests de humo. No realizan llamadas de red: validan estructura,
endpoints estáticos y comportamiento de funciones puras.
"""

from __future__ import annotations

import pytest


def test_imports_principales():
    """Las funciones públicas más usadas existen y son llamables."""
    import geoidep as gd

    for nombre in [
        "get_departaments", "get_provinces", "get_districts",
        "get_forest_loss_data", "get_early_warning",
        "get_sernanp_data", "list_sernanp_layers",
        "get_hotspots_data", "get_forest_fire_data",
        "get_data_sources", "get_providers",
        "get_mapbiomas_peru_lulc", "get_mapbiomas_peru_lulc_url",
        "get_mapbiomas_peru_alerta", "get_mapbiomas_alert_images",
        "get_mapbiomas_peru_fire", "get_mapbiomas_peru_fire_products",
        "get_mapbiomas_peru_fire_legend", "get_mapbiomas_peru_legend",
        "get_mtc_data", "list_mtc_layers",
        "get_inaigem_data", "list_inaigem_layers",
        "get_hazard_data", "list_sigrid_layers",
        "get_midagri_data", "list_midagri_layers",
        "senamhi_get_meteorological_table", "senamhi_alert_by_number",
        "senamhi_alerts_by_year", "senamhi_get_spatial_alerts",
        "senamhi_geometry_by_level",
        "mapbiomas_peru_lulc_palette", "mapbiomas_peru_lulc_palette_by_id",
        "mapbiomas_peru_fire_palette", "mapbiomas_peru_fire_palette_by_id",
    ]:
        assert callable(getattr(gd, nombre)), f"{nombre} no es callable"


def test_inei_links_validos():
    from geoidep._endpoints import get_inei_link

    for tipo in ("distrito", "provincia", "departamento"):
        url = get_inei_link(tipo)
        assert url.endswith(".rar")
        assert "inei.gob.pe" in url

    with pytest.raises(ValueError):
        get_inei_link("region")


def test_geobosque_link_distrito():
    from geoidep._endpoints import get_geobosque_link

    url = get_geobosque_link("stock_bosque_perdida_distrito")
    assert "geobosques.minam.gob.pe" in url
    assert url.endswith("stockBosquePerdidaDistrito")


def test_sernanp_layers_completas():
    from geoidep._endpoints import SERNANP_LINKS, list_sernanp_layers

    layers = list_sernanp_layers()
    assert "anp_nacional" in layers
    assert "zonificacion_anp" in layers
    assert len(layers) == 61
    assert all("sernanp.gob.pe" in u for u in SERNANP_LINKS.values())


def test_mapbiomas_url_pattern():
    from geoidep._endpoints import get_mapbiomas_peru_lulc_url

    url = get_mapbiomas_peru_lulc_url(2024, collection=3)
    assert url == (
        "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/"
        "collection_3/LULC/"
        "peru_collection3_integration_v1-classification_2024.tif"
    )
    with pytest.raises(ValueError):
        get_mapbiomas_peru_lulc_url(2030)
    with pytest.raises(ValueError):
        get_mapbiomas_peru_lulc_url(2020, collection=99)


def test_forest_loss_valida_ubigeo():
    from geoidep import get_forest_loss_data

    with pytest.raises(ValueError):
        get_forest_loss_data("stock_bosque_perdida_distrito", "01")

    with pytest.raises(ValueError):
        get_forest_loss_data("capa_inexistente", "010101")


def test_as_datetime_helper():
    from geoidep._download import as_datetime

    dt = as_datetime(1_700_000_000_000)
    assert dt is not None
    assert dt.year >= 2023
    assert as_datetime(None) is None
    assert as_datetime("abc") is None


def test_mtc_endpoints():
    from geoidep._endpoints import get_mtc_link, list_mtc_layers

    layers = list_mtc_layers()
    assert "aerodromos_2023" in layers
    assert "red_vial_nacional_2024" in layers

    url = get_mtc_link("aerodromos_2023")
    assert "swmapas.mtc.gob.pe" in url
    assert "aerodromos_dic23" in url

    with pytest.raises(ValueError):
        get_mtc_link("capa_inexistente")


def test_inaigem_endpoints():
    from geoidep._endpoints import get_inaigem_link, list_inaigem_layers

    layers = list_inaigem_layers()
    assert "glaciares_1989" in layers
    assert "lagunas_con_riesgo_desborde" in layers

    url = get_inaigem_link("glaciares_1989")
    assert "services6.arcgis.com" in url

    with pytest.raises(ValueError):
        get_inaigem_link("capa_inexistente")


def test_sigrid_endpoints():
    from geoidep._endpoints import get_sigrid_link, list_sigrid_layers

    layers = list_sigrid_layers()
    assert "inundacion_inventario" in layers
    assert "movimiento_masa_inventario" in layers

    url = get_sigrid_link("inundacion_inventario")
    assert "sigrid.cenepred.gob.pe" in url

    with pytest.raises(ValueError):
        get_sigrid_link("capa_inexistente")


def test_midagri_endpoints():
    from geoidep._endpoints import get_midagri_link, list_midagri_layers

    layers = list_midagri_layers()
    assert "agriculture_sector" in layers

    url = get_midagri_link("agriculture_sector")
    assert "siea.midagri.gob.pe" in url


def test_mapbiomas_fire_products():
    from geoidep.mapbiomas import get_mapbiomas_peru_fire_products

    df = get_mapbiomas_peru_fire_products()
    assert len(df) == 8
    assert "annual_burned" in df["product"].values


def test_mapbiomas_fire_legend():
    from geoidep.mapbiomas import get_mapbiomas_peru_fire_legend

    legend = get_mapbiomas_peru_fire_legend("frequency_burned")
    assert len(legend) == 12
    assert "class_en" in legend.columns
    assert "hex" in legend.columns

    with pytest.raises(ValueError):
        get_mapbiomas_peru_fire_legend("producto_inexistente")


def test_mapbiomas_peru_legend():
    from geoidep.mapbiomas import get_mapbiomas_peru_legend

    legend = get_mapbiomas_peru_legend()
    assert len(legend) >= 25
    assert "Forest formation" in legend["class_en"].values
    assert "Formación boscosa" in legend["class_es"].values


def test_palettes():
    from geoidep.palettes import (
        mapbiomas_peru_fire_palette,
        mapbiomas_peru_fire_palette_by_id,
        mapbiomas_peru_lulc_palette,
        mapbiomas_peru_lulc_palette_by_id,
    )

    pal_es = mapbiomas_peru_lulc_palette("es")
    assert "Bosque" in pal_es
    assert pal_es["Bosque"] == "#1f8d49"

    pal_id = mapbiomas_peru_lulc_palette_by_id()
    assert pal_id[3] == "#1f8d49"

    fire_pal = mapbiomas_peru_fire_palette("frequency_burned")
    assert "Burned once" in fire_pal

    fire_pal_id = mapbiomas_peru_fire_palette_by_id("frequency_burned")
    assert fire_pal_id[1] == "#FAF3CD"


def test_senamhi_funciones_puras():
    """Prueba las funciones de filtrado SENAMHI sin red."""
    from geoidep.senamhi import senamhi_alert_by_number, senamhi_alerts_by_year
    import pandas as pd

    data = pd.DataFrame({
        "aviso": ["A", "B"],
        "nro": ["295", "296"],
        "emision": ["2024-01-15", "2024-02-20"],
        "inicio": ["", ""],
        "fin": ["", ""],
        "duracion": ["", ""],
        "nivel": ["3", "4"],
    })

    filtrado = senamhi_alert_by_number(data, 295)
    assert len(filtrado) == 1
    assert filtrado["nro"].iloc[0] == "295"

    filtrado_year = senamhi_alerts_by_year(data, 2024)
    assert len(filtrado_year) == 2

    filtrado_year2 = senamhi_alerts_by_year(data, 2023)
    assert len(filtrado_year2) == 0
