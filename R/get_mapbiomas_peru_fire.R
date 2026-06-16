#' Get available MapBiomas Peru Fire products
#'
#' @description
#' Returns a lookup table describing the MapBiomas Fuego (Fire) Peru
#' sub-products available for download, including their internal codes,
#' descriptions, and whether they are indexed by a single \code{year} or by
#' a \code{year range} (starting in 2013).
#'
#' @returns A tibble with columns \code{product}, \code{description_en},
#' \code{description_es}, and \code{temporal} (\code{"annual"} or \code{"range"}).
#'
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

#' Get a MapBiomas Peru Fire raster
#'
#' @description
#' Lazily reads a MapBiomas Fuego (Fire) Peru raster from a given
#' sub-product, hosted as a GeoTIFF on Google Cloud Storage. Only the bytes
#' required for the requested extent are downloaded (via GDAL's
#' \code{/vsicurl/} driver). Optionally crops and masks the raster to an
#' area of interest.
#'
#' @param product Character. One of the products listed in
#' \code{get_mapbiomas_peru_fire_products}, e.g. \code{"annual_burned"},
#' \code{"year_last_fire"}, \code{"frequency_burned"}.
#' @param year Integer. For \code{"annual"} products (see
#' \code{\link{get_mapbiomas_peru_fire_products}}), the year of the map
#' (available from \code{1999}). For \code{"range"} products
#' (\code{accumulated_*}, \code{frequency_burned}), the **end year** of the
#' accumulated period, which always starts in \code{2013}.
#' @param crop_to Optional. An \code{sf}/\code{sfc} object, \code{SpatVector},
#' or \code{SpatExtent} defining the area of interest. If \code{NULL}
#' (default), the full raster for Peru is returned.
#' @param collection Integer. MapBiomas Fuego Peru collection number.
#' Default is \code{1} (currently the only collection available).
#'
#' @returns A \code{SpatRaster} with one layer.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#'
#' lima <- get_departaments("LIMA")
#'
#' # Annual burned area for 2024, cropped to Lima
#' burned_2024 <- get_mapbiomas_peru_fire(
#'   product = "annual_burned",
#'   year = 2024,
#'   crop_to = lima
#' )
#'
#' # Accumulated burned area 2013-2024
#' accumulated <- get_mapbiomas_peru_fire(
#'   product = "accumulated_burned",
#'   year = 2024,
#'   crop_to = lima
#' )
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

  # Mapeo producto -> carpeta y sufijo del archivo en el bucket
  file_map <- list(
    annual_burned                 = list(folder = "mbfire_col1_peru_annual_burned",                suffix = "burned_area"),
    annual_burned_coverage        = list(folder = "mbfire_col1_peru_annual_burned_coverage",       suffix = "burned_coverage"),
    monthly_burned                = list(folder = "mbfire_col1_peru_monthly_burned",               suffix = "burned_monthly"),
    accumulated_burned            = list(folder = "mbfire_col1_peru_accumulated_burned",           suffix = "fire_accumulated"),
    accumulated_burned_coverage   = list(folder = "mbfire_col1_peru_accumulated_burned_coverage",  suffix = "fire_accumulated"),
    frequency_burned               = list(folder = "mbfire_col1_peru_frequency_burned",             suffix = "fire_frequency"),
    annual_burned_scar_size_range = list(folder = "mbfire_col1_peru_annual_burned_scar_size_range", suffix = "scar_area_ha"),
    year_last_fire                 = list(folder = "mbfire_col1_peru_year_last_fire",                suffix = "classification")
  )

  folder <- file_map[[product]]$folder
  suffix <- file_map[[product]]$suffix

  base_url <- sprintf(
    "https://storage.googleapis.com/shared-development-storage/COLLECTIONS/PERU/FIRE/COLLECTION%d/%s/%s-%s",
    collection, folder, folder, suffix
  )

  if (temporal == "range") {
    # Productos acumulados/frecuencia: rango fijo desde 2013 hasta `year`
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

  resp <- httr2::request(url) |>
    httr2::req_method("HEAD") |>
    httr2::req_perform()

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
