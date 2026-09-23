#' INEI administrative boundaries
#'
#' @description
#' Download the official political-division geometries published by the
#' National Institute of Statistics and Informatics (INEI):
#' \url{https://ide.inei.gob.pe/}. All three helpers share the same
#' download / extract / read pipeline with a [cli][cli::cli_progress_bar()]
#' progress bar.
#'
#' @details
#' * `get_departaments()` — level-1 (departamento).
#' * `get_provinces()` — level-2 (provincia).
#' * `get_districts()` — level-3 (distrito).
#'
#' Column names are normalised to lowercase (except the geometry column).
#'
#' @name inei
NULL

#' Shared INEI download pipeline with cli progress
#' @keywords internal
#' @noRd
.inei_download <- \(level = c("departamento", "provincia", "distrito"),
                    dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60) {
  level <- match.arg(level)
  primary_link <- get_inei_link(level)

  dsn_rar <- if (is.null(dsn)) {
    tempfile(pattern = level, fileext = ".rar")
  } else {
    if (!dir.exists(dsn)) dir.create(dsn, recursive = TRUE, showWarnings = FALSE)
    file.path(dsn, paste0(level, ".rar"))
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Downloading INEI {.val {level}} boundaries", spinner = TRUE)
  }

  rar.download <- tryCatch({
    req <- httr2::request(primary_link) |>
      httr2::req_timeout(timeout) |>
      httr2::req_options(ssl_verifypeer = FALSE) |>
      httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)
    if (isTRUE(show_progress)) req <- req |> httr2::req_progress()
    httr2::req_perform(req, path = dsn_rar)
  }, error = function(e) {
    cli::cli_abort(c("Error during download.", "x" = "{conditionMessage(e)}"))
  })

  if (httr2::resp_status(rar.download) >= 400) {
    cli::cli_abort(c(
      "Download failed.",
      "x" = "Status code: {httr2::resp_status(rar.download)}",
      "i" = "Check the URL or your internet connection."
    ))
  }

  extract_dir <- if (is.null(dsn)) {
    dir <- file.path(tempdir(), paste0("geoidep_data_", level))
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    dir
  } else {
    dir <- file.path(normalizePath(dsn, mustWork = FALSE), paste0(level, "_extract"))
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    dir
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Extracting {.val {level}} archive", spinner = TRUE)
  }
  archive::archive_extract(archive = dsn_rar, dir = extract_dir)

  gpkg_file <- dplyr::first(list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE))
  if (length(gpkg_file) == 0 || is.na(gpkg_file)) {
    cli::cli_abort(c(
      "No {.field .gpkg} file was found after extraction.",
      "x" = "Directory checked: {.path {extract_dir}}"
    ))
  }

  new_gpkg_file <- file.path(dirname(gpkg_file), tolower(basename(gpkg_file)))
  if (!identical(normalizePath(gpkg_file, mustWork = FALSE), normalizePath(new_gpkg_file, mustWork = FALSE))) {
    suppressWarnings(file.rename(from = gpkg_file, to = new_gpkg_file))
  }

  if (file.exists(dsn_rar)) suppressMessages(invisible(file.remove(dsn_rar)))

  sf_data <- .read_spatial_normalised(new_gpkg_file, quiet = quiet)
  attr(sf_data, "geoidep_gpkg") <- new_gpkg_file
  sf_data
}

#' Download INEI departmental boundaries
#'
#' @description
#' Download the latest version of the **geometry** and **ubigeos**
#' corresponding to the official political division of the departament boundaries of Peru.
#' For more information, visit \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @param departamento Character. Name or names in a vector of the level-1 administrative boundary (department) to query. Case-insensitive.
#' @param dsn Character. Directory where the file will be saved. If `NULL`, a temporary file is used.
#' @param show_progress Logical. Show a [cli][cli::cli_progress_bar()] progress bar. Default `TRUE`.
#' @param quiet Logical. Suppress info message from `sf::st_read()`.
#' @param timeout Numeric. Seconds to wait for a response. Default 60.
#' @returns An sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' dep <- get_departaments(show_progress = FALSE)
#' head(dep)
#' loreto <- get_departaments(departamento = "loreto", show_progress = FALSE)
#' head(loreto)
#' }
#' @export
get_departaments <- \(departamento = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60) {
  sf_data <- .inei_download("departamento", dsn = dsn, show_progress = show_progress, quiet = quiet, timeout = timeout)
  if (!is.null(departamento)) {
    sf_data <- sf_data |> dplyr::filter(nombdep %in% toupper(departamento))
    gpkg <- attr(sf_data, "geoidep_gpkg")
    if (!is.null(gpkg)) try(sf::write_sf(obj = sf_data, dsn = gpkg, delete_dsn = TRUE, quiet = TRUE), silent = TRUE)
  }
  sf_data
}

