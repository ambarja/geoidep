# Get the MapBiomas Peru Fire legend for a given product

Returns a lookup table with the pixel value codes, English/Spanish class
names, and hexadecimal colors used by a given MapBiomas Fuego Peru
sub-product (Collection 1). Useful for building color scales (see
[`scale_fill_mapbiomas_peru_fire_d`](https://geografo.pe/geoidep/reference/scale_fill_mapbiomas_peru_fire_d.md)).

## Usage

``` r
get_mapbiomas_peru_fire_legend(product)
```

## Arguments

- product:

  Character. One of the products listed in
  [`get_mapbiomas_peru_fire_products`](https://geografo.pe/geoidep/reference/get_mapbiomas_peru_fire_products.md).

## Value

A tibble with columns `id`, `class_en`, `class_es`, and `hex`.

## Details

- `annual_burned` and `accumulated_burned`: binary classification
  (`1 = "Burned area"`).

- `annual_burned_coverage` and `accumulated_burned_coverage`: share the
  LULC legend (see `get_mapbiomas_peru_legend`), since these products
  classify the burned pixels by land cover class.

- `monthly_burned`: pixel values `1-12` represent the month
  (January-December) in which the pixel burned.

- `frequency_burned`: pixel values `1-12` represent the number of times
  a pixel burned during the period (`12` = "12 or more times").

- `year_last_fire`: pixel values are the actual years (`2013-2024`) of
  the most recent fire.

- `annual_burned_scar_size_range`: pixel values `1-5` represent burned
  scar size classes (from `< 25 ha` to `> 5000 ha`).

## Examples

``` r
library(geoidep)
get_mapbiomas_peru_fire_legend("frequency_burned")
#> # A tibble: 12 × 4
#>       id class_en         class_es          hex    
#>    <dbl> <chr>            <chr>             <chr>  
#>  1     1 Burned once      Quemado 1 vez     #FAF3CD
#>  2     2 Burned twice     Quemado 2 veces   #F9E676
#>  3     3 Burned 3 times   Quemado 3 veces   #F1CD38
#>  4     4 Burned 4 times   Quemado 4 veces   #DDA71C
#>  5     5 Burned 5 times   Quemado 5 veces   #C77E14
#>  6     6 Burned 6 times   Quemado 6 veces   #B0540F
#>  7     7 Burned 7 times   Quemado 7 veces   #992A0A
#>  8     8 Burned 8 times   Quemado 8 veces   #7B1208
#>  9     9 Burned 9 times   Quemado 9 veces   #5C0407
#> 10    10 Burned 10 times  Quemado 10 veces  #440508
#> 11    11 Burned 11 times  Quemado 11 veces  #260405
#> 12    12 Burned 12+ times Quemado 12+ veces #040101
```
