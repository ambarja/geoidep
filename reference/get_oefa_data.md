# Download OEFA-PIFA geospatial layers with spatial filtering

Download any public layer from the environmental enforcement IDE of the
Environmental Assessment and Enforcement Agency - OEFA
(<https://sistemas.oefa.gob.pe/pifa/mfe/#/interoperabilidad>). When
`region` is supplied, its bounding box is used to query the WFS service
and the downloaded features are then filtered to those falling inside
`region`. When `region` is `NULL`, the whole layer is downloaded.

## Usage

``` r
get_oefa_data(
  region = NULL,
  layer = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- region:

  An sf object specifying the area of interest (must be in EPSG:4326 -
  WGS 84). If `NULL`, the full layer is downloaded.

- layer:

  A string. Layer key (e.g. `"derechos_mineros"`). Run
  `get_data_sources("Oefa")` to list the 68 available layers.

- dsn:

  Character. Output filename. If supplied, the result is written to this
  file. If missing, a temporary file is used internally.

- show_progress:

  Logical. Show cli progress. Default `TRUE`.

- quiet:

  Logical. Suppress messages from
  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html).
  Default `TRUE`.

- timeout:

  Numeric. Seconds to wait for the server response (default 60).

## Value

An sf object with the layer geometries and attributes.

## Details

Column names are normalised to lowercase. The WFS 2.0.0 `bbox` filter
requires latitude/longitude axis order for EPSG:4326, which is handled
internally.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
get_data_sources("Oefa")

# Full layer download (mining rights countrywide)
mining <- get_oefa_data(layer = "derechos_mineros", show_progress = FALSE)
head(mining)

# Features inside a region of interest
lima <- sf::st_sf(geometry = sf::st_sfc(
  sf::st_bbox(c(xmin = -77.2, ymin = -12.6, xmax = -76.6, ymax = -11.7),
              crs = sf::st_crs(4326)) |>
    sf::st_as_sfc()
))
mining_lima <- get_oefa_data(region = lima, layer = "derechos_mineros",
                              show_progress = FALSE)
nrow(mining_lima)
} # }
```
