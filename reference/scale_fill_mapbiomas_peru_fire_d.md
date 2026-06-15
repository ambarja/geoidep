# Discrete fill scale for MapBiomas Peru Fire products

A `ggplot2` discrete fill scale that applies the official MapBiomas
Fuego Peru (Collection 1) color palette for a given sub-product to a
classified `SpatRaster` (as a factor), for use with
[`tidyterra::geom_spatraster()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster.html).

## Usage

``` r
scale_fill_mapbiomas_peru_fire_d(
  product,
  ...,
  lang = c("en", "es"),
  na.translate = FALSE
)
```

## Arguments

- product:

  Character. One of the products listed in
  [`get_mapbiomas_peru_fire_products`](https://geografo.pe/geoidep/reference/get_mapbiomas_peru_fire_products.md).

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
#>   |                                                                              |                                                                      |   0%  |                                                                              |=                                                                     |   1%  |                                                                              |==                                                                    |   3%  |                                                                              |=====                                                                 |   7%  |                                                                              |===========                                                           |  16%  |                                                                              |===================                                                   |  28%  |                                                                              |======================                                                |  32%  |                                                                              |=======================                                               |  33%  |                                                                              |================================                                      |  45%  |                                                                              |========================================                              |  57%  |                                                                              |=============================================                         |  65%  |                                                                              |==============================================                        |  66%  |                                                                              |=======================================================               |  78%  |                                                                              |===============================================================       |  91%  |                                                                              |======================================================================| 100%

# Frecuencia de área quemada
freq <- get_mapbiomas_peru_fire(
  product = "frequency_burned",
  year = 2024,
  crop_to = lima
)

ggplot() +
  geom_spatraster(data = as.factor(freq)) +
  scale_fill_mapbiomas_peru_fire_d("frequency_burned", lang = "es") +
  theme_minimal() +
  labs(fill = "N° de quemas", title = "Frecuencia de área quemada 2013-2024")
#> Error in unique.default(x, nmax = nmax): unique() applies only to vectors

# Año del último fuego
last_fire <- get_mapbiomas_peru_fire(
  product = "year_last_fire",
  year = 2024,
  crop_to = lima
)

ggplot() +
  geom_spatraster(data = as.factor(last_fire)) +
  scale_fill_mapbiomas_peru_fire_d("year_last_fire", lang = "es") +
  theme_minimal() +
  labs(fill = "Año", title = "Año del último fuego")
#> Error in unique.default(x, nmax = nmax): unique() applies only to vectors
# }
```
