# Download the available data from Sernanp

This function allows you to download the latest version of data
available on the sernanp geoviewer. For more information, you can visit
the following web page: [Sernanp
Platform](https://geo.sernanp.gob.pe/visorsernanp/)

## Usage

``` r
get_sernanp_data(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE)
```

## Arguments

- layer:

  Select only one from the list of available layers, for more
  information please use `get_data_sources(provider = "sernanp")`.
  Defaults to NULL.

- dsn:

  Character. Output filename with the **spatial format**. If missing, a
  temporary file is created.

- show_progress:

  Logical. Suppress bar progress.

- quiet:

  Logical. Suppress info message.

## Value

An sf object.

## Examples

``` r
# \donttest{
library(geoidep)
library(sf)
anp <- get_sernanp_data(layer = "zonificacion_anp" , show_progress = FALSE)
plot(st_geometry(anp))

# }
```
