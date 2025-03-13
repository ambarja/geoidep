#' Retrieve links to SERNANP for information on natural protected areas.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "sernanp")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_sernanp_link <- \(type = NULL){
  sernanp_layer <-  c(
    "anp_nacional",
    "zona_reservada",
    "acr",
    "acp",
    "zona_amortiguamiento",
    "zonificacion_anp",
    "zonificacion_acr",
    "zonificacion_acp",
    "contratos_aprovechamiento",
    "acuerdos_actividad_menor",
    "contrato_servicio_turistico",
    "autorizacion_predio_privado",
    "reserva_biosfera_nacional",
    "reserva_biosfera_transfronterizo",
    "diagnostico_recursos",
    "planes_manejo_recursos",
    "reservas_indigenas",
    "cc_pueblos_indigenas",
    "cn_pueblos_indigenas",
    "reservas_piaci",
    "clasificacion_climatica",
    "red_estaciones",
    "ecosistemas_fragiles",
    "bosque_produccion_permanente",
    "bosques_protectores",
    "mapa_ecosistemas_2018",
    "ecorregiones_cdc")
  sernanp_service <- "https://geoservicios.sernanp.gob.pe/arcgis/rest/services/sernanp_visor/servicio_descarga/MapServer"
  sernanp_link <- sprintf("%s/%s/%s",sernanp_service,1:length(sernanp_layer),"query")
  names(sernanp_link) <- sernanp_layer

  if (!type %in% names(sernanp_link) || is.null(type)) {
    stop("Invalid type. Please choose one layer according sernanp layer. More information use `get_data_sources(providers = 'Sernanp')`")
  }

  return(sernanp_link[[type]])
}

#' Gets the links to the INEI's basic cartographic information.
#' @param type A string. Select only one of the following layers; ‘distrito’, ‘provincia’, or ‘departamento’. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_inei_link <- \(type = NULL) {
  inei_links <- c(
      distrito = "https://ide.inei.gob.pe/files/Distrito.rar",
      provincia = "https://ide.inei.gob.pe/files/Provincia.rar",
    departamento = "https://ide.inei.gob.pe/files/Departamento.rar"
  )

  if (!type %in% names(inei_links) || is.null(type)) {
    stop("Invalid type. Please choose from 'districto', 'provincia', or 'departmento'.")
  }

  return(inei_links[[type]])
}

#' Reading a csv containing geoidep resources
#' @importFrom utils read.csv
#' @keywords internal
get_data <- \(){
  read.csv("https://raw.githubusercontent.com/ambarja/geoidep/main/inst/sources-idep/sources_geoidep.csv")
}

#' MIDAGRI links for obtaining cartographic information
#' @param type A string. Select only one of the following layers; 'vegetation cover', 'agriculture sector', 'oil palm'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_midagri_link <- \(type = NULL){
  midagri_link <- c(
    "agriculture_sector" = "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/sectores/2024/SectoresEstadisticos_2024_04.zip",
    "oil_palm_areas" = "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/temas/PALMA_ACEITERA_2016_2020.zip"
    )
  if (!type %in% names(midagri_link) || is.null(type)) {
    stop("Invalid type. Please choose from 'agriculture_sector' or 'oil_palm'")
  }
  return(midagri_link[[type]])
}


#' Geobosque API that returns data on forest stock, forest loss, forest loss by ranges for a given department, province and district.
#' @param type A string. Select only one of the following layers; 'dist', 'pro', 'dep'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_geobosque_link <- \(type = NULL){
  geobosque_link <- c(
    "stock_bosque_perdida_distrito" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaDistrito",
    "stock_bosque_perdida_provincia" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaProvincia",
    "stock_bosque_perdida_departamento" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaRegion"
  )
  if (!type %in% names(geobosque_link) || is.null(type)) {
    stop("Invalid type. Please choose from 'dist', 'prov' or 'dep'")
  }
  return(geobosque_link[[type]])
}

