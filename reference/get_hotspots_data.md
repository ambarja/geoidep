# Download available hot spot data from Serfor's Satellite Monitoring Unit

Download the latest version of forest fire data available from the
Satellite Monitoring Unit of the National Forestry and Wildlife Service
of Peru. For more information, visit [Serfor
Platform](https://sniffs.serfor.gob.pe/monitoreo/sami/index.html).

## Usage

``` r
get_hotspots_data(dsn = NULL, show_progress = TRUE, quiet = TRUE)
```

## Arguments

- dsn:

  Character. Output filename. If missing, a temporary file is created.

- show_progress:

  Logical. Show a cli progress bar. Default `TRUE`.

- quiet:

  Logical. Suppress message from
  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html).
  Default `TRUE`.

## Value

An sf object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
library(sf)
hot_spots <- get_hotspots_data(show_progress = FALSE)
head(hot_spots)
} # }
```
