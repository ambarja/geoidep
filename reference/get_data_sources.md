# List providers, description, year and link

This function allows you to list the list of available providers of the
geoidep package.

## Usage

``` r
get_data_sources(query = NULL)
```

## Arguments

- query:

  A string. Default is NULL. List of available providers. For more
  details, use the `get_providers` function.

## Value

A tibble object.

## Examples

``` r
# \donttest{
library(geoidep)
get_data_sources()
#> # A tibble: 82 × 7
#>    provider  category   layer layer_can_be_actived admin_en year  link_geoportal
#>    <chr>     <chr>      <chr> <lgl>                <chr>    <chr> <chr>         
#>  1 INEI      General    depa… TRUE                 Nationa… 2019  https://ide.i…
#>  2 INEI      General    prov… TRUE                 Nationa… 2019  https://ide.i…
#>  3 INEI      General    dist… TRUE                 Nationa… 2019  https://ide.i…
#>  4 Midagri   Agricultu… agri… TRUE                 Ministr… 2024  https://siea.…
#>  5 Midagri   Agricultu… oil_… TRUE                 Ministr… 2016… https://siea.…
#>  6 Geobosque Forest     stoc… FALSE                Ministr… 2001… https://geobo…
#>  7 Geobosque Forest     stoc… TRUE                 Ministr… 2001… https://geobo…
#>  8 Geobosque Forest     stoc… TRUE                 Ministr… 2001… https://geobo…
#>  9 Geobosque Forest     stoc… TRUE                 Ministr… 2001… https://geobo…
#> 10 Geobosque Forest     warn… TRUE                 Ministr… last… https://geobo…
#> # ℹ 72 more rows
# }
```
