# Download the available data from MTC

Download the latest version of data available on the MTC geoportal. For
more information, visit [MTC Geoportal](https://geoportal.mtc.gob.pe/).

## Usage

``` r
get_mtc_data(
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
  information please use `get_data_sources(provider = "mtc")`. Defaults
  to NULL.

- dsn:

  Character. Output filename with the **spatial format**. If missing, a
  temporary file is created.

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
aerodromo <- get_mtc_data(layer = "aerodromos_2023", show_progress = FALSE)
head(aerodromo)
plot(st_geometry(aerodromo))
} # }
```
