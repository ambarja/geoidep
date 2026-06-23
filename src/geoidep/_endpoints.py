"""Catálogo central de endpoints de la IDEP.

Equivalente Python del archivo ``R/utils.R`` del paquete original.
Centralizar las URLs en un único módulo facilita el mantenimiento
cuando un proveedor cambia su servicio.
"""

from __future__ import annotations

# ──────────────────────────── INEI ─────────────────────────────
# Archivos .rar con un .gpkg dentro. CRS: WGS 84 (EPSG:4326).
INEI_LINKS: dict[str, str] = {
    "distrito":     "https://ide.inei.gob.pe/files/Distrito.rar",
    "provincia":    "https://ide.inei.gob.pe/files/Provincia.rar",
    "departamento": "https://ide.inei.gob.pe/files/Departamento.rar",
}


def get_inei_link(type_: str) -> str:
    """Devuelve la URL del .rar oficial de INEI para una capa dada."""
    if type_ not in INEI_LINKS:
        raise ValueError(
            f"Tipo inválido '{type_}'. Use uno de: {list(INEI_LINKS)}"
        )
    return INEI_LINKS[type_]


# ─────────────────────────── Geobosque ─────────────────────────
# Endpoints POST que devuelven JSON.
GEOBOSQUE_FOREST_LOSS: dict[str, str] = {
    "stock_bosque_perdida_distrito":     "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaDistrito",
    "stock_bosque_perdida_provincia":    "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaProvincia",
    "stock_bosque_perdida_departamento": "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaRegion",
}

GEOBOSQUE_EARLY_WARNING: dict[str, str] = {
    "warning_last_week": "http://geobosques.minam.gob.pe/geobosque/ws/rest/ALERTAS/ultimasByCobertura",
}


def get_geobosque_link(type_: str) -> str:
    if type_ not in GEOBOSQUE_FOREST_LOSS:
        raise ValueError(
            f"Tipo inválido '{type_}'. Use uno de: {list(GEOBOSQUE_FOREST_LOSS)}"
        )
    return GEOBOSQUE_FOREST_LOSS[type_]


def get_early_warning_link(type_: str = "warning_last_week") -> str:
    if type_ not in GEOBOSQUE_EARLY_WARNING:
        raise ValueError(
            f"Tipo inválido '{type_}'. Use uno de: {list(GEOBOSQUE_EARLY_WARNING)}"
        )
    return GEOBOSQUE_EARLY_WARNING[type_]


# ───────────────────────────── Sernanp ─────────────────────────
# Servicio ArcGIS MapServer. Cada capa es un ID en /MapServer/<id>/query
_SERNANP_LAYERS = (
    "anp_nacional", "zona_reservada", "acr", "acp", "zona_amortiguamiento",
    "zonificacion_anp", "zonificacion_acr", "zonificacion_acp",
    "contratos_aprovechamiento", "acuerdos_actividad_menor", "concesion",
    "contrato_servicio_turistico", "autorizacion_predio_privado",
    "reserva_biosfera_nacional", "acuerdo", "reserva_biosfera_transfronterizo",
    "diagnostico_recursos", "planes_manejo_recursos", "pozos_exploratorios",
    "lotes_contrato", "autoridad_adm_agua", "acuiferos", "unidades_hidrograficas",
    "autoridad_local_agua", "reservas_indigenas", "cc_pueblos_indigenas",
    "cn_pueblos_indigenas", "reservas_piaci", "qhapaqnan", "mapa_pobreza_2013",
    "catastro_minero_17_sur", "catastro_minero_18_sur", "catastro_minero_19_sur",
    "predio_rural", "comunidades_nativas", "comunidades_campesinas",
    "concesiones_mineras", "concesiones_geotermica", "lineas_transmision",
    "concesiones_hidroelectricas", "concesiones_generacion",
    "concesiones_geotermica_autorizada", "concesiones_distribucion",
    "red_vial_nacional", "aerodromos", "red_vial_departamental",
    "red_vial_vecinal", "linea_ferrea", "areas_habilitadas",
    "areas_derecho_acuicolas", "zonas_pesca", "derechos_acuicolas",
    "clasificacion_climatica", "red_estaciones", "bosques_locales",
    "concesiones", "ecosistemas_fragiles", "bosque_produccion_permanente",
    "bosques_protectores", "mapa_ecosistemas_2018", "ecorregiones_cdc",
)

_SERNANP_BASE = (
    "https://geoservicios.sernanp.gob.pe/arcgis/rest/services/"
    "sernanp_visor/servicio_descarga/MapServer"
)

# Mapeo capa → URL /query (las capas van de 1 a 61)
SERNANP_LINKS: dict[str, str] = {
    name: f"{_SERNANP_BASE}/{i}/query"
    for i, name in enumerate(_SERNANP_LAYERS, start=1)
}


