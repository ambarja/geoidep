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
#> # A tibble: 10 × 2
#>    provider         layer_count
#>    <fct>                  <int>
#>  1 Geobosque                  5
#>  2 INAIGEM                    5
#>  3 INEI                       7
#>  4 MTC                       26
#>  5 MapBiomas Alerta           1
#>  6 Midagri                    2
#>  7 SIGRID                     4
#>  8 Senamhi                    1
#>  9 Serfor                     1
#> 10 Sernanp                   31
# }
```
