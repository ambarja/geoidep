#' SERFOR hotspots (SAMI)
#'
#' @description
#' Active fire / heat-spot data from the Satellite Monitoring Unit (SAMI) of
#' the National Forestry and Wildlife Service:
#' \url{https://sniffs.serfor.gob.pe/monitoreo/sami/index.html}.
#'
#' @name serfor
NULL

#' Download available hot spot data from Serfor's Satellite Monitoring Unit
#'
#' @description
#' Download the latest version of forest fire data available from the Satellite Monitoring Unit of the National Forestry and Wildlife Service of Peru.
#' For more information, visit \href{https://sniffs.serfor.gob.pe/monitoreo/sami/index.html}{Serfor Platform}.
#'
#' @param dsn Character. Output filename. If missing, a temporary file is created.
#' @param show_progress Logical. Show a cli progress bar. Default `TRUE`.
#' @param quiet Logical. Suppress message from `sf::st_read()`. Default `TRUE`.
#' @returns An sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' library(sf)
#' hot_spots <- get_hotspots_data(show_progress = FALSE)
#' head(hot_spots)
#' }
#' @export
get_hotspots_data <- \(dsn = NULL, show_progress = TRUE, quiet = TRUE){
  primary_link <- get_heat_spot_link(type = "heat_spot")

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".geojson")
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Downloading SERFOR heat spots", spinner = TRUE)
  }

  req <- httr2::request(primary_link) |>
    httr2::req_url_query(where = "1=1", outFields = "*", f = "geojson") |>
    httr2::req_timeout(120) |>
    httr2::req_options(ssl_verifypeer = FALSE) |>
    httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)
  if (isTRUE(show_progress)) req <- req |> httr2::req_progress()

  tryCatch(
    httr2::req_perform(req, path = dsn),
    error = function(e) {
      cli::cli_abort(c("Error downloading the file.", "x" = "{conditionMessage(e)}"))
    }
  )

  sf_data <- sf::st_read(dsn, quiet = quiet) |>
    dplyr::mutate(
      dplyr::across(
        c(FECREG, FECHA, created_date, last_edited_date),
        ~ as_data_time(.)
      )
    )

  return(sf_data)
}
