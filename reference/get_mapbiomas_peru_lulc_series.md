# Get a multi-year stack of MapBiomas Peru LULC rasters

Downloads and stacks multiple single-year LULC rasters from MapBiomas
Peru (see
[`get_mapbiomas_peru_lulc`](https://geografo.pe/geoidep/reference/get_mapbiomas_peru_lulc.md)),
each cropped to the same area of interest if provided.

## Usage

``` r
get_mapbiomas_peru_lulc_series(years, crop_to = NULL, collection = 3)
```

## Arguments

- years:

  Integer vector. Years to download (e.g. `2018:2024`).

- crop_to:

  Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent` defining
  the area of interest. If `NULL` (default), each raster is returned at
  full extent.

- collection:

  Integer. MapBiomas Peru collection number. Default is `3`.

## Value

A `SpatRaster` with one layer per year, named `classification_<year>`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)

lima <- get_departaments("LIMA",show_progress = FALSE)
lulc_series <- get_mapbiomas_peru_lulc_series(years = 2020:2024, crop_to = lima)
lulc_series
#> class       : SpatRaster
#> dimensions  : 4521, 5103, 5  (nrow, ncol, nlyr)
#> names       : classification_2020, classification_2021, ..., classification_2024
} # }
```
