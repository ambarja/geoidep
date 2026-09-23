#' INAIGEM mountain ecosystems
#'
#' @description
#' Glacier and high-mountain layers from the INAIGEM geoportal:
#' \url{https://geoportal.inaigem.gob.pe/}.
#'
#' @name inaigem
NULL

#' Download the available data from INAIGEM
#'
#' @description
#' Download the latest version of data available on the INAIGEM geoportal.
#' For more information, visit \href{https://geoportal.inaigem.gob.pe/}{INAIGEM Geoportal}.
#'
#' @param layer Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
#' @param dsn Character. Output filename. If missing, a temporary file is created.
#' @param show_progress Logical. Show a cli progress bar. Default `TRUE`.
#' @param quiet Logical. Suppress info message. Default `TRUE`.
#' @param timeout Numeric. Seconds to wait for a response. Default 60.
#' @returns An sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' library(sf)
#' glaciar <- get_inaigem_data(layer = "glaciares_1989", show_progress = FALSE)
#' head(glaciar)
#' plot(st_geometry(glaciar))
#' }
#' @export
get_inaigem_data <- \(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60){
  primary_link <- get_inaigem_link(type = layer)

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".geojson")
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Downloading INAIGEM layer {.val {layer}}", spinner = TRUE)
  }

  req <- httr2::request(primary_link) |>
    httr2::req_url_query(where = "1=1", outFields = "*", f = "geojson") |>
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

  sf_data <- .read_spatial_normalised(dsn, quiet = quiet)
  return(sf_data)
}
