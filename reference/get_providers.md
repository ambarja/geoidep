# List resources and count layers of IDEP

Summary of providers

## Usage

``` r
get_providers(query = NULL)
```

## Arguments

- query:

  Character. Default is NULL.

## Value

An sf or tibble object.

## Examples

``` r
# \donttest{
library(geoidep)
get_providers()
#> # A tibble: 9 × 2
#>   provider  layer_count
#>   <fct>           <int>
#> 1 Geobosque           5
#> 2 INAIGEM             5
#> 3 INEI                7
#> 4 MTC                26
#> 5 Midagri             2
#> 6 SIGRID              4
#> 7 Senamhi             1
#> 8 Serfor              1
#> 9 Sernanp            31
# }
```
