#' Download Geographic Information from MIDAGRI
#'
#' @description
#' This function downloads the latest version of geographic data representing various types of agricultural areas in Peru. For more details, please visit the following page: \url{https://siea.midagri.gob.pe/}.
#'
#' @param dsn Character. The output filename in \bold{.shp or .gpkg} format. If not provided, a temporary file will be created.
#' @param layer Character. Specifies the layer to download. Available layers are detailed in the 'Details' section.
#' @param show_progress Logical. If TRUE, displays a progress bar during the download.
#' @param quiet Logical. If TRUE, suppresses informational messages.
#'
#' @details
#' Available layers are:
#' \itemize{
#'   \item \bold{vegetation cover:} Polygons representing agricultural areas of Peru, produced from high-resolution satellite images (RapidEye and Sentinel-2).
#'   \item \bold{agriculture sector:} Polygons representing the new national register of agricultural statistical sectors for the year 2024.
#'   \item \bold{oil palm:} Polygons representing areas cultivated with oil palm in Peru for the period 2016 to 2020.
#'   \item \bold{experimental stations:} Points representing agricultural experimental stations in Peru.
#' }
#'
#' @return An `sf` object containing the downloaded geographic data.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' library(sf)
#' # Disable the use of S2 geometry for accurate spatial operations
#' sf_use_s2(use_s2 = FALSE)
#'
#' # Retrieve the polygon for Coronel Portillo province
#' coronel_portillo <- get_provinces(show_progress = FALSE) |>
#'   subset(NOMBPROV == "CORONEL PORTILLO") |>
#'   st_transform(crs = 32718)
#'
#' # Download and extract the oil palm layer for Coronel Portillo
#' oil_palm <- get_midagri_data(
#'   layer = "oil palm",
#'   show_progress = FALSE
#' ) |>
#'   st_intersection(coronel_portillo)
#'
#' # Visualize the oil palm layer
#' plot(st_geometry(oil_palm))
#' }
#' @export

get_midagri_data <- function(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE) {

  primary_link <- get_midagri_link(layer)

  # Check the file's format
  is_zip <- grepl("\\.zip$", primary_link)
  is_rar <- grepl("\\.rar$", primary_link)
  is_js <- grepl("\\.js$", primary_link)

  if (is.null(dsn)) {
    if (is_rar) {
      dsn <- tempfile(fileext = ".rar")
    } else if (is_zip) {
      dsn <- tempfile(fileext = ".zip")
    } else if (is_js) {
      dsn <- tempfile(fileext = ".geojson")
    } else {
      dsn <- tempfile()  # Use a generic temporary file if format is unknown
    }
  }

  # Download the file
  if (isTRUE(show_progress)) {
    data.download <- httr::GET(
      primary_link,
      httr::set_config(httr::config(ssl_verifypeer = 0L)),
      httr::write_disk(dsn, overwrite = TRUE),
      httr::progress()
    )
  } else {
    data.download <- httr::GET(
      primary_link,
      httr::set_config(httr::config(ssl_verifypeer = 0L)),
      httr::write_disk(dsn, overwrite = TRUE)
    )
  }

  # Check if the download was successful
  if (httr::http_error(data.download)) {
    stop("Error downloading the file. Status code: ", httr::status_code(data.download))
  }

  # Check if the file was downloaded
  if (!file.exists(dsn)) {
    stop("Failed to download the file.")
  }

  if (is_js) {
    geojson_content <- httr::content(data.download, as = "text", encoding = "UTF-8")

    # Define the text to remove
    text_to_remove <- "var geojson_estaciones_experimentales = "

    # Remove the text
    cleaned_content <- gsub(text_to_remove, "", geojson_content, fixed = TRUE)

    writeLines(cleaned_content, dsn)

    # Read the GeoJSON file using sf
    sf_data <- sf::st_read(dsn)

  } else {
    extract_dir <- tempfile()
    dir.create(extract_dir)

    # Extract the first file
    archive::archive_extract(
      archive = dsn,
      dir = extract_dir
    )

    # Look for a second file
    second_rar <- list.files(extract_dir, pattern = "\\.(rar|zip)$", full.names = TRUE, recursive = TRUE)

    if (length(second_rar) > 0) {
      # Extract the second .rar file
      archive::archive_extract(
        archive = second_rar[1],
        dir = extract_dir
      )
    }

    # Look for .shp files
    shp_file <- list.files(extract_dir, pattern = "\\.(shp|gpkg)$", full.names = TRUE, recursive = TRUE)[1]

    # Validate if a .shp file exists
    if (length(shp_file) == 0) {
      stop("No .shp file was found after extraction")
    }

    # Read the .shp file using sf
    sf_data <- sf::st_read(shp_file, quiet = quiet)
  }

  return(sf_data)
}
