#' Download the forest and loss information from Geobosque
#'
#' @description
#' This function allows you to download the \bold{ubigeos} corresponding to the official political division
#' of the district, province or region boundaries of Peru with \bold{forest and loss information}.
#' For more information, you can visit the following website: \url{https://geobosques.minam.gob.pe}
#'
#' @param layer A string.Specifies one of the following available layers; stock_bosque_perdida_distrito, stock_bosque_perdida_provincia, stock_bosque_perdida_departamento.
#' @param ubigeo A string Specifies the unique geographical code of interest.
#' @param show_progress Logical. Indicates whether to display the progress bar.
#' @returns A tibble object.
#'
#' @details
#' Available layers are:
#' \itemize{
#'   \item \bold{stock_bosque_perdida_distrito:} Returns data on forest stock, forest loss, rank loss for a given district.
#'   \item \bold{stock_bosque_perdida_provincia:} Returns data on forest stock, forest loss, rank loss for a given province.
#'   \item \bold{stock_bosque_perdida_departamento:} Returns data on forest stock, forest loss, rank loss for a given region.
#' }
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' geobosque <- get_forest_loss_data(
#'     layer = "stock_bosque_perdida_distrito",
#'     ubigeo = "010101",
#'     show_progress = FALSE)
#' head(geobosque)
#' }
#' @export

get_forest_loss_data <- \(layer = NULL, ubigeo = NULL, show_progress = TRUE) {

  if(layer == "stock_bosque_perdida_distrito"){
    url <- get_geobosque_link("stock_bosque_perdida_distrito")

  } else if (layer == "stock_bosque_perdida_provincia") {
    url <- get_geobosque_link("stock_bosque_perdida_provincia")

  } else if (layer == "stock_bosque_perdida_departamento") {
    url <- get_geobosque_link("stock_bosque_perdida_departamento")

  } else {
    stop("Invalid level. Please choose from 'dist', 'prov' or 'dep'")
  }

  if(layer == "stock_bosque_perdida_distrito" && is.character(ubigeo) && length(ubigeo) == 1 && nchar(ubigeo) == 6){
    code <- ubigeo
  } else if(layer == "stock_bosque_perdida_provincia" && is.character(ubigeo) && length(ubigeo) == 1 && nchar(ubigeo) == 4){
    code <- ubigeo
  } else if (layer == "stock_bosque_perdida_departamento" && is.character(ubigeo) && length(ubigeo) == 1 && nchar(ubigeo) == 2) {
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
