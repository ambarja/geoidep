#' Download the geographic information from MIDAGRI
#'
#' @description
#' This function downloads the latest version of the \bold{geographic data} representing the \bold{agricultural area} of Peru.
#' For more details, please visit the following page: \url{https://siea.midagri.gob.pe/portal/informativos/superficie-agricola-peruana}.
#'
#' @param dsn Character. The output filename in \bold{*.shp} format. If not provided, a temporary file will be created.
#' @param layer Character. Currently, Has three layer available, please review in details sections.
#' @param show_progress Logical. If TRUE, displays a progress bar.
#' @param quiet Logical. If TRUE, suppresses informational messages.
#'
#' @details
#' Available layer:
#' \itemize{
#' \item \bold{vegetation cover:} Polygons representing the agricultural areas of Peru, produced with high-resolution satellite images (RapidEye and Sentinel-2).
#' \item \bold{agriculture sector:} Polygons representing the new national register of agricultural statistical sectors for the year 2024.
#' \item \bold{oil palm:} Polygons representing the areas cultivated with oil palm in Peru for the period 2016 to 2020.
#' }
#'
#' @return An `sf` object containing the downloaded geographic data.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' library(mapview)
#' oil_palm <- get_midagri_data(layer = "oil palm", show_progress = FALSE)
#' # Plotting the geometry of the vegetation cover
#' mapview(oil_palm)
#' }
#' @export

get_midagri_data <- function(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE) {

  primary_link <- get_midagri_link(layer)

  # Check the file's format
  is_zip <- grepl("\\.zip$", primary_link)
  is_rar <- grepl("\\.rar$", primary_link)

  if (is.null(dsn)) {
    if (is_rar) {
      dsn <- tempfile(fileext = ".rar")
    } else if (is_zip) {
      dsn <- tempfile(fileext = ".zip")
    } else {
      dsn <- tempfile()  # Use a generic temporary file if format is unknown
    }
  }

  # Descargar el archivo
  if (isTRUE(show_progress)) {
    rar.download <- httr::GET(
      primary_link,
      httr::set_config(httr::config(ssl_verifypeer = 0L)),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress()
    )
  } else {
    rar.download <- httr::GET(
      primary_link,
      httr::set_config(httr::config(ssl_verifypeer = 0L)),
      httr::write_disk(dsn, overwrite = TRUE)
    )
  }

  # Verificar si la descarga fue exitosa
  if (httr::http_error(rar.download)) {
    stop("Error downloading the file. Status code: ", httr::status_code(rar.download))
  }

  # Verificar si el archivo ha sido descargado
  if (!file.exists(dsn)) {
    stop("Failed to download the file.")
  }

  extract_dir <- tempfile()
  dir.create(extract_dir)

  # Extraer el primer archivo
  archive::archive_extract(
    archive = dsn,
    dir = extract_dir
  )

  # Buscar un segundo archivo
  second_rar <- list.files(extract_dir, pattern = "\\.(rar|zip)$", full.names = TRUE, recursive = TRUE)

  if (length(second_rar) > 0) {
    # Extraer el segundo archivo .rar
    archive::archive_extract(
      archive = second_rar[1],
      dir = extract_dir
    )
  }

  # Buscar archivos .shp
  shp_file <- list.files(extract_dir, pattern = "\\.(shp|gpkg)$", full.names = TRUE, recursive = TRUE)[1]

  # Validar si existe un archivo .shp
  if (length(shp_file) == 0) {
    stop("No .shp file was found after extraction")
  }

  # Leer el archivo .shp usando sf
  sf_data <- sf::st_read(shp_file, quiet = quiet)

  return(sf_data)
}
