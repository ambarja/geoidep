#' Download INEI province boundaries
#'
#' @description
#' This function allows you to download the latest version of the \bold{geometry} and \bold{ubigeos}
#' corresponding to the \bold{official political division} of the province boundaries of Peru.
#' For more information, you can visit the following page \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @param dsn Character. Path to the output \code{.gpkg} file or a directory where the file will be saved.
#' If a directory is provided, the file will be saved as \code{PROVINCIA.gpkg} inside it.
#' If \code{NULL}, a temporary file will be created.
#' If the path contains multiple subdirectories, they will be created automatically if they do not exist.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#' @param timeout Seconds. Number of seconds to wait for a response until giving up. Cannot be less than 1 ms. Default is 10.
#'
#' @returns An sf or tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' prov <- get_provinces(show_progress = FALSE)
#' head(prov)
#' }
#' @export

get_provinces <- \(dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 10){
    primary_link <- get_inei_link("provincia")

    if (is.null(dsn)) {
      dsn <- tempfile(fileext = ".rar")
    } else {
      if (!dir.exists(dsn)) {
        dir.create(dsn, recursive = TRUE, showWarnings = FALSE)
      }
      dsn <- file.path(dsn, "provincia.rar")
    }

    rar.download <- tryCatch({
      if (isTRUE(show_progress)) {
        httr::GET(
          primary_link,
          config = c(
            httr::config(ssl_verifypeer = FALSE),
            httr::timeout(seconds = timeout)),
          httr::write_disk(dsn, overwrite = TRUE),
          httr::progress()
        )
      } else {
        httr::GET(
          primary_link,
          config = c(
            httr::config(ssl_verifypeer = FALSE),
            httr::timeout(seconds = timeout)),
          httr::write_disk(dsn, overwrite = TRUE)
        )
      }
    },error = function(e){
      stop("Error during download:", conditionMessage(e))
    }
    )

    # Check if the download was successful
    if (httr::http_error(rar.download)) {
      stop("Error downloading the file. Check the URL or connection")
    }

    extract_dir <- file.path(tempdir(), "geoidep_data_prov")
    dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
    archive::archive_extract(archive = dsn, dir = extract_dir)
    gpkg_files <- dplyr::first(list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE))

    if (length(gpkg_files) == 0) {
      stop("No .gpkg file was found after extraction in: ", extract_dir)
    }

    gpkg_file <- dplyr::first(gpkg_files)

    if (!file.exists(gpkg_file)) {
      stop("Extracted file does not exist: ", gpkg_file)
    }

    new_gpkg_file <- file.path(dirname(gpkg_file), tolower(basename(gpkg_file)))

    if (!file.rename(from = gpkg_file, to = new_gpkg_file)) {
      stop("Error renaming file from: ", gpkg_file, " to: ", new_gpkg_file)
    }

    if (file.exists(dsn)) {
      suppressMessages(invisible(file.remove(dsn)))
    }

    sf_data <- sf::st_read(new_gpkg_file, quiet = quiet)
    non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
    names(sf_data)[non_geom_idx] <- toupper(names(sf_data)[non_geom_idx])
    return(sf_data)
}
