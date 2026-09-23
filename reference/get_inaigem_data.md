# Download the available data from INAIGEM

Download the latest version of data available on the INAIGEM geoportal.
For more information, visit [INAIGEM
Geoportal](https://geoportal.inaigem.gob.pe/).

## Usage

``` r
get_inaigem_data(
  layer = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- layer:

  Select only one from the list of available layers, for more
  information please use `get_data_sources(provider = "INAIGEM")`.
  Defaults to NULL.

- dsn:

  Character. Output filename. If missing, a temporary file is created.

- show_progress:

  Logical. Show a cli progress bar. Default `TRUE`.

- quiet:

  Logical. Suppress info message. Default `TRUE`.

- timeout:

  Numeric. Seconds to wait for a response. Default 60.

## Value

An sf object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
library(sf)
glaciar <- get_inaigem_data(layer = "glaciares_1989", show_progress = FALSE)
head(glaciar)
plot(st_geometry(glaciar))
} # }
```
