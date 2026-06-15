# Get available MapBiomas Peru Fire products

Returns a lookup table describing the MapBiomas Fuego (Fire) Peru
sub-products available for download, including their internal codes,
descriptions, and whether they are indexed by a single `year` or by a
`year range` (starting in 2013).

## Usage

``` r
get_mapbiomas_peru_fire_products()
```

## Value

A tibble with columns `product`, `description_en`, `description_es`, and
`temporal` (`"annual"` or `"range"`).

## Examples

``` r
library(geoidep)
get_mapbiomas_peru_fire_products()
#> # A tibble: 8 × 4
#>   product                       description_en           description_es temporal
#>   <chr>                         <chr>                    <chr>          <chr>   
#> 1 annual_burned                 Annual burned area       Área quemada … annual  
#> 2 annual_burned_coverage        Annual burned area by l… Área quemada … annual  
#> 3 monthly_burned                Monthly burned area      Área quemada … annual  
#> 4 accumulated_burned            Accumulated burned area  Área quemada … range   
#> 5 accumulated_burned_coverage   Accumulated burned area… Área quemada … range   
#> 6 frequency_burned              Burned area frequency    Frecuencia de… range   
#> 7 annual_burned_scar_size_range Annual burned scar size  Tamaño de cic… annual  
#> 8 year_last_fire                Year of last fire        Año del últim… annual  
```