def get_sernanp_link(type_: str) -> str:
    if type_ not in SERNANP_LINKS:
        raise ValueError(
            f"Capa inválida '{type_}'. Use `list_sernanp_layers()` para ver opciones."
        )
    return SERNANP_LINKS[type_]


def list_sernanp_layers() -> list[str]:
    """Lista las capas disponibles en el servicio Sernanp."""
    return list(SERNANP_LINKS)


# ─────────────────────────────── Serfor ────────────────────────
SERFOR_LINKS: dict[str, str] = {
    "heat_spot":   "https://geo.serfor.gob.pe/geoservicios/rest/services/Servicios_OGC/Unidad_Monitoreo_Satelital/MapServer/0/query",
    "forest_fire": "https://geo.serfor.gob.pe/geoservicios/rest/services/Servicios_OGC/Unidad_Monitoreo_Satelital/MapServer/1/query",
}


def get_heat_spot_link() -> str:
    return SERFOR_LINKS["heat_spot"]


def get_forest_fire_link() -> str:
    return SERFOR_LINKS["forest_fire"]


# ─────────────────────────────── MTC ─────────────────────────
# Servicio WFS de GeoServer en swmapas.mtc.gob.pe:8443
MTC_WFS_BASE = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs"

MTC_LAYERS: dict[str, str] = {
    "aerodromos_2023":               "pe_mtc_018_aerodromos_dic23",
    "aerodromos_2022":               "pe_mtc_018_aerodromos_dic22",
    "campamentos_pvn":               "gpt_ogpp_campamento_emergencia",
    "centros_acopio":                "gpt_ogpp_centro_acopio",
    "concesiones_viales":            "geoportal:vw_gli_ogpp_concesion_vial",
    "emergencias_viales":            "gpt_ogpp_emergencia_vial",
    "estaciones_pesaje":             "pe_mtc_018_pesajes_dic22",
    "estaciones_ferroviarias":       "pe_mtc_018_estaciones_ferroviarias",
    "localidades_telecomunicaciones":"gpt_ogpp_poblado_cobertura_telecomunicacion",
    "puentes":                       "gpt_ogpp_puente",
    "puntos_serpost":                "gpt_ogpp_serpost",
    "red_ferroviaria":               "pe_mtc_018_red_ferroviaria_dic22",
    "red_vial_departamental_2022":   "pe_mtc_018_red_vial_departamental_dic22",
    "red_vial_departamental_2023":   "pe_mtc_018_red_vial_departamental_dic23",
    "red_vial_departamental_2024":   "pe_mtc_018_red_vial_departamental_dic24",
    "red_vial_nacional_2022":        "pe_mtc_018_red_vial_nacional_dic22",
    "red_vial_nacional_2023":        "pe_mtc_018_red_vial_nacional_dic23",
    "red_vial_nacional_2024":        "pe_mtc_018_red_vial_nacional_dic24",
    "red_vial_vecinal_2022":         "pe_mtc_018_red_vial_vecinal_dic23",
    "rios_selva":                    "gli_ogpp_hidrovia",
    "terminales_portuarios_2022":    "pe_mtc_018_terminales_portuarios_dic22",
    "terminales_portuarios_2023":    "pe_mtc_018_terminales_portuarios_dic23",
    "terminales_terrestres":         "gpt_ogpp_terminal_terrestre",
    "truck_centers":                 "gpt_ogpp_truck_center",
    "tuneles":                       "gpt_ogpp_tunel",
    "unidades_peaje_2022":           "pe_mtc_018_peajes_dic22",
    "unidades_peaje_2023":           "pe_mtc_018_peajes_dic23",
}


def get_mtc_link(type_: str, output_format: str = "json") -> str:
    """Construye la URL WFS del MTC para una capa."""
    if type_ not in MTC_LAYERS:
        raise ValueError(
            f"Capa inválida '{type_}' para MTC. "
            f"Usa `get_data_sources(provider='MTC')` para ver opciones."
        )
    type_name = MTC_LAYERS[type_]
    fmt_param = {
        "json": "application/json",
        "gpkg": "application/x-gpkg",
        "gml": "text/xml; subtype=gml/3.1.1",
    }.get(output_format, "application/json")

    type_part = f"typeName={type_name}"
    max_part = "&maxFeatures=500" if not type_name.startswith("pe_mtc") else ""
    return (
        f"{MTC_WFS_BASE}?service=WFS&version=1.0.0"
        f"&request=GetFeature&{type_part}"
        f"{max_part}&outputFormat={fmt_param}"
    )


def list_mtc_layers() -> list[str]:
    return list(MTC_LAYERS)


