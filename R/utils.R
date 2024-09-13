#' Retrieve links to SERNANP for information on natural protected areas.
#' @param type A string. Select only one of the following layers; ‘anp_def’, ‘zr’,‘cp’,'zoam','zoanp','zoacp','zoacr'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_sernanp_link <- \(type = NULL){
  sernanp_link <- c(
     "anp_def" = "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/1/query",
     "zr" = "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/2/query" ,
     "cr"= "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/3/query",
     "cp"= "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/4/query",
     "zoam"= "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/6/query",
     "zoanp"= "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/8/query",
     "zoacp"= "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/9/query",
     "zoacr"= "https://www.idep.gob.pe/geoportal/rest/services/INSTITUCIONALES/SERNANP/FeatureServer/10/query",
  )
  if (!type %in% names(sernanp_link) || is.null(type)) {
    stop("Invalid type. Please choose one layer")
  }

  return(sernanp_link[[type]])
}

#' Retrieve INEI Links of the Basic Cartographic Information
#' @param type A string. Select only one of the following layers; ‘districts’, ‘provinces’, or ‘departments’. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_inei_link <- \(type = NULL) {
  inei_links <- c(
    districts = "https://ide.inei.gob.pe/files/Distrito.rar",
    provinces = "https://ide.inei.gob.pe/files/Provincia.rar",
    departments = "https://ide.inei.gob.pe/files/Departamento.rar"
  )

  if (!type %in% names(inei_links) || is.null(type)) {
    stop("Invalid type. Please choose from 'districts', 'provinces', or 'departments'.")
  }

  return(inei_links[[type]])
}

#' Reading a csv containing IDEP resources
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
    "vegetation cover" = "https://archivos.midagri.gob.pe/index.php/s/deZQjkzmbodFyG6/download",
    "agriculture sector" = "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/sectores/2024/SectoresEstadisticos_2024_04.zip",
    "oil palm" = "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/temas/PALMA_ACEITERA_2016_2020.zip",
    "experimental stations" = "https://pgc-snia.inia.gob.pe:8443/jspui/mapa/data/estaciones_experimentales.js"
  )
  if (!type %in% names(midagri_link) || is.null(type)) {
    stop("Invalid type. Please choose from 'vegetation cover', 'agriculture sector', 'oil palm' or 'experimental stations'")
  }
  return(midagri_link[[type]])
}


#' Geobosque API that returns data on forest stock, forest loss, forest loss by ranges for a given department, province and district.
#' @param type A string. Select only one of the following layers; 'bpdist', 'bppro', 'bpdep'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_geobosque_link <- \(type = NULL){
  geobosque_link <- c(
    "dist" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaDistrito",
    "pro" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaProvincia",
    "dep" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaRegion"
  )
  if (!type %in% names(geobosque_link) || is.null(type)) {
    stop("Invalid type. Please choose from 'dist', 'prov' or 'dep'")
  }
  return(geobosque_link[[type]])
}

#' Geobosque API to get deforestation hot-spots for the last week
#' @param type A string. Select only one of the following layer; warning_last_week
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_early_warning_link <- \(type = NULL){
  geobosque_early_warning_link <- c(
    "warning_last_week" = "http://geobosques.minam.gob.pe/geobosque/ws/rest/ALERTAS/ultimasByCobertura"
  )
  if (!type %in% names(geobosque_early_warning_link) || is.null(type)) {
    stop("Invalid type. Please choose 'warning_last_week'")
  }
  return(geobosque_early_warning_link[[type]])
}


#' Global variables for get_early_warning
#' This block declares global variables used in the `get_early_warning` function to avoid R CMD check warnings.
#' @name global-variables
#' @keywords internal
utils::globalVariables(c("X", "Y", "coords", "all_coords", "everything", "lng", "lat"))
