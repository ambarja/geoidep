#' Download the available data from MTC
#'
#' @description
#' This function allows you to download the latest version of data available on the MTC geoportal.
#' For more information, you can visit the following web page: \href{https://geoportal.mtc.gob.pe/}{MTC Geoportal}
#'
#' @param layer Select only one from the list of available layers, for more information please use `get_data_sources(provider = "mtc")`. Defaults to NULL.
#' @param dsn Character. Output filename with the \bold{spatial format}. If missing, a temporary file is created.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#' @param timeout Seconds. Number of seconds to wait for a response until giving up. Cannot be less than 1 ms. Default is 60.
#'
#' @returns An sf object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' library(sf)
#' aerodromo <- get_mtc_data(layer = "aerodromos_2023" , show_progress = FALSE)
#' head(aerodromo)
#' plot(st_geometry(aerodromo))
#' }
#' @export

get_mtc_data <- \(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60){

  primary_link <- get_mtc_link(type = layer)

  if (is.null(dsn)) {
    dsn <- tempfile(pattern = layer, fileext = ".gpkg")
  }

  data.download <- tryCatch(
    httr::RETRY(
      verb = "GET",
      url = primary_link,
      times = 3,
      pause_base = 1,
      pause_cap = 5,
      terminate_on = c(400, 401, 403, 404),
      config = httr::config(ssl_verifypeer = FALSE),
      httr::timeout(timeout),
      httr::write_disk(dsn, overwrite = TRUE)
    ),
    error = function(e) {
      stop(
        paste(
          "Unable to download data from the MTC server.",
          "The service may be temporarily unavailable.",
          "Please try again later.",
          "\n\nOriginal error:",
          conditionMessage(e)
        ),
        call. = FALSE
      )
    }
  )

  # Check if the download was successful
  if (httr::http_error(data.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  extract_dir <- file.path(tempdir(), paste0("geoidep_data_mtc_", layer))
  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  suppressMessages(invisible(file.copy(from = dsn, to = extract_dir)))
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

  sf_data <- suppressWarnings(sf::st_read(new_gpkg_file, quiet = quiet))
  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])
  sf::st_crs(sf_data) <- 4326

  # Remove gml_id
  if ("gml_id" %in% names(sf_data)) {
    sf_data$gml_id <- NULL
  }

  return(sf_data)
}