# ─────────────────────────── INAIGEM ─────────────────────────
# ArcGIS FeatureServer en services6.arcgis.com
INAIGEM_LINKS: dict[str, str] = {
    "glaciares_1989":              "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Glaciares_1989/FeatureServer/22/query",
    "glaciares_2018":              "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Glaciares_2018/FeatureServer/20/query",
    "glaciares_2020":              "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Glaciares_2020/FeatureServer/0/query",
    "glaciares_2023":              "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Inventario_Nacional_de_Glaciares_y_Lagunas_de_Origen_Glaciar_Actualizado_al_a%C3%B1o_2020/FeatureServer/1/query",
    "lagunas_con_riesgo_desborde": "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/LGRD2024_/FeatureServer/0/query",
}


def get_inaigem_link(type_: str) -> str:
    if type_ not in INAIGEM_LINKS:
        raise ValueError(
            f"Capa inválida '{type_}' para INAIGEM. "
            f"Usa `get_data_sources(provider='INAIGEM')` para ver opciones."
        )
    return INAIGEM_LINKS[type_]


def list_inaigem_layers() -> list[str]:
    return list(INAIGEM_LINKS)


# ─────────────────────────── SIGRID ──────────────────────────
# ArcGIS REST MapServer en sigrid.cenepred.gob.pe
SIGRID_LINKS: dict[str, str] = {
    "inundacion_inventario":     "https://sigrid.cenepred.gob.pe/arcgis/rest/services/Cartografia_Peligros/MapServer/5010100/query",
    "inundacion_tramos_criticos":"https://sigrid.cenepred.gob.pe/arcgis/rest/services/Cartografia_Peligros/MapServer/5010600/query",
    "inundacion_puntos_criticos":"https://sigrid.cenepred.gob.pe/arcgis/rest/services/Cartografia_Peligros/MapServer/5010200/query",
    "movimiento_masa_inventario":"https://sigrid.cenepred.gob.pe/arcgis/rest/services/Cartografia_Peligros/MapServer/5020100/query",
}


def get_sigrid_link(type_: str) -> str:
    if type_ not in SIGRID_LINKS:
        raise ValueError(
            f"Capa inválida '{type_}' para SIGRID. "
            f"Usa `get_data_sources(provider='SIGRID')` para ver opciones."
        )
    return SIGRID_LINKS[type_]


def list_sigrid_layers() -> list[str]:
    return list(SIGRID_LINKS)


# ─────────────────────────── MIDAGRI ─────────────────────────
MIDAGRI_LINKS: dict[str, str] = {
    "agriculture_sector": "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/sectores/2024/SectoresEstadisticos_2024_04.zip",
    "oil_palm_areas":     "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/temas/PALMA_ACEITERA_2016_2020.zip",
}


def get_midagri_link(type_: str) -> str:
    if type_ not in MIDAGRI_LINKS:
        raise ValueError(
            f"Capa inválida '{type_}' para MIDAGRI. "
            f"Usa `get_data_sources(provider='Midagri')` para ver opciones."
        )
    return MIDAGRI_LINKS[type_]


def list_midagri_layers() -> list[str]:
    return list(MIDAGRI_LINKS)


# ─────────────────────────── SENAMHI ─────────────────────────
SENAMHI_URLS: dict[str, str] = {
    "aviso_meteorologico":  "https://www.senamhi.gob.pe/?&p=aviso-meteorologico",
    "aviso_meterologico_geom": "https://idesep.senamhi.gob.pe/geoserver/g_aviso/ows",
}


# ─────────────────────── MapBiomas Alerta ────────────────────
MAPBIOMAS_ALERTA_WFS = "https://maps.alerta.mapbiomas.org/geoserver/ows"
MAPBIOMAS_ALERTA_TYPE_NAME = "mapbiomas-alerta-peru:dashboard-alerts-staging"


# ─────────────────────── MapBiomas Fire ──────────────────────
# COGs de MapBiomas Fuego Peru en Google Cloud Storage
MAPBIOMAS_FIRE_BASE = (
    "https://storage.googleapis.com/shared-development-storage/"
    "COLLECTIONS/PERU/FIRE/COLLECTION{collection}/{folder}/{folder}-{suffix}"
)


# ─────────────────── MapBiomas Perú LULC ────────────────────
# Patrón de URL para los COGs de MapBiomas Perú alojados en GCS.
MAPBIOMAS_PERU_LULC_TPL = (
    "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/"
    "collection_{collection}/LULC/"
    "peru_collection{collection}_integration_v1-classification_{year}.tif"
)


def get_mapbiomas_peru_lulc_url(year: int, collection: int = 3) -> str:
    """Construye la URL del COG de MapBiomas Perú para un año y colección."""
    if collection not in (1, 2, 3):
        raise ValueError("Colección inválida: use 1, 2 o 3 (3 es la más reciente).")
    if not (1985 <= year <= 2024):
        raise ValueError("Año fuera del rango disponible (1985–2024).")
    return MAPBIOMAS_PERU_LULC_TPL.format(collection=collection, year=year)
