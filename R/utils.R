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
    "concesion",
    "contrato_servicio_turistico",
    "autorizacion_predio_privado",
    "reserva_biosfera_nacional",
    "acuerdo",
    "reserva_biosfera_transfronterizo",
    "diagnostico_recursos",
    "planes_manejo_recursos",
    "pozos_exploratorios",
    "lotes_contrato",
    "autoridad_adm_agua",
    "acuiferos",
    "unidades_hidrograficas",
    "autoridad_local_agua",
    "reservas_indigenas",
    "cc_pueblos_indigenas",
    "cn_pueblos_indigenas",
    "reservas_piaci",
    "qhapaqnan",
    "mapa_pobreza_2013",
    "catastro_minero_17_sur",
    "catastro_minero_18_sur",
    "catastro_minero_19_sur",
    "predio_rural",
    "comunidades_nativas",
    "comunidades_campesinas",
    "concesiones_mineras",
    "concesiones_geotermica",
    "lineas_transmision",
    "concesiones_hidroelectricas",
    "concesiones_generacion",
    "concesiones_geotermica_autorizada",
    "concesiones_distribucion",
    "red_vial_nacional",
    "aerodromos",
    "red_vial_departamental",
    "red_vial_vecinal",
    "linea_ferrea",
    "areas_habilitadas",
    "areas_derecho_acuicolas",
    "zonas_pesca",
    "derechos_acuicolas",
    "clasificacion_climatica",
    "red_estaciones",
    "bosques_locales",
    "concesiones",
    "ecosistemas_fragiles",
    "bosque_produccion_permanente",
    "bosques_protectores",
    "mapa_ecosistemas_2018",
    "ecorregiones_cdc")
  sernanp_service <- "https://geoservicios.sernanp.gob.pe/arcgis/rest/services/sernanp_visor/servicio_descarga/MapServer"
  sernanp_link <- sprintf("%s/%s/%s",sernanp_service,1:61,"query")
  names(sernanp_link) <- sernanp_layer

  if (!type %in% names(sernanp_link) || is.null(type)) {
    stop("Invalid type. Please choose one layer according sernanp layer. More information use `get_data_sources(providers = 'Sernanp')`")
  }

  return(sernanp_link[[type]])
}

#' Gets the links to the INEI's basic cartographic information.
#' @param type A string. Select only one of the following layers; ‘districts’, ‘provinces’, or ‘departments’. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_inei_link <- \(type = NULL) {
  inei_links <- c(
      distrito = "https://ide.inei.gob.pe/files/Distrito.rar",
      provincia = "https://ide.inei.gob.pe/files/Provincia.rar",
    departamento = "https://ide.inei.gob.pe/files/Departamento.rar"
  )

  if (!type %in% names(inei_links) || is.null(type)) {
    stop("Invalid type. Please choose from 'districts', 'provinces', or 'departments'.")
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
    "vegetation_cover" = "https://archivos.midagri.gob.pe/index.php/s/deZQjkzmbodFyG6/download",
    "agriculture_sector" = "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/sectores/2024/SectoresEstadisticos_2024_04.zip",
    "oil_palm_areas" = "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/temas/PALMA_ACEITERA_2016_2020.zip",
    "experimental_stations" = "https://pgc-snia.inia.gob.pe:8443/jspui/mapa/data/estaciones_experimentales.js"
  )
  if (!type %in% names(midagri_link) || is.null(type)) {
    stop("Invalid type. Please choose from 'vegetation cover', 'agriculture sector', 'oil palm' or 'experimental stations'")
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


#' Global variables for get_early_warning
#' This code declares global variables used in the `get_early_warning` function to avoid R CMD check warnings.
#' @name global-variables
#' @keywords internal
utils::globalVariables(c("X", "Y", "coords", "all_coords", "everything", "lng", "lat","provider","available_providers","loreto_prov"))
