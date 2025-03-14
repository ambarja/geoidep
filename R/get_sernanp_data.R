#' Download the available data from Sernanp
#'
#' @description
#' This function allows you to download the latest version of data available on the sernanp geoviewer.
#' For more information, you can visit the following web page: \href{https://geo.sernanp.gob.pe/visorsernanp/}{Sernanp Platform}
#'
#' @param layer Select only one from the list of available layers, for more information please use `get_data_sources(provider = "sernanp")`. Defaults to NULL.
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
#' anp <- get_sernanp_data(layer = "zonificacion_anp" , show_progress = FALSE)
#' plot(st_geometry(anp))
#' }
#' @export

get_sernanp_data <- \(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE){

  primary_link <- get_sernanp_link(type = layer)

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
