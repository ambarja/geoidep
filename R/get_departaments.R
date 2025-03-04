#' Download INEI departmental boundaries
#'
#' @description
#' This function allows you to download the latest version of the \bold{geometry} and \bold{ubigeos}
#' corresponding to the \bold{official political division} of the departament boundaries of Peru.
#' For more information, you can visit the following page \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}
#'
#' @param dsn Character. Path to the output `.gpkg` file or a directory where the file will be saved.
#' If a directory is provided, the file will be saved as `departamento.gpkg` inside it.
#' If `NULL`, a temporary file will be created.
#' If the path contains multiple subdirectories, they will be created automatically if they do not exist.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#'
#' @returns An sf or tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' dep <- get_departaments(show_progress = FALSE)
#' head(dep)
#' }
#' @export

get_departaments <- \(dsn = NULL, show_progress = TRUE, quiet = TRUE) {
  primary_link <- get_inei_link("departamento")
  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".rar")
  } else {
    if (!dir.exists(dsn)) {
      dir.create(dsn, recursive = TRUE, showWarnings = FALSE)
    }
    dsn <- file.path(dsn, "departamento.rar")
  }

  rar.download <- if (isTRUE(show_progress)) {
    httr::GET(
      primary_link,
      config = httr::config(ssl_verifypeer = FALSE),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress()
    )
  } else {
    httr::GET(
      primary_link,
      config = httr::config(ssl_verifypeer = FALSE),
      httr::write_disk(dsn, overwrite = TRUE)
    )
  }

  if (httr::http_error(rar.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  extract_dir <- if (is.null(dsn)) {
    tempfile()
  } else {
    dirname(dsn)
  }

  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  archive::archive_extract(archive = dsn, dir = extract_dir)

  if (file.exists(dsn)) {
    suppressMessages(invisible(file.remove(dsn)))
  }

  gpkg_file <- dplyr::first(list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE))

  if (length(gpkg_file) > 0) {
    gpkg_file <- gpkg_file[1]
  } else {
    stop("No .gpkg file was found after extraction. Check the extracted files.")
  }

  suppressMessages(invisible(file.rename(from = gpkg_file, to = tolower(gpkg_file))))

  if (length(gpkg_file) == 0) {
    stop("No .gpkg file was found after extraction. Check the extracted files.")
  }

  sf_data <- sf::st_read(gpkg_file, quiet = quiet)

  return(sf_data)
}

