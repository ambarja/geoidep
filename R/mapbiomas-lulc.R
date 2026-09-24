#' Get MapBiomas Peru land use / land cover raster
#'
#' @description
#' Lazily reads a single-year Land Use and Land Cover (LULC) classification
#' raster from the MapBiomas Peru collection. Only the bytes required for the
#' requested extent are downloaded (via GDAL's `/vsicurl/` driver).
#' Optionally crops and masks the raster to an area of interest.
#'
#' @param year Integer. Year of the classification (e.g. `2024`).
#' @param crop_to Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent`. If `NULL`, the full raster for Peru is returned.
#' @param collection Integer. MapBiomas Peru collection number (`1`, `2`, `3`, `4`). Default `3`.
#' @returns A `SpatRaster` with one layer named `classification_<year>`.
#' @examples
#' \dontrun{
#' library(geoidep)
#' lima <- get_departaments("LIMA", show_progress = FALSE)
#' lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
#' lulc_2024
#' lulc_2025 <- get_mapbiomas_peru_lulc(year = 2025, collection = 4, crop_to = lima)
#' lulc_2025
#' }
#' @export
get_mapbiomas_peru_lulc <- \(year, crop_to = NULL, collection = 4) {
  valid_collections <- 1:4

  if (!collection %in% valid_collections) {
    cli::cli_abort(c(
      "Invalid {.arg collection} for MapBiomas Peru.",
      "x" = "You supplied: {.val {collection}}",
      "i" = "Available collections: {.val {valid_collections}}"
    ))
  }

  url <- if (collection == 4) {
    sprintf(
      "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/collection4/lulc/coverage/peru_coverage/peru_coverage-col4_%d.tif",
      year
    )
  } else {
    sprintf(
      "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/collection_%d/LULC/peru_collection%d_integration_v1-classification_%d.tif",
      collection, collection, year
    )
  }

  resp <- tryCatch(
    httr2::request(url) |>
      httr2::req_method("HEAD") |>
      httr2::req_timeout(60) |>
      httr2::req_options(ssl_verifypeer = FALSE) |>
      httr2::req_perform(),
    error = function(e) {
      cli::cli_abort(c(
        "MapBiomas Peru service request failed.",
        "x" = conditionMessage(e),
        "i" = "The service may be temporarily unavailable. Try again later."
      ))
    }
  )

  if (httr2::resp_status(resp) != 200) {
    cli::cli_abort(c(
      "MapBiomas Peru raster not found for year {.val {year}}.",
      "x" = "URL: {.url {url}}"
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

  names(r) <- paste0("classification_", year)
  r
}

#' Get a multi-year stack of MapBiomas Peru LULC rasters
#'
#' @description
#' Downloads and stacks multiple single-year LULC rasters from MapBiomas
#' Peru (see \code{\link{get_mapbiomas_peru_lulc}}), each cropped to the same
#' area of interest if provided. Progress uses [cli][cli::cli_progress_bar()].
#'
#' @param years Integer vector. Years to download (e.g. `2018:2024`).
#' @param crop_to Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent`. If `NULL`, each raster is returned at full extent.
#' @param collection Integer. MapBiomas Peru collection number (`1`, `2`, `3`, `4`). Default `3`.
#' @param show_progress Logical. Show a cli progress bar. Default `TRUE`.
#' @returns A `SpatRaster` with one layer per year, named `classification_<year>`.
#' @examples
#' \dontrun{
#' library(geoidep)
#' lima <- get_departaments("LIMA", show_progress = FALSE)
#' lulc_series <- get_mapbiomas_peru_lulc_series(years = 2020:2024, crop_to = lima)
#' lulc_series
#' }
#' @export
get_mapbiomas_peru_lulc_series <- \(years, crop_to = NULL, collection = 4, show_progress = TRUE) {
  if (!is.numeric(years) || length(years) == 0) {
    cli::cli_abort(c(
      "Invalid {.arg years}.",
      "x" = "You supplied: {.val {years}}",
      "i" = "{.arg years} must be a non-empty numeric vector (e.g. {.code 2018:2024})."
    ))
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_bar("Downloading LULC rasters", total = length(years))
  }
  rasters <- lapply(years, function(yr) {
    r <- get_mapbiomas_peru_lulc(yr, crop_to = crop_to, collection = collection)
    if (isTRUE(show_progress)) cli::cli_progress_update()
    r
  })
  if (isTRUE(show_progress)) cli::cli_progress_done()

  terra::rast(rasters)
}

#' Discrete fill scale for MapBiomas Peru LULC classes
#'
#' @description
#' A `ggplot2` discrete fill scale that applies the official MapBiomas
#' Peru Collection 3 color palette to a classified `SpatRaster` (as a
#' factor), for use with `tidyterra::geom_spatraster()`.
#'
#' @param lang Character. Legend language, either `"en"` (default) or `"es"`.
#' @param na.translate Logical. Should `NA` values be displayed in the legend? Default `FALSE`.
#' @param ... Additional arguments passed to \code{\link[ggplot2]{scale_fill_manual}}.
#' @returns A `ggplot2` discrete scale object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' library(ggplot2)
#' library(tidyterra)
#' lima <- get_departaments("LIMA")
#' lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
#' ggplot() +
#'   geom_spatraster(data = as.factor(lulc_2024)) +
#'   scale_fill_mapbiomas_peru_lulc_d(lang = "es") +
#'   theme_minimal() +
#'   labs(fill = "Cobertura/Uso", title = "MapBiomas Peru 2024")
#' }
#' @export
scale_fill_mapbiomas_peru_lulc_d <- function(..., lang = c("en", "es"), na.translate = FALSE) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    cli::cli_abort(c(
      "Package {.pkg ggplot2} is required for this scale.",
      "i" = "Install it with {.code install.packages(\"ggplot2\")}"
    ))
  }
  lang <- match.arg(lang)
  label_col <- if (lang == "en") "class_en" else "class_es"

  legend <- get_mapbiomas_peru_legend()

  pal  <- stats::setNames(legend$hex, legend$id)
  lbls <- stats::setNames(legend[[label_col]], legend$id)

  ggplot2::scale_fill_manual(
    values = pal,
    labels = function(x) lbls[as.character(x)],
    na.translate = na.translate,
    ...
  )
}
