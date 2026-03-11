# geoidep: Download Geographic Data Managed by Peru’s Spatial Data Infrastructure

[![R-CMD-check](https://github.com/ambarja/geoidep/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ambarja/geoidep/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/ambarja/geoidep/graph/badge.svg)](https://app.codecov.io/gh/ambarja/geoidep)
[![CircleCI build
status](https://circleci.com/gh/ambarja/geoidep.svg?style=svg)](https://circleci.com/gh/ambarja/geoidep)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
![logo](https://raw.githubusercontent.com/ambarja/geoidep/refs/heads/main/man/figures/geoidep_logo_b.png)![logo](https://raw.githubusercontent.com/ambarja/geoidep/refs/heads/main/man/figures/geoidep_logo_o.png)

The goal of **geoidep**📦 is to offers R users an easy and accessible
way to obtain official cartographic data on various topics, such as
**society**🏛️, **transport**🚗, **environment**🌱, **agriculture**🌾,
**climate**⛅️,among others.This includes information provided by
regional government entities and technical-scientific institutions,
managed by the **Spatial Data Infrastructure of Peru**.

*⚠️ The package accesses these datasets dynamically from official public
servers, without redistributing data locally.*

The package is currently available in **R** and Python (coming soon).

------------------------------------------------------------------------

## Installation R

You can install the development version of geoidep like so:

``` r
install.packages('pak')
pak::pkg_install('ambarja/geoidep')
```

or also the official version available on CRAN:

``` r
install.packages('geoidep')
```

## Example 01: Introduction

``` r
library(geoidep)
```

``` r
── Welcome to geoidep ─────────────────────────────────────────────────────────────────
ℹ geoidep is a wrapper that enables you to download cartographic data for Peru directly from R.
ℹ Currently, `geoidep` supports data from the following providers:
• Geobosque
• INAIGEM
• INEI
• Midagri
• and more!
ℹ For more information, please use the `get_data_sources()` function.
```

In this example, we can identify the list of providers available in
geoidep and the layers they present.

``` r
get_data_sources() |> 
  head()
#> # A tibble: 6 × 7
#>   provider  category    layer layer_can_be_actived admin_en year  link_geoportal
#>   <chr>     <chr>       <chr> <lgl>                <chr>    <chr> <chr>         
#> 1 INEI      General     depa… TRUE                 Nationa… 2019  https://ide.i…
#> 2 INEI      General     prov… TRUE                 Nationa… 2019  https://ide.i…
#> 3 INEI      General     dist… TRUE                 Nationa… 2019  https://ide.i…
#> 4 Midagri   Agriculture agri… TRUE                 Ministr… 2024  https://siea.…
#> 5 Midagri   Agriculture oil_… TRUE                 Ministr… 2016… https://siea.…
#> 6 Geobosque Forest      stoc… FALSE                Ministr… 2001… https://geobo…
```

In summary the suppliers and the number of available layers

``` r
get_providers() 
#> # A tibble: 9 × 2
#>   provider  layer_count
#>   <fct>           <int>
#> 1 Geobosque           5
#> 2 INAIGEM             5
#> 3 INEI                7
#> 4 Midagri             2
#> 5 MTC                26
#> 6 Senamhi             1
#> 7 Serfor              1
#> 8 Sernanp            31
#> 9 SIGRID              4
```

## Example 02: Download official INEI administrative boundaries

This is a simple example of how to download Peru’s official
administrative boundaries:

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
#>   id objectid ccdd   nombdep shape_length shape_area
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
