# List resources and count layers of IDEP

Summary of providers.

## Usage

``` r
get_providers(query = NULL)
```

## Arguments

- query:

  Character. Default is NULL (only `NULL` is valid).

## Value

A tibble with columns `provider` and `layer_count`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
get_providers()
} # }
```
