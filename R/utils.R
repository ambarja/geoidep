#' Reading a csv containing geoidep resources
#' @importFrom utils read.csv
#' @keywords internal
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
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
#' @noRd
get_hazard_link <-  \(type = NULL){
  peligros_layer <- getOption("sigrid", default = .internal_urls$sigrid)
  if (!type %in% names(peligros_layer) || is.null(type)) {
    stop("Invalid type. Please choose one layer according SIGRID layer. More information use `get_data_sources(providers = 'SIGRID')`")
  }
  return(peligros_layer[[type]])
}

#' Retrieve the links to MapBiomas Alerta Peru for deforestation alerts
#' @param type A string. Select the layer type (e.g., 'dashboard_alerts', 'dashboard_alerts_wms'). Defaults to NULL.
#' @return A string containing the URL of the WFS or WMS endpoint.
#' @keywords internal
#' @noRd
get_mapbiomas_link <- \(type = NULL){
  mapbiomas_link <- getOption("mapbiomas", default = .internal_urls$mapbiomas)
  if (!type %in% names(mapbiomas_link) || is.null(type)) {
    stop("Invalid type. Please choose from available MapBiomas layers: ", paste(names(mapbiomas_link), collapse = ", "))
  }
  return(mapbiomas_link[[type]])
}

#' @keywords internal
#' @noRd
validate_date <- function(x, arg_name) {
  if (is.null(x)) return(NULL)

  if (!is.character(x) || !grepl("^\\d{4}-\\d{2}-\\d{2}$", x)) {
    cli::cli_abort(c(
      "Invalid {.arg {arg_name}} value.",
      "x" = "You supplied: {.val {x}}",
      "i" = "Expected format: {.code YYYY-MM-DD} (e.g. {.val 2024-01-31})"
    ))
  }

  parsed <- suppressWarnings(as.Date(x, format = "%Y-%m-%d"))
  if (is.na(parsed)) {
    cli::cli_abort(c(
      "Invalid {.arg {arg_name}} date.",
      "x" = "{.val {x}} is not a real calendar date."
    ))
  }
  parsed
}

#' Mapbiomas Peru legend
#' @keywords internal
#' @noRd
get_mapbiomas_peru_legend <- function() {
  tibble::tribble(
    ~id, ~class_en,                            ~class_es,                                   ~hex,
    1,  "Forest formation",                    "Formaci\u00f3n boscosa",                    "#1f8d49",
    3,  "Forest",                              "Bosque",                                    "#1f8d49",
    4,  "Dry forest",                          "Bosque seco",                               "#7dc975",
    5,  "Mangrove",                            "Manglar",                                   "#04381d",
    6,  "Flooded forest",                      "Bosque inundable",                          "#026975",
    10, "Non-forest formation",                "Formaci\u00f3n natural no boscosa",         "#d6bc74",
    11, "Swamp or Flooded Grassland",          "Zona pantanosa o pastizal inundable",       "#519799",
    12, "Grasslands / herbaceous",             "Pastizal / herbazal",                       "#d6bc74",
    29, "Rocky Outcrop",                       "Afloramiento rocoso",                       "#ffaa5f",
    66, "Scrubland",                           "Matorral",                                  "#a89358",
    70, "Fog oasis",                           "Loma costera",                              "#be9e00",
    13, "Other non-forest formations",         "Otra formaci\u00f3n no boscosa",            "#d89f5c",
    14, "Agricultural area",                   "\u00c1rea agropecuaria",                    "#ffefc3",
    15, "Pasture",                             "Pasto",                                     "#edde8e",
    18, "Agriculture",                         "Agricultura",                               "#e974ed",
    35, "Oil palm",                            "Palma aceitera",                            "#9065d0",
    40, "Rice",                                "Arroz",                                     "#c71585",
    72, "Other crops",                         "Otros cultivos",                            "#910046",
    9,  "Planted forest",                      "Plantaci\u00f3n forestal",                  "#7a5900",
    21, "Mosaic of agriculture and pasture",   "Mosaico agropecuario",                      "#ffefc3",
    22, "Non-vegetated area",                  "\u00c1rea sin vegetaci\u00f3n",             "#d4271e",
    23, "Beach",                               "Playa",                                     "#ffa07a",
    24, "Infrastructure",                      "Infraestructura urbana",                    "#d4271e",
    30, "Mining",                              "Miner\u00eda",                              "#9c0027",
    32, "Coastal Salt flat",                   "Salina costera",                            "#fc8114",
    61, "Salt flat",                           "Salar",                                     "#f5d5d5",
    68, "Other natural non vegetated area",    "Otra \u00e1rea natural sin vegetaci\u00f3n","#E97A7A",
    25, "Other non vegetated area",            "Otra \u00e1rea sin vegetaci\u00f3n",        "#db4d4f",
    26, "Water body",                          "Cuerpo de agua",                            "#2532e4",
    33, "River, lake or ocean",                "R\u00edo, lago u oc\u00e9ano",              "#2532e4",
    31, "Aquaculture",                         "Acuicultura",                               "#091077",
    34, "Glacier",                             "Glaciar",                                   "#93dfe6",
    27, "Not observed",                        "No observado",                              "#ffffff"
  )
}

#' Global variables for get_early_warning
#' This code declares global variables used in the `get_early_warning` function to avoid R CMD check warnings.
#' @name global-variables
#' @keywords internal
#' @noRd
utils::globalVariables(c("nro_clean","nivel", ".internal_urls", "X", "Y", "coords", "all_coords", "everything", "lng", "lat","provider","available_providers","loreto_prov",".","FECREG","FECHA","created_date","last_edited_date","emision","extract_meteorological_table","data","nombdep","setNames","detected_at"))
