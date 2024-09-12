#' Download information on the latest deforestation alerts detected by Geobosque
#'
#' @description
#' This function allows you to download deforestation alert information detected by Geobosque
#' for any polygon located in Peru.
#' For more details, please visit the following website: \url{https://geobosques.minam.gob.pe}
#'
#' @param region Character. Specifies the unique geographical code of interest.
#' @param sf Logical. Indicates whether to return the data as an `sf` object.
#' @param show_progress Logical. If TRUE, shows a progress bar during download.
#' @return A tibble or sf object, depending on the value of `sf`.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' amazonas <- get_departaments(show_progress = FALSE) |> subset(NOMBDEP == "AMAZONAS")
#' warning_point <- get_early_warning(region = amazonas, sf = TRUE, show_progress = FALSE)
#' head(warning_point)
#' }
#' @export
get_early_warning <- function(region, sf = TRUE, show_progress = TRUE) {

  # Defined URL of API Geobosque
  url <- get_early_warning_link(type = "warning_last_week")

  # Check if the CRS is WGS 84 (EPSG:4326)
  if (sf::st_crs(region)$epsg == 4326) {
    region_check <- sf::st_geometry(region)
  } else {
    stop("The layer must be in CRS: EPSG 4326 (WGS 84).")
  }

  # Defined coordinates of the region of interest
  coords_str <- region_check |>
    sf::st_cast('POINT') |>
    sf::st_coordinates() |>
    as.data.frame()

  # Concatenate all coordinates into a single row separated by commas
  coords_str <- coords_str |>
    dplyr::mutate(coords = paste(X, Y, sep = " ")) |>
    dplyr::summarise(all_coords = paste(coords, collapse = ", ")) |>
    dplyr::pull(all_coords)

  request <- list("coords" = coords_str)

  # Conditional for showing progress
  if (isTRUE(show_progress)) {
    data_raw <- httr::POST(
      url = url,
      body = request,
      encode = "json",
      httr::progress()) |>
      httr::content(as = "text", encoding = "UTF-8")
  } else {
    data_raw <- httr::POST(
      url = url,
      body = request,
      encode = "json") |>
      httr::content(as = "text", encoding = "UTF-8")
  }

  # Remove UTF-8 BOM if present
  data_clean <- sub("\ufeff", "", data_raw)

  # Convert data to tibble format
  tidydata <- data_clean |>
    jsonlite::fromJSON() |>
    tidyr::as_tibble()

  # Extract and clean data
  tidydata <- tidydata[["datos"]]
  names(tidydata) <- gsub("_$", "", names(tidydata))

  # Format the final data and return
  geobosque <- tidydata |>
    as.data.frame() |>
    dplyr::mutate_if(is.character, as.numeric)

  # Warning points data
  data <- geobosque |>
    dplyr::rename_with(~ c("lng", "lat"), everything()) |>
    dplyr::mutate(
      lng = as.double(lng),
      lat = as.double(lat),
      descrip = "Warning points") |>
    tidyr::as_tibble()

  # Define spatial format
  if (isTRUE(sf)) {
    data_output <- data |> sf::st_as_sf(coords = c('lng', 'lat'), crs = 4326)
  } else {
    data_output <- data
  }

  return(data_output)
}
