# Get MapBiomas Peru land use / land cover raster

Lazily reads a single-year Land Use and Land Cover (LULC) classification
raster from the MapBiomas Peru collection. Only the bytes required for
the requested extent are downloaded (via GDAL's `/vsicurl/` driver).
Optionally crops and masks the raster to an area of interest.

## Usage

``` r
get_mapbiomas_peru_lulc(year, crop_to = NULL, collection = 4)
```

## Arguments

- year:

  Integer. Year of the classification (e.g. `2024`).

- crop_to:

  Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent`. If
  `NULL`, the full raster for Peru is returned.

- collection:

  Integer. MapBiomas Peru collection number (`1`, `2`, `3`, `4`).
  Default `3`.

## Value

A `SpatRaster` with one layer named `classification_<year>`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
lima <- get_departaments("LIMA", show_progress = FALSE)
lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
lulc_2024
lulc_2025 <- get_mapbiomas_peru_lulc(year = 2025, collection = 4, crop_to = lima)
lulc_2025
} # }
```
