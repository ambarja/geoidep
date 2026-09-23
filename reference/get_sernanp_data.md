# Download the available data from Sernanp

Download the latest version of data available on the sernanp geoviewer.
For more information, visit [Sernanp
Platform](https://geo.sernanp.gob.pe/visorsernanp/).

## Usage

``` r
get_sernanp_data(
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
  information please use `get_data_sources(provider = "sernanp")`.
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
anp <- get_sernanp_data(layer = "zonificacion_anp", show_progress = FALSE)
plot(st_geometry(anp))
} # }
```
