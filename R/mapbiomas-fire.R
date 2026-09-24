#' Get available MapBiomas Peru Fire products
#'
#' @description
#' Returns a lookup table describing the MapBiomas Fuego (Fire) Peru
#' sub-products available for download, including their internal codes,
#' descriptions, and whether they are indexed by a single `year` or by
#' a `year range` (starting in 2013).
#'
#' @returns A tibble with columns `product`, `description_en`,
#' `description_es`, and `temporal` (`"annual"` or `"range"`).
#' @examples
#' library(geoidep)
#' get_mapbiomas_peru_fire_products()
#' @export
get_mapbiomas_peru_fire_products <- function() {
  tibble::tribble(
    ~product,                          ~description_en,                    ~description_es,                       ~temporal,
    "annual_burned",                   "Annual burned area",                "\u00c1rea quemada anual",                      "annual",
    "annual_burned_coverage",          "Annual burned area by land cover",  "\u00c1rea quemada anual por cobertura",         "annual",
    "monthly_burned",                  "Monthly burned area",               "\u00c1rea quemada mensual",                     "annual",
    "accumulated_burned",              "Accumulated burned area",           "\u00c1rea quemada acumulada",                    "range",
    "accumulated_burned_coverage",     "Accumulated burned area by cover",  "\u00c1rea quemada acumulada por cobertura",      "range",
    "frequency_burned",                "Burned area frequency",             "Frecuencia de \u00e1rea quemada",                "range",
    "annual_burned_scar_size_range",   "Annual burned scar size",           "Tama\u00f1o de cicatriz anual",                  "annual",
    "year_last_fire",                  "Year of last fire",                 "A\u00f1o del \u00faltimo fuego",                 "annual"
  )
}

#' Get the MapBiomas Peru Fire legend for a given product
#'
#' @description
#' Returns a lookup table with the pixel value codes, English/Spanish class
#' names, and hexadecimal colors used by a given MapBiomas Fuego Peru
#' sub-product (Collection 1). Useful for building color scales (see
#' \code{\link{scale_fill_mapbiomas_peru_fire_d}}).
#'
#' @param product Character. One of the products listed in
#' \code{\link{get_mapbiomas_peru_fire_products}}.
#' @returns A tibble with columns `id`, `class_en`, `class_es`, and `hex`.
#' @details
#' \itemize{
#'   \item `annual_burned` and `accumulated_burned`: binary classification (`1 = "Burned area"`).
#'   \item `annual_burned_coverage` and `accumulated_burned_coverage`: share the LULC legend.
#'   \item `monthly_burned`: values `1-12` = month of burning.
#'   \item `frequency_burned`: values `1-12` = burn count (`12` = "12 or more times").
#'   \item `year_last_fire`: values are years (`2013-2024`).
#'   \item `annual_burned_scar_size_range`: values `1-5` = scar size class.
#' }
#' @examples
#' library(geoidep)
#' get_mapbiomas_peru_fire_legend("frequency_burned")
#' @export
get_mapbiomas_peru_fire_legend <- function(product) {
  products <- get_mapbiomas_peru_fire_products()

  if (!product %in% products$product) {
    cli::cli_abort(c(
      "Invalid {.arg product} for MapBiomas Fuego Peru.",
      "x" = "You supplied: {.val {product}}",
      "i" = "Available products: {.val {products$product}}"
    ))
  }

  switch(product,

    annual_burned = ,
    accumulated_burned = tibble::tribble(
      ~id, ~class_en,     ~class_es,       ~hex,
      1,   "Burned area", "\u00c1rea quemada",  "#ff5340"
    ),

    annual_burned_coverage = ,
    accumulated_burned_coverage = get_mapbiomas_peru_legend(),

    monthly_burned = tibble::tribble(
      ~id, ~class_en,   ~class_es,   ~hex,
      1,  "January",    "Enero",     "#CC00FF",
      2,  "February",   "Febrero",   "#6600FF",
      3,  "March",      "Marzo",     "#0000FF",
      4,  "April",      "Abril",     "#00CCFF",
      5,  "May",        "Mayo",      "#00FFCC",
      6,  "June",       "Junio",     "#FFFF00",
      7,  "July",       "Julio",     "#FF9900",
      8,  "August",     "Agosto",    "#FF3300",
      9,  "September",  "Setiembre", "#CC0000",
      10, "October",    "Octubre",   "#00CC00",
      11, "November",   "Noviembre", "#009900",
      12, "December",   "Diciembre", "#66FF66"
    ),

    frequency_burned = tibble::tribble(
      ~id, ~class_en,           ~class_es,                  ~hex,
      1,  "Burned once",        "Quemado 1 vez",        "#FAF3CD",
      2,  "Burned twice",       "Quemado 2 veces",      "#F9E676",
      3,  "Burned 3 times",     "Quemado 3 veces",      "#F1CD38",
      4,  "Burned 4 times",     "Quemado 4 veces",      "#DDA71C",
      5,  "Burned 5 times",     "Quemado 5 veces",      "#C77E14",
      6,  "Burned 6 times",     "Quemado 6 veces",      "#B0540F",
      7,  "Burned 7 times",     "Quemado 7 veces",      "#992A0A",
      8,  "Burned 8 times",     "Quemado 8 veces",      "#7B1208",
      9,  "Burned 9 times",     "Quemado 9 veces",      "#5C0407",
      10, "Burned 10 times",    "Quemado 10 veces",     "#440508",
      11, "Burned 11 times",    "Quemado 11 veces",     "#260405",
      12, "Burned 12+ times",   "Quemado 12+ veces",    "#040101"
    ),

    year_last_fire = tibble::tribble(
      ~id,   ~class_en, ~class_es, ~hex,
      2013, "2013",     "2013",    "#010079",
      2014, "2014",     "2014",    "#00287F",
      2015, "2015",     "2015",    "#004D86",
      2016, "2016",     "2016",    "#07728F",
      2017, "2017",     "2017",    "#239B9C",
      2018, "2018",     "2018",    "#74B29A",
      2019, "2019",     "2019",    "#AD9963",
      2020, "2020",     "2020",    "#C25407",
      2021, "2021",     "2021",    "#AF2A13",
      2022, "2022",     "2022",    "#A01D1A",
      2023, "2023",     "2023",    "#911416",
      2024, "2024",     "2024",    "#810000"
    ),

    annual_burned_scar_size_range = tibble::tribble(
      ~id, ~class_en,      ~class_es,       ~hex,
      1,  "< 25 ha",       "< 25 ha",       "#D9B646",
      2,  "25 - 50 ha",    "25 - 50 ha",    "#E58B2F",
      3,  "50 - 500 ha",   "50 - 500 ha",   "#D46B27",
      4,  "500 - 5000 ha", "500 - 5000 ha", "#96352A",
      5,  "> 5000 ha",     "> 5000 ha",     "#2B110C"
    ),

    cli::cli_abort(c(
      "No legend is defined for product {.val {product}}.",
      "i" = "Available products: {.val {products$product}}"
    ))
  )
}

