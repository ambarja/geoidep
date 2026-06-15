#' Get MapBiomas Peru land use / land cover raster
#'
#' @description
#' Lazily reads a single-year Land Use and Land Cover (LULC) classification
#' raster from the MapBiomas Peru collection, hosted as a Cloud Optimized
#' GeoTIFF (COG) on Google Cloud Storage. Only the bytes required for the
#' requested extent are downloaded (via GDAL's \code{/vsicurl/} driver).
#' Optionally crops and masks the raster to an area of interest.
#'
#' @param year Integer. Year of the classification (e.g. \code{2024}).
#' @param crop_to Optional. An \code{sf}/\code{sfc} object, \code{SpatVector},
#' or \code{SpatExtent} defining the area of interest. If \code{NULL}
#' (default), the full raster for Peru is returned.
#' @param collection Integer. MapBiomas Peru collection number. Currently
#' available collections are \code{1}, \code{2}, and \code{3}. Default is \code{3}
#' (the latest).
#'
#' @returns A \code{SpatRaster} with one layer named \code{classification_<year>}.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#'
#' # Download departmental boundaries
#' lima <- get_departaments("LIMA")
#'
#' # Download and crop MapBiomas Peru LULC for 2024
#' lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
#' lulc_2024
#' #> class       : SpatRaster
#' #> dimensions  : 4521, 5103, 1  (nrow, ncol, nlyr)
#' #> resolution  : 0.00025, 0.00025  (x, y)
#' #> extent      : -77.45, -75.7, -13.5, -10.4  (xmin, xmax, ymin, ymax)
#' #> coord. ref. : lon/lat WGS 84
#' #> source      : peru_collection3_integration_v1-classification_2024.tif
#' #> name        : classification_2024
#' }
#' @export
get_mapbiomas_peru_lulc <- \(year, crop_to = NULL, collection = 3) {

  valid_collections <- 1:3

  if (!collection %in% valid_collections) {
    cli::cli_abort(c(
      "Invalid {.arg collection} for MapBiomas Peru.",
      "x" = "You supplied: {.val {collection}}",
      "i" = "Available collections: {.val {valid_collections}}"
    ))
  }

  url <- sprintf(
    "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/collection_%d/LULC/peru_collection%d_integration_v1-classification_%d.tif",
    collection, collection, year
  )

  resp <- httr2::request(url) |>
    httr2::req_method("HEAD") |>
    httr2::req_perform()

  if (httr2::resp_status(resp) != 200) {
    cli::cli_abort(c(
      "MapBiomas Peru raster not found for year {.val {year}}.",
      "x" = "URL: {.url {url}}"
    ))
  }

  r <- terra::rast(paste0("/vsicurl/", url))

  if (!is.null(crop_to)) {
    if (inherits(crop_to, c("sf", "sfc"))) {
      crop_to <- terra::vect(sf::st_transform(crop_to, terra::crs(r)))
    }
    r <- terra::crop(r, crop_to, mask = TRUE)
  }

  names(r) <- paste0("classification_", year)
  r
}
