#' Geobosque data (MINAM)
#'
#' @description
#' Forest stock / loss statistics (`get_forest_loss_data()`) and last-week
#' deforestation alerts (`get_early_warning()`) from the Geobosque platform:
#' \url{https://geobosques.minam.gob.pe}. The forest-loss endpoint is a `GET`
#' JSON API served by the current Geobosques backend
#' (\url{https://bosques-app.pe/geobosques/api-bosques}), so progress is
#' reported with a [cli][cli::cli_progress_step()] spinner.
#'
#' @name geobosque
NULL

#' Download the forest and loss information from Geobosque
#'
#' @description
#' Download the **ubigeos** corresponding to the official political division
#' of the district, province or region boundaries of Peru with **forest and loss information**.
#' For more information, visit \href{https://geobosques.minam.gob.pe}{Geobosque Platform}.
#'
#' @param layer A string. One of `stock_bosque_perdida_distrito`, `stock_bosque_perdida_provincia`, `stock_bosque_perdida_departamento`.
#' @param ubigeo A string. Ubigeo code: 6 digits (distrito), 4 digits (provincia), 2 digits (departamento).
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @returns A tibble object.
#' @details
#' Available layers:
#' \itemize{
#'   \item \bold{stock_bosque_perdida_distrito:} forest stock/loss for a district.
#'   \item \bold{stock_bosque_perdida_provincia:} forest stock/loss for a province.
#'   \item \bold{stock_bosque_perdida_departamento:} forest stock/loss for a region.
#' }
#' The data come from the wet-forest (`bosque humedo`) loss series of the
#' current Geobosques API (years 2001-2025) and are returned with the
#' historical column layout (`anio`, `perdida`, `rango1`-`rango5`, `ubigeo`).
#' @examples
#' \dontrun{
#' library(geoidep)
#' geobosque <- get_forest_loss_data(
#'   layer = "stock_bosque_perdida_distrito",
#'   ubigeo = "010101",
#'   show_progress = FALSE)
#' head(geobosque)
#' }
#' @export
get_forest_loss_data <- \(layer = NULL, ubigeo = NULL, show_progress = TRUE) {
  expected_nchar <- switch(layer,
    "stock_bosque_perdida_distrito" = 6L,
    "stock_bosque_perdida_provincia" = 4L,
    "stock_bosque_perdida_departamento" = 2L,
    cli::cli_abort(c(
      "Invalid {.arg layer}.",
      "i" = "Choose one of {.val stock_bosque_perdida_distrito}, {.val stock_bosque_perdida_provincia}, {.val stock_bosque_perdida_departamento}."
    ))
  )

  if (!is.character(ubigeo) || length(ubigeo) != 1L || nchar(ubigeo) != expected_nchar) {
    cli::cli_abort(c(
      "Invalid {.arg ubigeo} for layer {.val {layer}}.",
      "x" = "You supplied: {.val {ubigeo}}",
      "i" = "Expected a single string with {expected_nchar} digits."
    ))
  }

  url <- get_geobosque_link("wet_forest_list")

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Requesting Geobosque forest-loss statistics", spinner = TRUE)
  }

  data_raw <- tryCatch(
    httr2::request(url) |>
      httr2::req_url_query(ubigeoCode = ubigeo) |>
      httr2::req_timeout(60) |>
      httr2::req_retry(max_tries = 3, retry_on_failure = TRUE) |>
      httr2::req_perform() |>
      httr2::resp_body_string(),
    error = function(e) {
      cli::cli_abort(c(
        "Geobosque service request failed.",
        "x" = conditionMessage(e),
        "i" = "The Geobosque API may be temporarily unavailable. Try again later."
      ))
    }
  )

  data_clean <- sub("\ufeff", "", data_raw)

  geobosque <- data_clean |>
    jsonlite::fromJSON() |>
    tibble::as_tibble() |>
    dplyr::transmute(
      anio = as.integer(year),
      perdida = as.numeric(loss),
      rango1 = as.numeric(range1),
      rango2 = as.numeric(range2),
      rango3 = as.numeric(range3),
      rango4 = as.numeric(range4),
      rango5 = as.numeric(range5),
      ubigeo = ubigeo
    ) |>
    dplyr::arrange(anio)

  return(geobosque)
}

#' Download information on the latest deforestation alerts detected by Geobosque
#'
#' @description
#' Download deforestation alert information detected by Geobosque for any polygon in Peru.
#' For more details, visit \href{https://geobosques.minam.gob.pe}{Geobosque Platform}.
#'
#' @param region An sf object. Area of interest (must be EPSG:4326).
#' @param sf Logical. Return an `sf` object (`TRUE`) or a tibble (`FALSE`).
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @return A tibble or sf object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' loreto <- get_departaments(show_progress = FALSE) |> subset(nombdep == "LORETO")
#' warning_point <- get_early_warning(region = loreto, sf = TRUE, show_progress = FALSE)
#' head(warning_point)
#' }
#' @export
get_early_warning <- \(region, sf = TRUE, show_progress = TRUE) {
  url <- get_early_warning_link(type = "warning_last_week")

  if (sf::st_crs(region)$epsg != 4326) {
    cli::cli_abort("The layer must be in CRS: EPSG 4326 (WGS 84).")
  }

  coords_str <- sf::st_geometry(region) |>
    sf::st_cast("POINT") |>
    sf::st_coordinates() |>
    as.data.frame() |>
    dplyr::mutate(coords = paste(X, Y, sep = " ")) |>
    dplyr::summarise(all_coords = paste(coords, collapse = ", ")) |>
    dplyr::pull(all_coords)

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Requesting last-week deforestation alerts", spinner = TRUE)
  }

  data_raw <- tryCatch(
    httr2::request(url) |>
      httr2::req_body_json(list(coords = coords_str)) |>
      httr2::req_timeout(120) |>
      httr2::req_retry(max_tries = 3, retry_on_failure = TRUE) |>
      httr2::req_perform() |>
      httr2::resp_body_string(),
    error = function(e) {
      cli::cli_abort(c(
        "Geobosque service request failed.",
        "x" = conditionMessage(e),
        "i" = "The Geobosque API may be temporarily unavailable. Try again later."
      ))
    }
  )

  data_clean <- sub("\ufeff", "", data_raw)

  tidydata <- data_clean |>
    jsonlite::fromJSON() |>
    tidyr::as_tibble()

  tidydata <- tidydata[["datos"]]
  names(tidydata) <- gsub("_$", "", names(tidydata))

  if (length(unlist(tidydata)) == 0) {
    cli::cli_abort("No coordinate points corresponding to the latest deforestation alerts detected by {.strong Geobosques} have been found.")
  }

  geobosque <- tidydata |>
    as.data.frame() |>
    dplyr::mutate_if(is.character, as.numeric)

  data <- geobosque |>
    dplyr::rename_with(~ c("lng", "lat"), everything()) |>
    dplyr::mutate(
      lng = as.double(lng),
      lat = as.double(lat),
      descrip = "Warning points") |>
    tidyr::as_tibble()

  if (isTRUE(sf)) {
    data_output <- data |> sf::st_as_sf(coords = c("lng", "lat"), crs = 4326)
  } else {
    data_output <- data
  }

  return(data_output)
}
