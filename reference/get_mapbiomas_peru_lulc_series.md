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
# \donttest{
library(geoidep)

lima <- get_departaments("LIMA")
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |==                                                                    |   3%  |                                                                              |====                                                                  |   6%  |                                                                              |======                                                                |   9%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |===========                                                           |  16%  |                                                                              |=============                                                         |  18%  |                                                                              |===============                                                       |  21%  |                                                                              |================                                                      |  24%  |                                                                              |==================                                                    |  26%  |                                                                              |=====================                                                 |  29%  |                                                                              |======================                                                |  31%  |                                                                              |========================                                              |  34%  |                                                                              |==========================                                            |  37%  |                                                                              |===========================                                           |  39%  |                                                                              |=============================                                         |  42%  |                                                                              |===============================                                       |  45%  |                                                                              |=================================                                     |  47%  |                                                                              |===================================                                   |  50%  |                                                                              |=====================================                                 |  53%  |                                                                              |=======================================                               |  55%  |                                                                              |========================================                              |  58%  |                                                                              |==========================================                            |  61%  |                                                                              |============================================                          |  63%  |                                                                              |==============================================                        |  66%  |                                                                              |================================================                      |  68%  |                                                                              |==================================================                    |  71%  |                                                                              |====================================================                  |  74%  |                                                                              |=====================================================                 |  76%  |                                                                              |=======================================================               |  79%  |                                                                              |=========================================================             |  82%  |                                                                              |===========================================================           |  84%  |                                                                              |=============================================================         |  87%  |                                                                              |===============================================================       |  90%  |                                                                              |=================================================================     |  92%  |                                                                              |==================================================================    |  95%  |                                                                              |====================================================================  |  97%  |                                                                              |======================================================================| 100%
lulc_series <- get_mapbiomas_peru_lulc_series(years = 2020:2024, crop_to = lima)
#> |---------|---------|---------|---------|=========================================                                          |---------|---------|---------|---------|=========================================                                          |---------|---------|---------|---------|=========================================                                          |---------|---------|---------|---------|=========================================                                          |---------|---------|---------|---------|=========================================                                          
lulc_series
#> class       : SpatRaster
#> size        : 11315, 8827, 5  (nrow, ncol, nlyr)
#> resolution  : 0.0002694946, 0.0002694946  (x, y)
#> extent      : -77.88636, -75.50753, -13.32354, -10.27421  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326)
#> source(s)   : memory
#> varnames    : peru_collection3_integration_v1-classification_2020
#>               peru_collection3_integration_v1-classification_2021
#>               peru_collection3_integration_v1-classification_2022
#>               peru_collection3_integration_v1-classification_2023
#>               peru_collection3_integration_v1-classification_2024
#> names       : classi~n_2020, classi~n_2021, classi~n_2022, classi~n_2023, classi~n_2024
#> min values  :             0,             0,             0,             0,             0
#> max values  :            72,            72,            72,            72,            72
#> class       : SpatRaster
#> dimensions  : 4521, 5103, 5  (nrow, ncol, nlyr)
#> names       : classification_2020, classification_2021, ..., classification_2024
# }
```
