#' Download INEI district boundaries
#'
#' @description
#' This function allows you to download the latest version of the \bold{geometry} and \bold{ubigeos}
#' corresponding to the \bold{official political division} of the district boundaries of Peru.
#' For more information, you can visit the following page \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @param dsn Character. Path to the output \code{.gpkg} file or a directory where the file will be saved.
#' If a directory is provided, the file will be saved as \code{DISTRITO.gpkg} inside it.
#' If \code{NULL}, a temporary file will be created.
#' If the path contains multiple subdirectories, they will be created automatically if they do not exist.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#'
#' @returns An sf object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' dist <- get_districts(show_progress = FALSE)
#' head(dist)
#' }
#' @export

get_districts <- \(dsn = NULL, show_progress = TRUE, quiet = TRUE) {
  primary_link <- get_inei_link("distrito")

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".rar")
  } else {
    if (!dir.exists(dsn)) {
      dir.create(dsn, recursive = TRUE, showWarnings = FALSE)
    }
    dsn <- file.path(dsn, "distrito.rar")
  }

  if (isTRUE(show_progress)) {
    rar.download <- httr::GET(
      primary_link,
      config = httr::config(ssl_verifypeer = FALSE),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress()
    )
  } else {
    rar.download <- httr::GET(
      primary_link,
      config = httr::config(ssl_verifypeer = FALSE),
      httr::write_disk(dsn, overwrite = TRUE)
    )
  }

  if (httr::http_error(rar.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  extract_dir <- file.path(tempdir(), "geoidep_data")
  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  archive::archive_extract(archive = dsn, dir = extract_dir)
  gpkg_file <- dplyr::first(list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE))
  suppressMessages(invisible(file.rename(from = gpkg_file, to = tolower(gpkg_file))))

  # Validate if .gpkg file exists
  if (length(gpkg_file) == 0) {
    stop("No .gpkg file was found after extraction")
  }

  if (file.exists(dsn)) {
    suppressMessages(invisible(file.remove(dsn)))
  }

  sf_data <- sf::st_read(gpkg_file, quiet = quiet)

  return(sf_data)
}
