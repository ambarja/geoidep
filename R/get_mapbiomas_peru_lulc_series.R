#' Get a multi-year stack of MapBiomas Peru LULC rasters
#'
#' @description
#' Downloads and stacks multiple single-year LULC rasters from MapBiomas
#' Peru (see \code{\link{get_mapbiomas_peru_lulc}}), each cropped to the same
#' area of interest if provided.
#'
#' @param years Integer vector. Years to download (e.g. \code{2018:2024}).
#' @param crop_to Optional. An \code{sf}/\code{sfc} object, \code{SpatVector},
#' or \code{SpatExtent} defining the area of interest. If \code{NULL}
#' (default), each raster is returned at full extent.
#' @param collection Integer. MapBiomas Peru collection number. Default is \code{3}.
#'
#' @returns A \code{SpatRaster} with one layer per year, named \code{classification_<year>}.
#'
#' @examples
#' \dontrun{
#' library(geoidep)
#'
#' lima <- get_departaments("LIMA",show_progress = FALSE)
#' lulc_series <- get_mapbiomas_peru_lulc_series(years = 2020:2024, crop_to = lima)
#' lulc_series
#' #> class       : SpatRaster
#' #> dimensions  : 4521, 5103, 5  (nrow, ncol, nlyr)
#' #> names       : classification_2020, classification_2021, ..., classification_2024
#' }
#' @export
get_mapbiomas_peru_lulc_series <- \(years, crop_to = NULL, collection = 3) {

  if (!is.numeric(years) || length(years) == 0) {
    cli::cli_abort(c(
      "Invalid {.arg years}.",
      "x" = "You supplied: {.val {years}}",
      "i" = "{.arg years} must be a non-empty numeric vector (e.g. {.code 2018:2024})."
    ))
  }

  rasters <- lapply(years, get_mapbiomas_peru_lulc, crop_to = crop_to, collection = collection)
  terra::rast(rasters)
}
