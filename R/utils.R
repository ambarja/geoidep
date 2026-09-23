#' Reading a csv containing geoidep resources
#' @importFrom utils read.csv
#' @keywords internal
#' @noRd
get_data <- \(url = NULL, timeout = 60){
  if(is.null(url)){
    url <- getOption(x = "geoidep", default = .internal_urls$geoidep)
  }
  # Bound the connection wait explicitly (CRAN: never hang on downloads).
  # Restored on exit so no global state leaks.
  old_timeout <- getOption("timeout")
  options(timeout = timeout)
  on.exit(options(timeout = old_timeout), add = TRUE)
  tryCatch({
    data <- read.csv(url) |> tidyr::as_tibble()
    return(data)
  }, error = function(e) {
    cli::cli_abort(c(
      "The catalogue could not be read.",
      "x" = "Check the URL and your internet connection.",
      "i" = "Details: {conditionMessage(e)}"
    ))
  })
}

#' Resolve a download URL for a provider/layer pair
#'
#' Single source of truth that replaces the historical `get_*_link()` family.
#' The historical wrappers are kept below for backward compatibility and are
#' tested in `tests/testthat/test-utils.R`.
#'
#' @param provider One of "inei", "sernanp", "midagri", "geobosque", "mtc",
#'   "inaigem", "sigrid", "mapbiomas".
#' @param layer Layer key inside `.internal_urls[[provider]]`.
#' @keywords internal
#' @noRd
.get_layer_url <- \(provider, layer = NULL) {
  valid_providers <- c("inei", "sernanp", "midagri", "geobosque", "mtc",
                       "inaigem", "sigrid", "mapbiomas", "senamhi")

  provider <- match.arg(provider, valid_providers)

  urls <- getOption(provider, default = .internal_urls[[provider]])

  if (is.null(layer) || !layer %in% names(urls)) {
    cli::cli_abort(c(
      "Invalid {.arg layer} for provider {.val {provider}}.",
      "i" = "Available layers: {.val {names(urls)}}",
      "i" = "Tip: run {.code get_data_sources(query = \"{provider}\")} to inspect them."
    ))
  }

  urls[[layer]]
}

#' Retrieve links to SERNANP for information on natural protected areas.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "sernanp")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_sernanp_link <- \(type = NULL){
  tryCatch(
    .get_layer_url("sernanp", type),
    error = function(e) {
      stop("Invalid type. Please choose one layer")
    }
  )
}

#' Gets the links to the INEI's basic cartographic information.
#' @param type A string. Select only one of the following layers; 'distrito', 'provincia', or 'departamento'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_inei_link <- \(type = NULL) {
  tryCatch(
    .get_layer_url("inei", type),
    error = function(e) {
      stop("Invalid type. Please choose from 'districto', 'provincia', or 'departmento'.")
    }
  )
}

#' MIDAGRI links for obtaining cartographic information
#' @param type A string. Select only one of the following layers; 'vegetation cover', 'agriculture sector', 'oil palm'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_midagri_link <- \(type = NULL){
  tryCatch(
    .get_layer_url("midagri", type),
    error = function(e) {
      stop("Invalid type. Please choose from 'agriculture_sector' or 'oil_palm'")
    }
  )
}

#' Geobosque API that returns data on forest stock, forest loss, forest loss by ranges for a given department, province and district.
#' @param type A string. Select only one of the following layers; 'dist', 'pro', 'dep'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_geobosque_link <- \(type = NULL){
  tryCatch(
    .get_layer_url("geobosque", type),
    error = function(e) {
      stop("Invalid type. Please choose from 'dist', 'prov' or 'dep'")
    }
  )
}

#' Geobosque API to get deforestation hot-spots for the last week
#' @param type A string. Only one layer; `warning_last_week`
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_early_warning_link <- \(type = NULL){
  tryCatch(
    .get_layer_url("geobosque", type),
    error = function(e) {
      stop("Invalid type. Please choose 'warning_last_week'")
    }
  )
}

#' Serfor API to get heat spot
#' @param type A string. Only one layer; `heat_spot`
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_heat_spot_link <- \(type = NULL){
  tryCatch(
    .get_layer_url("geobosque", type),
    error = function(e) {
      stop("Invalid type. Please choose 'heat_spot'")
    }
  )
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
  .get_layer_url("mtc", type)
}

