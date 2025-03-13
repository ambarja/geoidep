#' Downloading available hazard data from the SIGRID platform
#'
#' @description
#' This function allows you to download the latest version of the harzards data available on the SIGRID geoportal.
#' For more information, you can visit the following web page: \href{https://sigrid.cenepred.gob.pe/sigridv3/}{SIGRID Geoportal}
#'
#' @param layer Select only one from the list of available layers, for more information please use `get_data_sources(provider = "mtc")`. Defaults to NULL.
#' @param dsn Character. Output filename with the \bold{spatial format}. If missing, a temporary file is created.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#'
#' @returns An sf object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' library(sf)
#' inundaciones <- get_hazard_data(layer = "inundacion_inventario" , show_progress = FALSE)
#' head(inundaciones)
#' plot(st_geometry(inundaciones))
#' }
#' @export

get_hazard_data <- \(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = FALSE){

  primary_link <- get_hazard_link(type = layer)

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".geojson")
  }

  if (isTRUE(show_progress)) {
    data.download <- httr::GET(
      primary_link,
      query = list(where = "1=1",outFields = "*",f = "geojson"),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress(),
      httr::timeout(60)
    )
  } else {
    data.download <- httr::GET(
      primary_link,
      query = list(where = "1=1",outFields = "*",f = "geojson"),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::timeout(60)
    )
  }

  # Check if the download was successful
  if (httr::http_error( data.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  sf_data <- sf::st_read(dsn, quiet = quiet)

  return(sf_data)
}
