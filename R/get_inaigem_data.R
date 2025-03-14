#' Download the available data from INAIGEM
#'
#' @description
#' This function allows you to download the latest version of data available on the INAIGEM geoportal.
#' For more information, you can visit the following web page: \href{https://geoportal.inaigem.gob.pe/}{INAIGEM Geoportal}
#'
#' @param layer Select only one from the list of available layers, for more information please use `get_data_sources(provider = "INAIGEM")`. Defaults to NULL.
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
#' glaciar <- get_inaigem_data(layer = "glaciares_1989" , show_progress = FALSE)
#' head(glaciar)
#' plot(st_geometry(glaciar))
#' }
#' @export

get_inaigem_data <- \(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60){

  primary_link <- get_inaigem_link(type = layer)

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".GeoJSON")
  }

  data.download <- tryCatch({
    if (isTRUE(show_progress)) {
      httr::GET(
        primary_link,
        query = list(where = "1=1",outFields = "*",f = "geojson"),
        config = c(
          httr::config(ssl_verifypeer = FALSE),
          httr::timeout(seconds = timeout)),
        httr::write_disk(dsn, overwrite = TRUE),
        httr::progress()
      )
    } else {
      httr::GET(
        primary_link,
        query = list(where = "1=1",outFields = "*",f = "geojson"),
        config = c(
          httr::config(ssl_verifypeer = FALSE),
          httr::timeout(seconds = timeout)),
        httr::write_disk(dsn, overwrite = TRUE)
      )
    }
  },error = function(e){
    stop("Error during download:", conditionMessage(e))}
  )

  # Check if the download was successful
  if (httr::http_error(data.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  extract_dir <- file.path(tempdir(), "geoidep_data_mtc")
  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  suppressMessages(invisible(file.copy(from = dsn, to = extract_dir)))
  gpkg_files <- dplyr::first(list.files(extract_dir, pattern = "\\.GeoJSON$", full.names = TRUE))

  if (length(gpkg_files) == 0) {
    stop("No .gpkg file was found after extraction in: ", extract_dir)
  }

  geojson_file <- dplyr::first(gpkg_files)

  if (!file.exists(geojson_file)) {
    stop("Extracted file does not exist: ", geojson_file)
  }

  new_geojson_file <- file.path(dirname(geojson_file), tolower(basename(geojson_file)))

  if (!file.rename(from = geojson_file, to = new_geojson_file)) {
    stop("Error renaming file from: ", geojson_file, " to: ", new_geojson_file)
  }

  if (file.exists(dsn)) {
    suppressMessages(invisible(file.remove(dsn)))
  }

  sf_data <- sf::st_read(new_geojson_file, quiet = quiet)
  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])

  return(sf_data)
}
