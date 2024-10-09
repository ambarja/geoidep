#' Download Meteorological Alerts from Senamhi
#'
#' This function downloads and loads the spatial format of the weather warnings provided by Senamhi.
#' These geometries represent preventive forecasts for severe events, indicating the areas that may be affected and the level of danger.
#' For more information, please visit the following link: \url{https://www.Senamhi.gob.pe/?&p=aviso-meteorologico}
#'
#' @param data A data frame containing information on weather warnings provided by Senamhi.
#' @param nro A numeric value representing the weather warning number.
#' @param year A numeric value indicating the year of publication of the weather warning.
#' @param dsn A character string specifying the output filename with the \bold{spatial format}. If missing, a temporary file will be created.
#' @param show_progress A logical value indicating whether to suppress the progress bar.
#' @param quiet A logical value indicating whether to suppress informational messages.
#'
#' @return An sf object containing the spatial geometries of the weather alerts.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' get_meteorological_alerts(nro = 295, year = 2024, show_progress = FALSE ) |>
#' head()
#' }
#' @export

get_meteorological_alerts <- \(data = NULL, nro = NULL, year = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE){

  if(is.null(data)){
    nro_aviso <- nro
    year <- year
  } else{
    nro_aviso <- as.numeric(gsub("[^0-9]", "", data$nro))
    year <- as.numeric(gsub("^(\\d{4})-.*$", "\\1", data$emision))
  }

  primary_link <- glue::glue("https://idesep.Senamhi.gob.pe/geoserver/g_aviso/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=g_aviso:view_aviso&format_options=filename:shp_aviso_{nro_aviso}_1_{year}.zip&maxFeatures=50&viewparams=qry:{295}_1_{2024}&outputFormat=SHAPE-ZIP")

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".ZIP")
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

  # Check if the download was successful
  if (httr::http_error(rar.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  if (file.exists(dsn) && dir.exists(dsn)) {
    extract_dir <- dsn
  } else {
    extract_dir <- tempfile()
    dir.create(extract_dir)
  }

  archive::archive_extract(
    archive = dsn,
    dir = extract_dir
  )

  vector_file <- list.files(extract_dir, pattern = "\\.shp$", full.names = TRUE)

  # Validate if .gpkg file exists
  if (length(vector_file) == 0) {
    stop("No .gpkg file was found after extraction")
  }

  sf_data <- sf::st_read(vector_file, quiet = quiet)

  return(sf_data)
}


#' Download Weather Alert Table from Senamhi
#'
#' This function downloads the table of weather warnings provided by Senamhi
#' For more information, please visit the following link: \url{https://www.Senamhi.gob.pe/?&p=aviso-meteorologico}
#'
#' @return A tibble object containing the weather alert data.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' extract_meteorological_table() |> head()
#' }
#' @export
extract_meteorological_table <- \() {
  url <- "https://www.Senamhi.gob.pe/?&p=aviso-meteorologico"

  # Barra de progreso para la descarga
  pb_descarga <- progress::progress_bar$new(
    format = " Downloading website [:bar] :percent in :elapsed",
    total = 3, clear = FALSE, width = 60
  )

  # Simulación de la descarga
  pb_descarga$tick()
  Sys.sleep(0.5)

  # Leer la página web
  message("Reading data from the website...")
  pg <- rvest::read_html(url)
  pb_descarga$tick()
  Sys.sleep(0.5)

  # Extraer la tabla
  tablas_raw <- rvest::html_table(pg, fill = TRUE)

  # Verificar si la tabla está disponible
  if (length(tablas_raw) == 0) {
    message("No tables were found on the website.")
    return(NULL)
  }

  # Procesar la primera tabla encontrada
  tablas_processed <- tablas_raw[[1]][-1,]
  names(tablas_processed) <- c("aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel")

  pb_descarga$tick()
  Sys.sleep(0.5)

  message("Data successfully uploaded.")
  return(tablas_processed)
}


#' Get information from a Senamhi weather alert according to the year.
#'
#' This function obtains a table with the specified weather warning number.
#' For more information, please visit the following link: \url{https://www.Senamhi.gob.pe/?&p=aviso-meteorologico}
#'
#' @param nro A numeric value representing the weather warning number.
#'
#' @return A tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' get_nro_emision(295)
#' }
#' @export
get_nro_emision <- function(nro = NULL){
  tabla <- extract_meteorological_table()
  resultado_filtrado <- tabla[as.numeric(gsub("[^0-9]", "", tabla$nro)) %in% as.numeric(nro), ]
  return(resultado_filtrado)
}


#' Download Meteorological Alerts from Senamhi
#' This function downloads the weather forecast table provided by Senamhi according to the specified year.
#' @param year A numeric value indicating the year of publication of the weather warning.
#'
#' @return A tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' get_year(2024) |>
#'  head()
#' }
#' @export

get_year <- function(year = NULL) {
  extract_meteorological_table() |>
    dplyr::filter(substr(emision, 1, 4) == as.character(year))
}
