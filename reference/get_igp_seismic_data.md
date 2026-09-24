# Download seismic data from the Geophysical Institute of Peru (IGP)

Download the Peruvian seismic catalogs published by the Centro
Sismologico Nacional (CENSIS) of the Instituto Geofisico del Peru (IGP)
through the same endpoint used by the [IGP seismic data
repository](https://ultimosismo.igp.gob.pe/repositorio/datos-sismicos):
a `GET` request filtered by bounding box, magnitude and depth that
returns an XLSX file. The epicentres are returned as an `sf` POINT layer
(EPSG:4326) and, optionally, clipped to any user-supplied polygon with
`sf`. For more information, visit [IGP](https://www.igp.gob.pe/).

## Usage

``` r
get_igp_seismic_data(
  catalog = c("instrumental", "historic"),
  start_date = NULL,
  end_date = NULL,
  min_magnitude = 4,
  max_magnitude = 10,
  min_depth = 0,
  max_depth = 900,
  polygon = NULL,
  dsn = NULL,
  show_progress = TRUE,
  timeout = 180
)
```

## Arguments

- catalog:

  A string. One of `instrumental` (1960 to present) or `historic`
  (1471-1959).

- start_date, end_date:

  Strings (`YYYY-MM-DD`). Only used when `catalog = "instrumental"`;
  defaults to the last 30 days. Ignored when `catalog = "historic"` (the
  repository fixes the period to 1471-01-01/1959-12-31).

- min_magnitude, max_magnitude:

  Numerics. Magnitude range filter. Default `4` to `10`.

- min_depth, max_depth:

  Numerics. Depth range filter in km. Default `0` to `900`.

- polygon:

  An `sf` object. Its bounding box is sent to the server to narrow the
  download, and only the epicentres falling inside the polygon are
  returned. Any CRS is accepted (reprojected internally to EPSG:4326).

- dsn:

  A string. Optional path where the raw XLSX file is saved. Default
  `NULL` (temporary file).

- show_progress:

  Logical. Show cli progress. Default `TRUE`.

- timeout:

  Numeric. Seconds to wait for the server response. The IGP service
  generates the XLSX on demand, so the default is `180`.

## Value

An `sf` object (POINT, EPSG:4326). The `instrumental` catalog has
columns `fecha_utc`, `hora_utc`, `latitud`, `longitud`,
`profundidad_km`, `magnitud`; the `historic` catalog reports three
magnitude scales (`magnitud_mb`, `magnitud_ms`, `magnitud_mw`).

## Details

The XLSX response is parsed with base R only
([`utils::unzip()`](https://rdrr.io/r/utils/unzip.html) plus a small
internal reader), so no additional package is required. Very wide
queries (e.g. the full `historic` catalog with low magnitudes) may
exceed the server capacity (HTTP 502); narrow the filters and retry.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
sismos <- get_igp_seismic_data(
  catalog = "instrumental",
  start_date = "2026-08-24",
  end_date = "2026-09-24",
  min_magnitude = 4,
  show_progress = FALSE)
head(sismos)
} # }
```