#' Geobosque API to get deforestation hot-spots for the last week
#' @param type A string. Only one layer; `warning_last_week`
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_early_warning_link <- \(type = NULL){
  geobosque_early_warning_link <- c("warning_last_week" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/ALERTAS/ultimasByCobertura")
  if (!type %in% names(geobosque_early_warning_link) || is.null(type)) {
    stop("Invalid type. Please choose 'warning_last_week'")
  }
  return(geobosque_early_warning_link[[type]])
}

#' Serfor API to get heat spot
#' @param type A string. Only one layer; `heat_spot`
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_heat_spot_link <- \(type = NULL){
  serfor_heat_spot_link <- c("heat_spot" = "https://geo.serfor.gob.pe/geoservicios/rest/services/Servicios_OGC/Unidad_Monitoreo_Satelital/MapServer/0/query")
  if (!type %in% names(serfor_heat_spot_link) || is.null(type)) {
    stop("Invalid type. Please choose 'heat_spot'")
  }
  return(serfor_heat_spot_link[[type]])
}

#' Global variables for get_early_warning
#' This code declares global variables used in the `get_early_warning` function to avoid R CMD check warnings.
#' @name global-variables
#' @keywords internal
utils::globalVariables(c("X", "Y", "coords", "all_coords", "everything", "lng", "lat","provider","available_providers","loreto_prov",".","FECREG","FECHA","created_date","last_edited_date","emision","extract_meteorological_table","data"))

#' Time format units
#' This code transforms the time from milliseconds to a calendar date format.
#' @keywords internal
as_data_time <- \(x){
  timestamp_ms <- x
  timestamp_s <- timestamp_ms / 1000
  fecha <- as.POSIXct(timestamp_s, origin = "1970-01-01", tz = "UTC")
  return(fecha)
}

#' Retrieve the links to MTC for information on transport and telecomunication.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "MTC")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_mtc_link <- \(type = NULL){
  mtc_layer <- c(
    "aerodromos_2023" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_aerodromos_dic23&%20target=",
    "aerodromos_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_aerodromos_dic22&%20target=",
    "campamentos_pvn" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_campamento_emergencia&maxFeatures=500&%20target=",
    "centros_acopio" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_centro_acopio&maxFeatures=500&%20target=",
    "concesiones_viales" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=geoportal:vw_gli_ogpp_concesion_vial&maxFeatures=500&%20target=",
    "emergencias_viales" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_emergencia_vial&maxFeatures=500&%20target=",
    "estaciones_pesaje" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_pesajes_dic22&%20target=",
    "estaciones_ferroviarias" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_estaciones_ferroviarias&%20target=",
    "localidades_telecomunicaciones" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_poblado_cobertura_telecomunicacion&maxFeatures=500&%20target=",
    "puentes" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_puente&maxFeatures=500&%20target=",
    "puntos_serpost" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_serpost&maxFeatures=500&%20target=",
    "red_ferroviaria" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_ferroviaria_dic22&%20target=",
    "red_vial_departamental_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_departamental_dic22&maxFeatures=1000&%20target=",
    "red_vial_departamental_2023" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_departamental_dic23&maxFeatures=1000&%20target=",
    "red_vial_departamental_2024" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_departamental_dic24&maxFeatures=1000&%20target=",
    "red_vial_nacional_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_nacional_dic22&maxFeatures=1000&%20target=",
    "red_vial_nacional_2023" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_nacional_dic23&maxFeatures=1000&%20target=",
    "red_vial_vecinal_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_vecinal_dic22&maxFeatures=1000&%20target=",
    "red_vial_vecinal_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_red_vial_vecinal_dic23&maxFeatures=1000&%20target=",
    "rios_selva" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gli_ogpp_hidrovia&maxFeatures=500&%20target=",
    "terminales_portuarios_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_terminales_portuarios_dic22&%20target=",
    "terminales_portuarios_2023" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_terminales_portuarios_dic23&%20target=",
    "terminales_terrestres" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_terminal_terrestre&maxFeatures=500&%20target=",
    "truck_centers" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_truck_center&maxFeatures=500&%20target=",
    "tuneles" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=gpt_ogpp_tunel&maxFeatures=500&%20target=",
    "unidades_peaje_2022" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_peajes_dic22&%20target=",
    "unidades_peaje_2023" = "https://swmapas.mtc.gob.pe:8443/geoserver/geoportal/wfs?service=WFS&version=1.0.0&request=GetFeature&typeName=pe_mtc_018_peajes_dic23&%20target="
    )
  if (!type %in% names(mtc_layer) || is.null(type)) {
    stop("Invalid type. Please choose one layer according sernanp layer. More information use `get_data_sources(providers = 'MTC')`")
  }

  return(mtc_layer[[type]])

}

#' Retrieve the links to INAIGEM for information on Mountain High Ecosystems.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_inaigem_link <-  \(type = NULL){
  inaigem_layer <- c(
    "glaciares_1989" = "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Glaciares_1989/FeatureServer/22/query",
    "glaciares_2018" = "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Glaciares_2018/FeatureServer/20/query",
    "glaciares_2020" = "https://services6.arcgis.com/c9GFTG11debu0wsH/ArcGIS/rest/services/Glaciares_2020/FeatureServer/0/query")
  if (!type %in% names(inaigem_layer) || is.null(type)) {
    stop("Invalid type. Please choose one layer according INAIGEM layer. More information use `get_data_sources(providers = 'INAIGEM')`")
  }

  return(inaigem_layer[[type]])
}

#' Retrieve the links of the SIGRID for information on Disaster Risk Management.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_sigrid_link <-  \(type = NULL){
  peligros_layer <- c(
    "inundacion_inventario" = "https://sigrid.cenepred.gob.pe/arcgis/rest/services/Cartografia_Peligros/MapServer/5010100/query"
    )
  if (!type %in% names(peligros_layer) || is.null(type)) {
    stop("Invalid type. Please choose one layer according INAIGEM layer. More information use `get_data_sources(providers = 'SIGRID')`")
  }

  return(peligros_layer[[type]])
}
