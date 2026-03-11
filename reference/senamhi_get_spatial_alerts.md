# Download Meteorological Alert Geometry from Senamhi

This function downloads the spatial alert geometry (shapefile) from
Senamhi for a given alert.

## Usage

``` r
senamhi_get_spatial_alerts(
  data = NULL,
  nro = NULL,
  year = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE
)
```

## Arguments

- data:

  A data frame with a single alert (with columns `nro` and `emision`),
  or NULL if you specify `nro` and `year`.

- nro:

  A numeric value (optional if `data` is provided).

- year:

  A numeric value (optional if `data` is provided).

- dsn:

  Path to save the downloaded .zip. If NULL, a temporary file is used.

- show_progress:

  Logical, show download progress.

- quiet:

  Logical, suppress messages from
  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html).

## Value

An sf object with the alert geometry.
