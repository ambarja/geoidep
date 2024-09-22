#' Download data available at Serfor's Satellite Monitoring Unit
#'
#' @description
#' This function allows you to download the latest version of forest fire data available from the Satellite Monitoring Unit of the National Forestry and Wildlife Service of Peru.
#' For more information, please visit the following website: \url{https://sniffs.serfor.gob.pe/monitoreo/sami/index.html}
#'
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
#' fire_forest <- get_forest_fire_data(show_progress = FALSE)
#' head(fire_forest)
#' }
#' @export

get_forest_fire_data <- \(dsn = NULL, show_progress = TRUE, quiet = FALSE){

  primary_link <- get_fores_fire_link(type = "forest_fire")

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".geojson")
  }

  if (isTRUE(show_progress)) {
    data.download <- httr::GET(
      primary_link,
      query = list(where = "1=1",outFields = "*",f = "geojson"),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress(),
      httr::timeout(120)
    )
  } else {
    data.download <- httr::GET(
      primary_link,
      query = list(where = "1=1",outFields = "*",f = "geojson"),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::timeout(120)
    )
  }

  # Check if the download was successful
  if (httr::http_error( data.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  sf_data <- sf::st_read(dsn, quiet = quiet) |>
    dplyr::mutate(
      dplyr::across(
        c(
          FECREG,
          FECHA,
          created_date,
          last_edited_date
          ),
        ~ as_data_time(.)
        )
      )

  return(sf_data)

}
