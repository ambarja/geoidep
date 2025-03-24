#' Download Weather Alert Table from Senamhi
#'
#' This function downloads the table of weather warnings provided by Senamhi.
#' For more information, please visit the following link: \url{https://www.Senamhi.gob.pe/?&p=aviso-meteorologico}
#'
#' @return A tibble object containing the weather alert data.
#' @export
#'
#' @examples
#' \donttest{
#' data <- senamhi_get_meteorological_table()
#' head(data)
#' }
senamhi_get_meteorological_table <- function() {
  url <- getOption(x = "geoidep", default = .internal_urls$senamhi$aviso_meteorologico)

  pb <- progress::progress_bar$new(
    format = " Downloading website [:bar] :percent in :elapsed",
    total = 3, clear = FALSE, width = 60
  )

  pb$tick(); Sys.sleep(0.5)

  message("Reading data from the website...")
  pg <- rvest::read_html(url)
  pb$tick(); Sys.sleep(0.5)

  tablas_raw <- rvest::html_table(pg, fill = TRUE)
  if (length(tablas_raw) == 0) {
    message("No tables were found on the website.")
    return(NULL)
  }

  tabla <- tablas_raw[[1]][-1, ]
  names(tabla) <- c("aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel")

  pb$tick(); Sys.sleep(0.5)
  message("Data successfully uploaded.")

  return(tidyr::as_tibble(tabla))
}

#' Filter Senamhi alerts by number
#'
#' @param data A data frame of meteorological alerts.
#' @param nro A numeric vector indicating the alert number(s).
#'
#' @return A filtered tibble.
#' @export
senamhi_alert_by_number <- function(data, nro) {
  data_clean <- dplyr::mutate(data, nro_clean = as.numeric(gsub("[^0-9]", "", nro)))
  nro_input <- as.numeric(gsub("[^0-9]", "", nro))

  dplyr::filter(data_clean, nro_clean %in% nro_input) |>
    dplyr::select(-nro_clean)
}

#' Filter Senamhi alerts by year
#'
#' @param data A data frame of meteorological alerts.
#' @param year A numeric value indicating the year.
#'
#' @return A filtered tibble.
#' @export
senamhi_alerts_by_year <- function(data, year) {
  dplyr::filter(data, substr(emision, 1, 4) == as.character(year))
}

#' Download Meteorological Alert Geometry from Senamhi
#'
#' This function downloads the spatial alert geometry (shapefile) from Senamhi for a given alert.
#'
#' @param data A data frame with a single alert (with columns `nro` and `emision`), or NULL if you specify `nro` and `year`.
#' @param nro A numeric value (optional if `data` is provided).
#' @param year A numeric value (optional if `data` is provided).
#' @param dsn Path to save the downloaded .zip. If NULL, a temporary file is used.
#' @param show_progress Logical, show download progress.
#' @param quiet Logical, suppress messages from `sf::st_read()`.
#'
#' @return An sf object with the alert geometry.
#' @export
senamhi_get_spatial_alerts <- function(data = NULL, nro = NULL, year = NULL,
                                       dsn = NULL, show_progress = TRUE, quiet = TRUE) {
  if (!is.null(data)) {
    nro <- as.numeric(gsub("[^0-9]", "", data$nro[1]))
    year <- as.numeric(gsub("^(\\d{4})-.*$", "\\1", data$emision[1]))
  }

  link <- glue::glue(getOption(x = "geoidep", default = .internal_urls$senamhi$aviso_meterologico_geom))

  if (is.null(dsn)) dsn <- tempfile(fileext = ".zip")

  req <- httr::GET(
    link,
    config = httr::config(ssl_verifypeer = FALSE),
    httr::write_disk(dsn, overwrite = TRUE),
    if (isTRUE(show_progress)) httr::progress() else NULL
  )

  if (httr::http_error(req)) stop("Error downloading the file. Check the URL or connection.")

  extract_dir <- tempfile(); dir.create(extract_dir)
  archive::archive_extract(archive = dsn, dir = extract_dir)

  shp <- list.files(extract_dir, pattern = "\\.shp$", full.names = TRUE)
  if (length(shp) == 0) stop("No .shp file found in the archive.")

  sf::st_read(shp, quiet = quiet)
}

#' Filter alert geometry by danger level
#'
#' This function filters the `sf` object from Senamhi by alert level (e.g., 1 to 4).
#'
#' @param sf_data An sf object returned by `senamhi_get_spatial_alerts()`.
#' @param level Numeric or character vector: values like 1, 2, 3, 4 or "Nivel 1", etc.
#'
#' @return Filtered sf object.
#' @export
#'
#' @examples
#' \donttest{
#' senamhi_get_meteorological_table() |>
#'   senamhi_alert_by_number(295) |>
#'   senamhi_alerts_by_year(2024) |>
#'   senamhi_get_spatial_alerts(show_progress = FALSE) |>
#'   senamhi_geometry_by_level(3) |>
#'   plot()
#' }
senamhi_geometry_by_level <- function(sf_data, level) {
  if (!inherits(sf_data, "sf")) stop("Input must be an sf object.")

  levels_normalized <- if (is.numeric(level)) paste("Nivel", level) else level

  dplyr::filter(sf_data, nivel %in% levels_normalized)
}
