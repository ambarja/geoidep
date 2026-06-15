# Discrete fill scale for MapBiomas Peru LULC classes

A `ggplot2` discrete fill scale that applies the official MapBiomas Peru
Collection 3 color palette to a classified `SpatRaster` (as a factor),
for use with
[`tidyterra::geom_spatraster()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster.html).

## Usage

``` r
scale_fill_mapbiomas_peru_d(..., lang = c("en", "es"), na.translate = FALSE)
```

## Arguments

- ...:

  Additional arguments passed to
  [`scale_fill_manual`](https://ggplot2.tidyverse.org/reference/scale_manual.html).

- lang:

  Character. Language for the legend labels, either `"en"` (default) or
  `"es"`.

- na.translate:

  Logical. Should `NA` values be displayed in the legend? Default is
  `FALSE`.

## Value

A `ggplot2` discrete scale object.

## Examples

``` r
# \donttest{
library(geoidep)
library(ggplot2)
library(tidyterra)
#> 
#> Attaching package: ‘tidyterra’
#> The following object is masked from ‘package:stats’:
#> 
#>     filter

lima <- get_departaments("LIMA")
#>   |                                                                              |                                                                      |   0%  |                                                                              |                                                                      |   1%  |                                                                              |=                                                                     |   1%  |                                                                              |=                                                                     |   2%  |                                                                              |==                                                                    |   3%  |                                                                              |====                                                                  |   5%  |                                                                              |=====                                                                 |   7%  |                                                                              |========                                                              |  11%  |                                                                              |===========                                                           |  16%  |                                                                              |===================                                                   |  28%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  32%  |                                                                              |===============================                                       |  44%  |                                                                              |========================================                              |  57%  |                                                                              |=============================================                         |  65%  |                                                                              |======================================================                |  77%  |                                                                              |===============================================================       |  90%  |                                                                              |======================================================================| 100%
lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)

ggplot() +
  geom_spatraster(data = as.factor(lulc_2024)) +
  scale_fill_mapbiomas_peru_d(lang = "es") +
  theme_minimal() +
  labs(fill = "Cobertura/Uso", title = "MapBiomas Perú 2024")
#> Error in unique.default(x, nmax = nmax): unique() applies only to vectors
# }
```