#' Get a MapBiomas Peru Fire raster
#'
#' @description
#' Lazily reads a MapBiomas Fuego (Fire) Peru raster from a given
#' sub-product, hosted as a GeoTIFF on Google Cloud Storage. Only the bytes
#' required for the requested extent are downloaded (via GDAL's
#' `/vsicurl/` driver). Optionally crops and masks the raster to an
#' area of interest.
#'
#' @param product Character. One of the products listed in
#' `get_mapbiomas_peru_fire_products`, e.g. `"annual_burned"`.
#' @param year Integer. For `"annual"` products, the map year (from `1999`). For `"range"`
#' products (`accumulated_*`, `frequency_burned`), the **end year** (from `2014`, range starts 2013).
#' @param crop_to Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent`. If `NULL`, the full raster is returned.
#' @param collection Integer. MapBiomas Fuego Peru collection. Default `1` (only one available).
#' @returns A `SpatRaster` with one layer.
#' @examples
#' \dontrun{
#' library(geoidep)
#' lima <- get_departaments("LIMA")
#' burned_2024 <- get_mapbiomas_peru_fire(product = "annual_burned", year = 2024, crop_to = lima)
#' }
#' @export
get_mapbiomas_peru_fire <- \(product, year, crop_to = NULL, collection = 1) {
  products <- get_mapbiomas_peru_fire_products()

  if (!product %in% products$product) {
    cli::cli_abort(c(
      "Invalid {.arg product} for MapBiomas Fuego Peru.",
      "x" = "You supplied: {.val {product}}",
      "i" = "Available products: {.val {products$product}}"
    ))
  }

  if (collection != 1) {
    cli::cli_abort(c(
      "Invalid {.arg collection} for MapBiomas Fuego Peru.",
      "x" = "You supplied: {.val {collection}}",
      "i" = "Currently only collection {.val 1} is available."
    ))
  }

  temporal <- products$temporal[products$product == product]

  file_map <- list(
    annual_burned                 = list(folder = "mbfire_col1_peru_annual_burned",                suffix = "burned_area"),
    annual_burned_coverage        = list(folder = "mbfire_col1_peru_annual_burned_coverage",       suffix = "burned_coverage"),
    monthly_burned                = list(folder = "mbfire_col1_peru_monthly_burned",               suffix = "burned_monthly"),
    accumulated_burned            = list(folder = "mbfire_col1_peru_accumulated_burned",           suffix = "fire_accumulated"),
    accumulated_burned_coverage   = list(folder = "mbfire_col1_peru_accumulated_burned_coverage",  suffix = "fire_accumulated"),
    frequency_burned              = list(folder = "mbfire_col1_peru_frequency_burned",             suffix = "fire_frequency"),
    annual_burned_scar_size_range = list(folder = "mbfire_col1_peru_annual_burned_scar_size_range", suffix = "scar_area_ha"),
    year_last_fire                = list(folder = "mbfire_col1_peru_year_last_fire",                suffix = "classification")
  )

  folder <- file_map[[product]]$folder
  suffix <- file_map[[product]]$suffix

  base_url <- sprintf(
    "https://storage.googleapis.com/shared-development-storage/COLLECTIONS/PERU/FIRE/COLLECTION%d/%s/%s-%s",
    collection, folder, folder, suffix
  )

  if (temporal == "range") {
    if (year < 2014) {
      cli::cli_abort(c(
        "Invalid {.arg year} for product {.val {product}}.",
        "x" = "You supplied: {.val {year}}",
        "i" = "{.val {product}} requires an end year of {.val 2014} or later (range starts in 2013)."
      ))
    }
    url <- sprintf("%s_2013_%d.tif", base_url, year)
  } else {
    if (year < 1999) {
      cli::cli_abort(c(
        "Invalid {.arg year} for product {.val {product}}.",
        "x" = "You supplied: {.val {year}}",
        "i" = "Annual products are available from {.val 1999}."
      ))
    }
    url <- sprintf("%s_%d.tif", base_url, year)
  }

  resp <- tryCatch(
    httr2::request(url) |>
      httr2::req_method("HEAD") |>
      httr2::req_timeout(60) |>
      httr2::req_options(ssl_verifypeer = FALSE) |>
      httr2::req_perform(),
    error = function(e) {
      cli::cli_abort(c(
        "MapBiomas Fuego Peru service request failed.",
        "x" = conditionMessage(e),
        "i" = "The service may be temporarily unavailable. Try again later."
      ))
    }
  )

  if (httr2::resp_status(resp) != 200) {
    cli::cli_abort(c(
      "MapBiomas Fuego Peru raster not found.",
      "x" = "URL: {.url {url}}",
      "i" = "Check that the combination of {.arg product} and {.arg year} is valid."
    ))
  }

  r <- terra::rast(paste0("/vsicurl/", url)) |>
    terra::as.factor()

  if (!is.null(crop_to)) {
    if (inherits(crop_to, c("sf", "sfc"))) {
      crop_to <- terra::vect(sf::st_transform(crop_to, terra::crs(r)))
    }
    r <- terra::crop(r, crop_to, mask = TRUE)
  }

  names(r) <- if (temporal == "range") {
    sprintf("%s_2013_%d", product, year)
  } else {
    sprintf("%s_%d", product, year)
  }

  r
}

