# Get a multi-year stack of MapBiomas Peru LULC rasters

Downloads and stacks multiple single-year LULC rasters from MapBiomas
Peru (see
[`get_mapbiomas_peru_lulc`](https://geografo.pe/geoidep/reference/get_mapbiomas_peru_lulc.md)),
each cropped to the same area of interest if provided. Progress uses
[cli](https://cli.r-lib.org/reference/cli_progress_bar.html).

## Usage

``` r
get_mapbiomas_peru_lulc_series(
  years,
  crop_to = NULL,
  collection = 4,
  show_progress = TRUE
)
```

## Arguments

- years:

  Integer vector. Years to download (e.g. `2018:2024`).

- crop_to:

  Optional. An `sf`/`sfc` object, `SpatVector`, or `SpatExtent`. If
  `NULL`, each raster is returned at full extent.

- collection:

  Integer. MapBiomas Peru collection number (`1`, `2`, `3`, `4`).
  Default `3`.

- show_progress:

  Logical. Show a cli progress bar. Default `TRUE`.

## Value

A `SpatRaster` with one layer per year, named `classification_<year>`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
lima <- get_departaments("LIMA", show_progress = FALSE)
lulc_series <- get_mapbiomas_peru_lulc_series(years = 2020:2024, crop_to = lima)
lulc_series
} # }
```
