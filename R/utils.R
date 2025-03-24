#' Reading a csv containing geoidep resources
#' @importFrom utils read.csv
#' @keywords internal
get_data <- \(url = NULL){
  if(is.null(url)){
    url <- getOption(x = "geoidep", default = .internal_urls$geoidep)
  }
  tryCatch({
    data <- read.csv(url) |> tidyr::as_tibble()
    return(data)
  }, error = function(e) {
    stop("The file could not be read. Check that the link is valid and your Internet connection.")
  })
}

#' Retrieve links to SERNANP for information on natural protected areas.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "sernanp")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_sernanp_link <- \(type = NULL){
  sernanp_link <- getOption("sernanp", default = .internal_urls$sernanp)
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
  inei_links <- getOption("inei", default = .internal_urls$inei)
  if (!type %in% names(inei_links) || is.null(type)) {
    stop("Invalid type. Please choose from 'districto', 'provincia', or 'departmento'.")
  }
  return(inei_links[[type]])
}

#' MIDAGRI links for obtaining cartographic information
#' @param type A string. Select only one of the following layers; 'vegetation cover', 'agriculture sector', 'oil palm'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_midagri_link <- \(type = NULL){
  midagri_link <- getOption("midagri", default = .internal_urls$midagri)
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
  geobosque_link <- getOption("geobosque", default = .internal_urls$geobosque)
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
  geobosque_early_warning_link <- getOption("geobosque", default = .internal_urls$geobosque)
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
  serfor_heat_spot_link <- getOption("geobosque", default = .internal_urls$geobosque)
  if (!type %in% names(serfor_heat_spot_link) || is.null(type)) {
    stop("Invalid type. Please choose 'heat_spot'")
  }
  return(serfor_heat_spot_link[[type]])
}

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
  mtc_layer <- getOption("mtc", default = .internal_urls$mtc)
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
  inaigem_layer <- getOption("inaigem", default = .internal_urls$inaigem)
  if (!type %in% names(inaigem_layer) || is.null(type)) {
    stop("Invalid type. Please choose one layer according INAIGEM layer. More information use `get_data_sources(providers = 'INAIGEM')`")
  }
  return(inaigem_layer[[type]])
}

#' Retrieve the links of the SIGRID for information on Disaster Risk Management.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
get_hazard_link <-  \(type = NULL){
  peligros_layer <- getOption("sigrid", default = .internal_urls$sigrid)
  if (!type %in% names(peligros_layer) || is.null(type)) {
    stop("Invalid type. Please choose one layer according SIGRID layer. More information use `get_data_sources(providers = 'SIGRID')`")
  }
  return(peligros_layer[[type]])
}

#' Global variables for get_early_warning
#' This code declares global variables used in the `get_early_warning` function to avoid R CMD check warnings.
#' @name global-variables
#' @keywords internal
utils::globalVariables(c("nro_clean","nivel", ".internal_urls", "X", "Y", "coords", "all_coords", "everything", "lng", "lat","provider","available_providers","loreto_prov",".","FECREG","FECHA","created_date","last_edited_date","emision","extract_meteorological_table","data"))