#' Discrete fill scale for MapBiomas Peru Fire products
#'
#' @description
#' A `ggplot2` discrete fill scale that applies the official
#' MapBiomas Fuego Peru (Collection 1) color palette for a given sub-product
#' to a classified `SpatRaster` (as a factor), for use with
#' `tidyterra::geom_spatraster()`.
#'
#' @param product Character. One of the products listed in
#' \code{\link{get_mapbiomas_peru_fire_products}}.
#' @param lang Character. Legend language, either `"en"` (default) or `"es"`.
#' @param na.translate Logical. Should `NA` values be displayed in the legend? Default `FALSE`.
#' @param ... Additional arguments passed to \code{\link[ggplot2]{scale_fill_manual}}.
#' @returns A `ggplot2` discrete scale object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' library(ggplot2)
#' library(tidyterra)
#' lima <- get_departaments("LIMA", show_progress = FALSE)
#' freq <- get_mapbiomas_peru_fire(product = "frequency_burned", year = 2024, crop_to = lima)
#' ggplot() +
#'   geom_spatraster(data = as.factor(freq)) +
#'   scale_fill_mapbiomas_peru_fire_d("frequency_burned", lang = "es") +
#'   theme_minimal()
#' }
#' @export
scale_fill_mapbiomas_peru_fire_d <- function(product, ..., lang = c("en", "es"), na.translate = FALSE) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    cli::cli_abort(c(
      "Package {.pkg ggplot2} is required for this scale.",
      "i" = "Install it with {.code install.packages(\"ggplot2\")}"
    ))
  }
  lang <- match.arg(lang)
  label_col <- if (lang == "en") "class_en" else "class_es"

  legend <- get_mapbiomas_peru_fire_legend(product)

  pal  <- stats::setNames(legend$hex, legend$id)
  lbls <- stats::setNames(legend[[label_col]], legend$id)

  ggplot2::scale_fill_manual(
    values = pal,
    labels = function(x) lbls[as.character(x)],
    na.translate = na.translate,
    ...
  )
}
