
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geoidep

<img src="man/figures/geoidep.svg" align="right" hspace="10" vspace="0" width="20%">

<!-- badges: start -->

[![R-CMD-check](https://github.com/ambarja/geoidep/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ambarja/geoidep/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/github/ambarja/geoidep/graph/badge.svg?token=0HVS30MQ21)](https://codecov.io/github/ambarja/geoidep)
<!-- badges: end -->

The goal of geoidep is to offers R users an easy and accessible way to
obtain official cartographic data on various topics, such as society,
transport, environment, agriculture, climate, among others.

It also includes information provided by regional government entities
and technical-scientific institutions,managed by the Spatial Data
Infrastructure of Peru.

## Installation

You can install the development version of geoidep like so:

``` r
install.packages('pak')
pak::pkg_install("ambarja/geoidep")
```

## Example

This is a simple example of how to download Peru’s official
administrative boundaries:

``` r
library(geoidep)
#> 
#> ── Welcome to geoidep ──────────────────────────────────────────────────────────
#> ℹ geoidep is a wrapper that allows you to download cartographic data for Peru from R.
#> Currently, `geoidep` supports the following providers:
#> ✔ INEI
#> ✔ SERNAMP
#> ✔ MINSA
#> ✔ MTC
#> ℹ For more information, please use the `get_providers()` function.
```

``` r
dep <- get_departaments(show_progress = FALSE)
```

The first 10 rows of the original data are displayed here:

``` r
head(dep)
#> Simple feature collection with 6 features and 6 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -79.45857 ymin: -17.28501 xmax: -70.80408 ymax: -2.986125
#> Geodetic CRS:  WGS 84
#>   id OBJECTID CCDD   NOMBDEP SHAPE_Length SHAPE_Area
#> 1  1        1   01  AMAZONAS    13.059047   3.199147
#> 2  2        2   02    ANCASH    11.788249   2.954697
#> 3  3        3   03  APURIMAC     7.730154   1.765933
#> 4  4        4   04  AREQUIPA    17.459435   5.330125
#> 5  5        5   05  AYACUCHO    17.127166   3.643705
#> 6  6        6   06 CAJAMARCA    12.540288   2.688386
#>                             geom
#> 1 MULTIPOLYGON (((-77.81399 -...
#> 2 MULTIPOLYGON (((-77.64697 -...
#> 3 MULTIPOLYGON (((-73.74655 -...
#> 4 MULTIPOLYGON (((-71.98109 -...
#> 5 MULTIPOLYGON (((-74.34843 -...
#> 6 MULTIPOLYGON (((-78.70034 -...
```
