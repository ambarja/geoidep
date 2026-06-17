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
  `get_mapbiomas_peru_fire_products`, e.g. `"annual_burned"`,
  `"year_last_fire"`, `"frequency_burned"`.

- year:

  Integer. For `"annual"` products (see
  [`get_mapbiomas_peru_fire_products`](https://geografo.pe/geoidep/reference/get_mapbiomas_peru_fire_products.md)),
  the year of the map (available from `1999`). For `"range"` products
  (`accumulated_*`, `frequency_burned`), the **end year** of the
  accumulated period, which always starts in `2013`.

- crop_to:

  Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent` defining
  the area of interest. If `NULL` (default), the full raster for Peru is
  returned.

- collection:

  Integer. MapBiomas Fuego Peru collection number. Default is `1`
  (currently the only collection available).

## Value

A `SpatRaster` with one layer.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)

lima <- get_departaments("LIMA")

# Annual burned area for 2024, cropped to Lima
burned_2024 <- get_mapbiomas_peru_fire(
  product = "annual_burned",
  year = 2024,
  crop_to = lima
)

# Accumulated burned area 2013-2024
accumulated <- get_mapbiomas_peru_fire(
  product = "accumulated_burned",
  year = 2024,
  crop_to = lima
)
} # }
```