#' Retrieve the links to INAIGEM for information on Mountain High Ecosystems.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_inaigem_link <-  \(type = NULL){
  .get_layer_url("inaigem", type)
}

#' Retrieve the links of the SIGRID for information on Disaster Risk Management.
#' @param type A string. Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal
#' @noRd
get_hazard_link <-  \(type = NULL){
  .get_layer_url("sigrid", type)
}

#' Retrieve the links to MapBiomas Alerta Peru for deforestation alerts
#' @param type A string. Select the layer type (e.g., 'dashboard_alerts', 'dashboard_alerts_wms'). Defaults to NULL.
#' @return A string containing the URL of the WFS or WMS endpoint.
#' @keywords internal
#' @noRd
get_mapbiomas_link <- \(type = NULL){
  urls <- getOption("mapbiomas", default = .internal_urls$mapbiomas)
  if (is.null(type) || !type %in% names(urls)) {
    stop("Invalid type. Please choose from available MapBiomas layers: ", paste(names(urls), collapse = ", "))
  }
  urls[[type]]
}

#' Download a file with a cli progress bar
#'
#' Central helper for every provider. Uses `httr2::req_progress()` so the
#' progress bar is rendered with cli aesthetics. Falls back to a
#' `cli::cli_progress_step()` spinner when the server does not report a
#' content length.
#'
#' @param url URL to download.
#' @param dest Destination file path.
#' @param show_progress Logical. Show the cli progress bar.
#' @param timeout Numeric. Seconds to wait for the server response.
#' @keywords internal
#' @noRd
.download_with_cli <- \(url, dest, show_progress = TRUE, timeout = 60) {
  req <- httr2::request(url) |>
    httr2::req_timeout(timeout) |>
    httr2::req_options(ssl_verifypeer = FALSE) |>
    httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)

  if (isTRUE(show_progress)) {
    req <- req |> httr2::req_progress()
  }

  tryCatch(
    httr2::req_perform(req, path = dest),
    error = function(e) {
      cli::cli_abort(c(
        "Error during download.",
        "x" = "{conditionMessage(e)}",
        "i" = "URL: {.url {url}}"
      ))
    }
  )
}

#' Read a spatial file and normalise column names
#' @keywords internal
#' @noRd
.read_spatial_normalised <- \(path, quiet = TRUE) {
  sf_data <- sf::st_read(path, quiet = quiet)
  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  if (length(non_geom_idx) > 0) {
    names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])
  }
  sf_data
}

#' Download an ArcGIS REST `f = "geojson"` layer with cli progress
#'
#' Shared by SERNANP, INAIGEM, SERFOR and (when reactivated) SIGRID/MIDAGRI.
#'
#' @keywords internal
#' @noRd
.download_wfs_geojson <- \(url, dsn = NULL, fileext = ".geojson",
                           show_progress = TRUE, quiet = TRUE, timeout = 60) {
  if (is.null(dsn)) {
    dsn <- tempfile(fileext = fileext)
  }

  # Single real cli progress bar via httr2::req_progress()
  .download_with_cli(url, dest = dsn, show_progress = show_progress, timeout = timeout)

  # ArcGIS servers expect the query string; re-request with query if needed
  # (the direct URL already contains the layer endpoint)
  sf_data <- tryCatch(
    {
      req <- httr2::request(url) |>
        httr2::req_url_query(where = "1=1", outFields = "*", f = "geojson") |>
        httr2::req_timeout(timeout) |>
        httr2::req_options(ssl_verifypeer = FALSE)
      if (isTRUE(show_progress)) req <- req |> httr2::req_progress()
      httr2::req_perform(req, path = dsn)
      .read_spatial_normalised(dsn, quiet = quiet)
    },
    error = function(e) {
      cli::cli_abort(c(
        "Error downloading the layer.",
        "x" = "{conditionMessage(e)}"
      ))
    }
  )

  sf_data
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
utils::globalVariables(c("anio","range5","range4","range3","range2","range1","loss","year","id","nro_clean","nivel", ".internal_urls", "X", "Y", "coords", "all_coords", "everything", "lng", "lat","provider","available_providers","loreto_prov",".","FECREG","FECHA","created_date","last_edited_date","emision","extract_meteorological_table","data","nombdep","setNames","detected_at","nombprov","error_message"))
