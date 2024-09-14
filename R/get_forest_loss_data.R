#' Download the forest and loss information from Geobosque
#'
#' @description
#' This function allows you to download the \bold{ubigeos} corresponding to the official political division
#' of the district, province or region boundaries of Peru with \bold{forest and loss information}.
#' For more information, you can visit the following website: \url{https://geobosques.minam.gob.pe}
#'
#' @param ubigeo A string Specifies the unique geographical code of interest.
#' @param level A string. Specifies the official administrative division level of interest.
#' @param show_progress Logical. Indicates whether to display the progress bar.
#' @returns A tibble object.
#'
#' @details
#' Available layers are:
#' \itemize{
#'   \item \bold{dist:} A 6-character ubigeo representing the administrative boundaries of a district.
#'   \item \bold{prov:} A 4-character ubigeo representing the administrative boundaries of a province.
#'   \item \bold{dep:} A 2-character ubigeo representing the administrative boundaries of a region.
#' }
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' geobosque <- get_forest_loss_data(ubigeo = "010101", level = "dist", show_progress = FALSE)
#' geobosque
#' }
#' @export

get_forest_loss_data <- \(level = NULL, ubigeo = NULL, show_progress = TRUE) {

  if(level == "dist"){
    url <- get_geobosque_link("dist")

  } else if (level == "prov") {
    url <- get_geobosque_link("prov")

  } else if (level == "dep") {
    url <- get_geobosque_link("dep")

  } else {
    stop("Invalid level. Please choose from 'dist', 'prov' or 'dep'")
  }

  if(level == "dist" && is.character(ubigeo) && length(ubigeo) == 1 && nchar(ubigeo) == 6){
    code <- ubigeo
  } else if(level == "prov" && is.character(ubigeo) && length(ubigeo) == 1 && nchar(ubigeo) == 4){
    code <- ubigeo
  } else if (level == "dep" && is.character(ubigeo) && length(ubigeo) == 1 && nchar(ubigeo) == 2) {
    code <- ubigeo
  } else {
    stop("Invalid ubigeo. Please choose an ubigeo acording to  administrative division level")
  }

  # Create request payload
  request <- list("ubigeo" = ubigeo)


  if(isTRUE(show_progress)){
    # Send POST request and process the response
    data_raw <- httr::POST(
      url = url,
      body = request,
      encode = "json",
      httr::progress()) |>
      httr::content(as = "text", encoding = "UTF-8")
  } else {
    # Send POST request and process the response
    data_raw <- httr::POST(
      url = url,
      body = request,
      encode = "json") |>
      httr::content(as = "text", encoding = "UTF-8")
  }

  # Remove UTF-8 BOM if present
  data_clean <- sub("\ufeff", "", data_raw)

  # data to tibble format
  tidydata <- data_clean |>
    jsonlite::fromJSON() |>
    tidyr::as_tibble()

  # Extract and clean data
  tidydata <- tidydata[["perdida_rangos"]]
  names(tidydata) <- gsub("_$", "", names(tidydata)) # Remove trailing underscores

  # Format the final data and return
  geobosque <- tidydata |>
    dplyr::mutate_if(is.character, as.numeric) |>
    dplyr::mutate(ubigeo = ubigeo)

  return(geobosque)
}
