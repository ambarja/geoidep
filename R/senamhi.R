#' SENAMHI weather alerts
#'
#' @description
#' Meteorological warning tables and alert geometries from SENAMHI:
#' \url{https://www.senamhi.gob.pe/?&p=aviso-meteorologico}.
#' Progress is reported with [cli][cli::cli_progress_bar()]; the legacy
#' `progress::progress_bar` dependency was removed.
#'
#' Only two functions hit the network (`senamhi_get_meteorological_table()`
#' and `senamhi_get_spatial_alerts()`); the remaining three are pure
#' in-memory filters kept for convenience.
#'
#' @name senamhi
NULL

#' Download Weather Alert Table from Senamhi
#'
#' This function downloads the table of weather warnings provided by Senamhi.
#' For more information, please visit the following link: \url{https://www.senamhi.gob.pe/?&p=aviso-meteorologico}
#'
#' @param show_progress Logical. Show a cli progress bar. Default `TRUE`.
#' @param timeout Numeric. Seconds to wait for the server response. Default 60.
#' @return A tibble object containing the weather alert data.
#' @export
#' @examples
#' \dontrun{
#' data <- senamhi_get_meteorological_table(show_progress = FALSE)
#' head(data)
#' }
senamhi_get_meteorological_table <- function(show_progress = TRUE, timeout = 60) {
  url <- getOption(x = "geoidep", default = .internal_urls$senamhi$aviso_meteorologico)

  if (isTRUE(show_progress)) {
    cli::cli_progress_bar("Downloading SENAMHI warnings", total = 3)
  }

  if (isTRUE(show_progress)) cli::cli_progress_update()
  # Fetch via httr2 so the request honours `timeout` and fails gracefully
  # (rvest::read_html(url) has no timeout control).
  html_file <- tempfile(fileext = ".html")
  tryCatch(
    httr2::request(url) |>
      httr2::req_timeout(timeout) |>
      httr2::req_options(ssl_verifypeer = FALSE) |>
      httr2::req_retry(max_tries = 2, retry_on_failure = TRUE) |>
      httr2::req_perform(path = html_file),
    error = function(e) {
      if (isTRUE(show_progress)) cli::cli_progress_done()
      cli::cli_abort(c(
        "SENAMHI service request failed.",
        "x" = conditionMessage(e),
        "i" = "The SENAMHI website may be temporarily unavailable. Try again later."
      ))
    }
  )
  pg <- rvest::read_html(html_file)
  if (isTRUE(show_progress)) cli::cli_progress_update()

  tablas_raw <- rvest::html_table(pg, fill = TRUE)
  if (length(tablas_raw) == 0) {
    if (isTRUE(show_progress)) cli::cli_progress_done()
    cli::cli_warn("No tables were found on the website.")
    return(NULL)
  }

  tabla <- tablas_raw[[1]][-1, ]
  names(tabla) <- c("aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel")

  if (isTRUE(show_progress)) {
    cli::cli_progress_update()
    cli::cli_progress_done()
    cli::cli_alert_success("Data successfully downloaded.")
  }

  return(tidyr::as_tibble(tabla))
}

#' Filter Senamhi alerts by number
#'
#' @param data A data frame of meteorological alerts.
#' @param nro A numeric vector indicating the alert number(s).
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
#' @param show_progress Logical, show cli progress bar.
#' @param quiet Logical, suppress messages from `sf::st_read()`.
#' @param timeout Numeric. Seconds to wait for a response. Default 60.
#' @return An sf object with the alert geometry.
#' @export
senamhi_get_spatial_alerts <- function(data = NULL, nro = NULL, year = NULL,
                                       dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60) {
  if (!is.null(data)) {
    nro <- as.numeric(gsub("[^0-9]", "", data$nro[1]))
    year <- as.numeric(gsub("^(\\d{4})-.*$", "\\1", data$emision[1]))
  }

  if (is.null(nro) || is.null(year)) {
    cli::cli_abort(c(
      "Missing alert reference.",
      "x" = "Provide {.arg data} or both {.arg nro} and {.arg year}."
    ))
  }

  # Base-R interpolation of the {nro}/{year} template stored in sysdata
  # (replaces the former glue::glue() call, same result, no dependency).
  link <- getOption(x = "geoidep", default = .internal_urls$senamhi$aviso_meterologico_geom)
  link <- gsub("{nro}", nro, link, fixed = TRUE)
  link <- as.character(gsub("{year}", year, link, fixed = TRUE))

  if (is.null(dsn)) dsn <- tempfile(fileext = ".zip")

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Downloading SENAMHI alert geometry (nro {.val {nro}}, {.val {year}})", spinner = TRUE)
  }

  req <- httr2::request(link) |>
    httr2::req_timeout(timeout) |>
    httr2::req_options(ssl_verifypeer = FALSE) |>
    httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)
  if (isTRUE(show_progress)) req <- req |> httr2::req_progress()

  tryCatch(
    httr2::req_perform(req, path = dsn),
    error = function(e) {
      cli::cli_abort(c("Error downloading the file.", "x" = "{conditionMessage(e)}"))
    }
  )

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Extracting alert shapefile", spinner = TRUE)
  }
  extract_dir <- tempfile(); dir.create(extract_dir)
  archive::archive_extract(archive = dsn, dir = extract_dir)

  shp <- list.files(extract_dir, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)
  if (length(shp) == 0) cli::cli_abort("No .shp file found in the archive.")

  sf::st_read(shp[1], quiet = quiet)
}

#' Filter alert geometry by danger level
#'
#' This function filters the `sf` object from Senamhi by alert level (e.g., 1 to 4).
#'
#' @param sf_data An sf object returned by `senamhi_get_spatial_alerts()`.
#' @param level Numeric or character vector: values like 1, 2, 3, 4 or "Nivel 1", etc.
#' @return Filtered sf object.
#' @export
#' @examples
#' \dontrun{
#' senamhi_get_meteorological_table() |>
#'   senamhi_alert_by_number(295) |>
#'   senamhi_alerts_by_year(2024) |>
#'   senamhi_get_spatial_alerts(show_progress = FALSE) |>
#'   senamhi_geometry_by_level(3) |>
#'   plot()
#' }
senamhi_geometry_by_level <- function(sf_data, level) {
  if (!inherits(sf_data, "sf")) cli::cli_abort("Input must be an sf object.")

  levels_normalized <- if (is.numeric(level)) paste("Nivel", level) else level

  dplyr::filter(sf_data, nivel %in% levels_normalized)
}
