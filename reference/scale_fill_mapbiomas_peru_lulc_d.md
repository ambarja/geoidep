# Discrete fill scale for MapBiomas Peru LULC classes

A `ggplot2` discrete fill scale that applies the official MapBiomas Peru
Collection 3 color palette to a classified `SpatRaster` (as a factor),
for use with
[`tidyterra::geom_spatraster()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster.html).

## Usage

``` r
scale_fill_mapbiomas_peru_lulc_d(
  ...,
  lang = c("en", "es"),
  na.translate = FALSE
)
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

lima <- get_departaments("LIMA")
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |==                                                                    |   3%  |                                                                              |===                                                                   |   5%  |                                                                              |====                                                                  |   6%  |                                                                              |=====                                                                 |   7%  |                                                                              |======                                                                |   8%  |                                                                              |=======                                                               |  10%  |                                                                              |========                                                              |  11%  |                                                                              |========                                                              |  12%  |                                                                              |=========                                                             |  13%  |                                                                              |==========                                                            |  14%  |                                                                              |==========                                                            |  15%  |                                                                              |===========                                                           |  16%  |                                                                              |============                                                          |  17%  |                                                                              |=============                                                         |  18%  |                                                                              |==============                                                        |  20%  |                                                                              |=================                                                     |  24%  |                                                                              |==================                                                    |  25%  |                                                                              |===================                                                   |  27%  |                                                                              |====================                                                  |  28%  |                                                                              |=====================                                                 |  31%  |                                                                              |=======================                                               |  33%  |                                                                              |========================                                              |  35%  |                                                                              |=========================                                             |  35%  |                                                                              |=========================                                             |  36%  |                                                                              |===========================                                           |  38%  |                                                                              |============================                                          |  40%  |                                                                              |==============================                                        |  42%  |                                                                              |==============================                                        |  43%  |                                                                              |================================                                      |  46%  |                                                                              |=================================                                     |  47%  |                                                                              |==================================                                    |  48%  |                                                                              |==================================                                    |  49%  |                                                                              |====================================                                  |  52%  |                                                                              |========================================                              |  57%  |                                                                              |==========================================                            |  60%  |                                                                              |===========================================                           |  61%  |                                                                              |============================================                          |  62%  |                                                                              |==============================================                        |  65%  |                                                                              |=================================================                     |  70%  |                                                                              |====================================================                  |  74%  |                                                                              |============================================================          |  86%  |                                                                              |===================================================================   |  96%  |                                                                              |======================================================================| 100%
lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
#> |---------|---------|---------|---------|=========================================                                          

ggplot() +
  geom_spatraster(data = as.factor(lulc_2024)) +
  scale_fill_mapbiomas_peru_lulc_d(lang = "es") +
  theme_minimal() +
  labs(fill = "Cobertura/Uso", title = "MapBiomas Perú 2024")
#> Error in unique.default(x, nmax = nmax): unique() applies only to vectors
# }
```
