#' Download the available data from MTC
#'
#' @description
#' Download the latest version of data available on the MTC geoportal.
#' For more information, visit \href{https://geoportal.mtc.gob.pe/}{MTC Geoportal}.
#'
#' @param layer Select only one from the list of available layers, for more information please use `get_data_sources(provider = "mtc")`. Defaults to NULL.
#' @param dsn Character. Output filename with the **spatial format**. If missing, a temporary file is created.
#' @param show_progress Logical. Show a cli progress bar. Default `TRUE`.
#' @param quiet Logical. Suppress info message. Default `TRUE`.
#' @param timeout Numeric. Seconds to wait for a response. Default 60.
#' @returns An sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' library(sf)
#' aerodromo <- get_mtc_data(layer = "aerodromos_2023", show_progress = FALSE)
#' head(aerodromo)
#' plot(st_geometry(aerodromo))
#' }
#' @export
get_mtc_data <- \(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60) {
  primary_link <- get_mtc_link(type = layer)
  if (is.null(dsn)) {
    dsn <- tempfile(pattern = layer, fileext = ".gpkg")
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Downloading MTC layer {.val {layer}}", spinner = TRUE)
  }

  req <- httr2::request(primary_link) |>
    httr2::req_timeout(timeout) |>
    httr2::req_options(ssl_verifypeer = FALSE) |>
    httr2::req_retry(max_tries = 2, retry_on_failure = TRUE)
  if (isTRUE(show_progress)) req <- req |> httr2::req_progress()

  tryCatch(
    httr2::req_perform(req, path = dsn),
    error = function(e) {
      cli::cli_abort(c(
        "x" = "Unable to download from MTC server",
        "!" = "The service may be temporarily unavailable",
        "i" = "Error: {conditionMessage(e)}"
      ))
    }
  )

  extract_dir <- file.path(tempdir(), paste0("geoidep_data_mtc_", layer))
  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  suppressMessages(invisible(file.copy(from = dsn, to = extract_dir)))

  gpkg_files <- list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE)
  if (length(gpkg_files) == 0) {
    cli::cli_abort("No .gpkg file found after download in {.path {extract_dir}}")
  }

  gpkg_file <- dplyr::first(gpkg_files)
  new_gpkg_file <- file.path(dirname(gpkg_file), tolower(basename(gpkg_file)))
  if (!identical(normalizePath(gpkg_file, mustWork = FALSE), normalizePath(new_gpkg_file, mustWork = FALSE))) {
    suppressWarnings(file.rename(from = gpkg_file, to = new_gpkg_file))
  }
  if (file.exists(dsn)) suppressMessages(invisible(file.remove(dsn)))

  sf_data <- suppressWarnings(.read_spatial_normalised(new_gpkg_file, quiet = quiet))
  sf::st_crs(sf_data) <- 4326

  if ("gml_id" %in% names(sf_data)) {
    sf_data$gml_id <- NULL
  }

  return(sf_data)
}
