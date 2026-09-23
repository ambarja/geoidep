# Download MapBiomas Alerta Peru deforestation alerts with spatial filtering

Download the latest deforestation alerts detected by MapBiomas Alerta
Peru for a specific geographic area using an sf object (bounding box or
polygon). For more details, please visit: [MapBiomas Alerta
Platform](https://alerta.mapbiomas.org/)

## Usage

``` r
get_mapbiomas_peru_alerta(
  region = NULL,
  from = NULL,
  to = NULL,
  dsn = NULL,
  method = "within",
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- region:

  An sf object specifying the area of interest (must be in EPSG:4326 -
  WGS 84).

- from:

  Character. Start date in `"YYYY-MM-DD"` format. If `NULL`, no lower
  bound.

- to:

  Character. End date in `"YYYY-MM-DD"` format. If `NULL`, no upper
  bound.

- dsn:

  Character. Output filename. If missing, a temporary GeoJSON file is
  created.

- method:

  Character. Spatial predicate used to filter the downloaded alerts
  against `region`: `"intersects"` (safest default is `"within"` for
  backward compatibility), `"within"`, `"contains"`, `"crosses"`,
  `"touches"`.

- show_progress:

  Logical. Show cli progress. Default `TRUE`.

- quiet:

  Logical. Suppress messages from
  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html).
  Default `TRUE`.

- timeout:

  Numeric. Seconds to wait for the server response (default 60).

## Value

An sf object with alert geometries, attributes and image URLs.

## Details

The bounding box of `region` is used to query the WFS service. Image
URLs are generated from the alert `id` and point to public Google Cloud
Storage buckets. Column names are normalised to lowercase.
