# List providers, description, year and link

List the available providers of the geoidep package.

## Usage

``` r
get_data_sources(query = NULL)
```

## Arguments

- query:

  A string. Default is NULL. Filter by provider name(s). For valid
  values use
  [`get_providers()`](https://geografo.pe/geoidep/reference/get_providers.md).

## Value

A tibble object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
get_data_sources()
} # }
```
