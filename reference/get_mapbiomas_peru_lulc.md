# Get MapBiomas Peru land use / land cover raster

Lazily reads a single-year Land Use and Land Cover (LULC) classification
raster from the MapBiomas Peru collection, hosted as a Cloud Optimized
GeoTIFF (COG) on Google Cloud Storage. Only the bytes required for the
requested extent are downloaded (via GDAL's `/vsicurl/` driver).
Optionally crops and masks the raster to an area of interest.

## Usage

``` r
get_mapbiomas_peru_lulc(year, crop_to = NULL, collection = 3)
```

## Arguments

- year:

  Integer. Year of the classification (e.g. `2024`).

- crop_to:

  Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent` defining
  the area of interest. If `NULL` (default), the full raster for Peru is
  returned.

- collection:

  Integer. MapBiomas Peru collection number. Currently available
  collections are `1`, `2`, and `3`. Default is `3` (the latest).

## Value

A `SpatRaster` with one layer named `classification_<year>`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)

# Download departmental boundaries
lima <- get_departaments("LIMA", show_progress = FALSE)

# Download and crop MapBiomas Peru LULC for 2024
lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
lulc_2024
#> class       : SpatRaster
#> dimensions  : 4521, 5103, 1  (nrow, ncol, nlyr)
#> resolution  : 0.00025, 0.00025  (x, y)
#> extent      : -77.45, -75.7, -13.5, -10.4  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84
#> source      : peru_collection3_integration_v1-classification_2024.tif
#> name        : classification_2024
} # }
```
