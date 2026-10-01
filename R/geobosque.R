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
  valid_layers <- c("stock_bosque_perdida_distrito",
                    "stock_bosque_perdida_provincia",
                    "stock_bosque_perdida_departamento")
  if (is.null(layer) || length(layer) != 1L || !layer %in% valid_layers) {
    cli::cli_abort(c(
      "Invalid {.arg layer}.",
      "i" = "Choose one of {.val stock_bosque_perdida_distrito}, {.val stock_bosque_perdida_provincia}, {.val stock_bosque_perdida_departamento}."
    ))
  }

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
#' The points come from the official vector service
#' `alertas_tempranas_pt_2026` (interop layer "Ultima semana") published at
#' \href{https://geobosques.minam.gob.pe/geobosque/view/servicios.php}{Geobosque Interoperability}.
#' For more details, visit \href{https://geobosques.minam.gob.pe}{Geobosque Platform}.
#'
#' @param region An sf object. Area of interest (must be EPSG:4326).
#' @param sf Logical. Return an `sf` object (`TRUE`) or a tibble (`FALSE`).
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @return A tibble or sf object with the alert points (`lng`, `lat`,
#'   `fecha_alerta`, `dia_jul`, `mes_alerta`, `ubigeo`).
#' @examples
#' \dontrun{
#' library(geoidep)
#' loreto <- get_departaments(show_progress = FALSE) |> subset(nombdep == "LORETO")
#' warning_point <- get_early_warning(region = loreto, sf = TRUE, show_progress = FALSE)
#' head(warning_point)
#' }
#' @export
get_early_warning <- \(region, sf = TRUE, show_progress = TRUE) {
  base_url <- get_early_warning_link(type = "alertas_pt_2026")

  if (!inherits(region, "sf")) {
    cli::cli_abort(c(
      "Invalid {.arg region}.",
      "x" = "Expected an {.cls sf} object."
    ))
  }

  if (sf::st_crs(region)$epsg != 4326) {
    cli::cli_abort("The layer must be in CRS: EPSG 4326 (WGS 84).")
  }

  bbox <- sf::st_bbox(region)
  envelope <- paste(
    format(as.numeric(bbox[["xmin"]]), scientific = FALSE),
    format(as.numeric(bbox[["ymin"]]), scientific = FALSE),
    format(as.numeric(bbox[["xmax"]]), scientific = FALSE),
    format(as.numeric(bbox[["ymax"]]), scientific = FALSE),
    sep = ","
  )

  query_base <- list(
    where = "1=1",
    geometry = envelope,
    geometryType = "esriGeometryEnvelope",
    inSR = "4326",
    spatialRel = "esriSpatialRelIntersects",
    outFields = "*",
    returnGeometry = "true",
    outSR = "4326",
    f = "geojson"
  )

  build_req <- function(query) {
    req <- httr2::request(paste0(base_url, "/0/query")) |>
      httr2::req_timeout(120) |>
      httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)
    req <- do.call(httr2::req_url_query, c(list(req), query))
    if (isTRUE(show_progress)) {
      req <- req |> httr2::req_progress()
    }
    req
  }

  count_query <- query_base
  count_query$f <- "pjson"
  count_query$returnCountOnly <- "true"

  count_text <- tryCatch(
    httr2::req_perform(build_req(count_query)) |>
      httr2::resp_body_string(),
    error = function(e) {
      cli::cli_abort(c(
        "Geobosque service request failed.",
        "x" = conditionMessage(e),
        "i" = "The Geobosque API may be temporarily unavailable. Try again later."
      ))
    }
  )
  total <- suppressWarnings(as.integer(jsonlite::fromJSON(count_text)$count))
  if (is.null(total) || length(total) == 0L || is.na(total)) total <- 0L

  page_size <- 2000L
  pages <- list()
  if (total > 0L) {
    offsets <- seq(0L, by = page_size, length.out = ceiling(total / page_size))
    if (isTRUE(show_progress)) {
      cli::cli_progress_bar("Downloading alert points", total = length(offsets))
    }
    for (i in seq_along(offsets)) {
      page_query <- c(query_base, list(resultOffset = offsets[i],
                                       resultRecordCount = page_size))
      page_text <- tryCatch(
        httr2::req_perform(build_req(page_query)) |>
          httr2::resp_body_string(),
        error = function(e) {
          cli::cli_abort(c(
            "Geobosque service request failed.",
            "x" = conditionMessage(e),
            "i" = "The Geobosque API may be temporarily unavailable. Try again later."
          ))
        }
      )
      pages[[i]] <- sf::st_read(page_text, quiet = TRUE,
                                stringsAsFactors = FALSE)
      if (isTRUE(show_progress)) cli::cli_progress_update()
    }
    if (isTRUE(show_progress)) cli::cli_progress_done()
  }

  if (length(pages) == 0L) {
    cli::cli_abort("No coordinate points corresponding to the latest deforestation alerts detected by {.strong Geobosques} have been found.")
  }

  alerts <- do.call(rbind, pages) |>
    sf::st_transform(crs = 4326) |>
    sf::st_make_valid()

  inside <- sf::st_intersects(
    alerts,
    sf::st_union(sf::st_geometry(region)),
    sparse = FALSE
  )[, 1]
  alerts <- alerts[inside, , drop = FALSE]

  if (nrow(alerts) == 0L) {
    cli::cli_abort("No coordinate points corresponding to the latest deforestation alerts detected by {.strong Geobosques} have been found.")
  }

  coords <- sf::st_coordinates(alerts)
  data <- alerts |>
    sf::st_drop_geometry() |>
    dplyr::transmute(
      lng = as.double(coords[, 1]),
      lat = as.double(coords[, 2]),
      fecha_alerta = as.Date(as.POSIXct(fe_alerta / 1000,
                                        origin = "1970-01-01", tz = "UTC")),
      dia_jul = as.integer(dia_jul),
      mes_alerta = as.integer(mes_alerta),
      ubigeo = as.character(ubigeo),
      descrip = "Warning points"
    ) |>
    tibble::as_tibble()

  if (isTRUE(sf)) {
    data_output <- data |> sf::st_as_sf(coords = c("lng", "lat"), crs = 4326)
  } else {
    data_output <- data
  }

  return(data_output)
}
