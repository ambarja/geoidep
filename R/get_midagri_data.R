#' Download the geographic information from MIDAGRI
#'
#' @description
#' This function downloads the latest version of the \bold{geographic data} representing the \bold{agricultural area} of Peru.
#' For more details, please visit the following page: \url{https://siea.midagri.gob.pe/portal/informativos/superficie-agricola-peruana}.
#'
#' @param dsn Character. The output filename in \bold{*.shp} format. If not provided, a temporary file will be created.
#' @param layer Character. Currently, only one layer is available.
#' @param show_progress Logical. If TRUE, displays a progress bar.
#' @param quiet Logical. If TRUE, suppresses informational messages.
#'
#' @details
#' Available layer:
#' \itemize{
#' \item \bold{vegetation cover:} The agricultural area of Peru in shapefile format, provided at the national level by SIEA.
#' }
#'
#' @returns An `sf` object containing the downloaded geographic data.
#'
#' @examples
#' library(geoidep)
#' library(sf)
#' # Disable the use of S2 geometry for spatial operations
#' sf_use_s2(use_s2 = FALSE)
#'
#' # Downloading data and filtering by department
#' junin <- get_departaments(show_progress = FALSE) |>
#'   subset(NOMBDEP == "JUNIN")
#'
#' # Performing an intersection between the Junin department and vegetation cover
#' cov_veg <- get_midagri_data(layer = "vegetation cover", show_progress = FALSE) |>
#'   st_intersection(junin)
#'
#' # Plotting the geometry of the intersected vegetation cover
#' plot(st_geometry(cov_veg))
#' @export

get_midagri_data <- \(dsn = NULL, layer = NULL, show_progress = TRUE, quiet = TRUE) {

  options(internet.info = 0)
  primary_link <- get_midagri_link(layer)

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".rar")
  }

  if (isTRUE(show_progress)) {
    rar.download <- httr::GET(
      primary_link,
      httr::set_config(httr::config(ssl_verifypeer=0L)),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress()
    )
  } else {
    rar.download <- httr::GET(
      primary_link,
      httr::set_config(httr::config(ssl_verifypeer=0L)), 
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

  # The first rar
  archive::archive_extract(
    archive = dsn,
    dir = extract_dir
  )

  # The second rar
  second_rar <- list.files(extract_dir, pattern = "\\.rar$", full.names = TRUE, recursive = TRUE)

  # Verificar que exista un archivo .rar en el directorio
  if (length(second_rar) > 0) {
    # Descomprimir el segundo .rar
    archive::archive_extract(
      archive = second_rar[1], # Lectura unicamente del shapefile
      dir = extract_dir # Extraer en el mismo directorio o en otro si prefieres
    )
  } else {
    message("No other .rar file was found to decompress.")
  }

  shp_file <- list.files(extract_dir, pattern = "\\.shp$", full.names = TRUE, recursive = TRUE)

  # Validate if .gpkg file exists
  if (length(shp_file) == 0) {
    stop("No .shp file was found after extraction")
  }

  sf_data <- sf::st_read(shp_file, quiet = quiet)

  return(sf_data)
}