#' Download INEI province boundaries
#'
#' @description
#' Download the latest version of the **geometry** and **ubigeos**
#' corresponding to the official political division of the province boundaries of Peru.
#' For more information, visit \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @param departamento Character. Name of the level-1 administrative boundary (department). Case-insensitive.
#' @param provincia Character. Name of the level-2 administrative boundary (province). Case-insensitive. Requires `departamento`.
#' @param dsn Character. Directory where the file will be saved. If `NULL`, a temporary file is used.
#' @param show_progress Logical. Show a [cli][cli::cli_progress_bar()] progress bar.
#' @param quiet Logical. Suppress info message.
#' @param timeout Numeric. Seconds to wait for a response. Default 60.
#' @returns An sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' prov <- get_provinces(show_progress = FALSE)
#' head(prov)
#' }
#' @export
get_provinces <- \(departamento = NULL, provincia = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60) {
  if (is.null(departamento) && !is.null(provincia)) {
    cli::cli_abort("Must specify {.arg departamento} to filter by {.arg provincia}")
  }
  sf_data <- .inei_download("provincia", dsn = dsn, show_progress = show_progress, quiet = quiet, timeout = timeout)
  if (!is.null(departamento)) {
    sf_data <- sf_data |> dplyr::filter(nombdep %in% toupper(departamento))
  }
  if (!is.null(departamento) && !is.null(provincia)) {
    sf_data <- sf_data |> dplyr::filter(nombprov %in% toupper(provincia))
  }
  gpkg <- attr(sf_data, "geoidep_gpkg")
  if ((!is.null(departamento) || !is.null(provincia)) && !is.null(gpkg)) {
    try(sf::write_sf(obj = sf_data, dsn = gpkg, delete_dsn = TRUE, quiet = TRUE), silent = TRUE)
  }
  sf_data
}

#' Download INEI district boundaries
#'
#' @description
#' Download the latest version of the **geometry** and **ubigeos**
#' corresponding to the official political division of the district boundaries of Peru.
#' For more information, visit \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @details
#' - `r lifecycle::badge("stable")`. Stable API.
#' - If no filter is supplied, the full national district dataset is returned.
#'
#' @param departamento Character. Level-1 name. Case-insensitive.
#' @param provincia Character. Level-2 name. Case-insensitive.
#' @param distrito Character. Level-3 name. Case-insensitive.
#' @param dsn Character. Directory where the file will be saved. If `NULL`, a temporary file is used.
#' @param show_progress Logical. Show a [cli][cli::cli_progress_bar()] progress bar.
#' @param quiet Logical. Suppress info message.
#' @param timeout Numeric. Seconds to wait for a response. Default 60.
#' @returns An sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' dist <- get_districts(show_progress = FALSE)
#' head(dist)
#' lima <- get_districts(departamento = "lima", provincia = "lima", show_progress = FALSE)
#' head(lima)
#' }
#' @export
get_districts <- \(departamento = NULL, provincia = NULL, distrito = NULL,
                   dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60) {
  sf_data <- .inei_download("distrito", dsn = dsn, show_progress = show_progress, quiet = quiet, timeout = timeout)
  if (!is.null(departamento)) {
    sf_data <- sf_data[tolower(sf_data$nombdep) == tolower(departamento), ]
  }
  if (!is.null(provincia)) {
    sf_data <- sf_data[tolower(sf_data$nombprov) == tolower(provincia), ]
  }
  if (!is.null(distrito)) {
    sf_data <- sf_data[tolower(sf_data$nombdist) == tolower(distrito), ]
  }
  sf_data
}
