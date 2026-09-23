# Get a MapBiomas Peru Fire raster

Lazily reads a MapBiomas Fuego (Fire) Peru raster from a given
sub-product, hosted as a GeoTIFF on Google Cloud Storage. Only the bytes
required for the requested extent are downloaded (via GDAL's `/vsicurl/`
driver). Optionally crops and masks the raster to an area of interest.

## Usage

``` r
get_mapbiomas_peru_fire(product, year, crop_to = NULL, collection = 1)
```

## Arguments

- product:

  Character. One of the products listed in
  `get_mapbiomas_peru_fire_products`, e.g. `"annual_burned"`.

- year:

  Integer. For `"annual"` products, the map year (from `1999`). For
  `"range"` products (`accumulated_*`, `frequency_burned`), the **end
  year** (from `2014`, range starts 2013).

- crop_to:

  Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent`. If
  `NULL`, the full raster is returned.

- collection:

  Integer. MapBiomas Fuego Peru collection. Default `1` (only one
  available).

## Value

A `SpatRaster` with one layer.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
lima <- get_departaments("LIMA")
burned_2024 <- get_mapbiomas_peru_fire(product = "annual_burned", year = 2024, crop_to = lima)
} # }
```
