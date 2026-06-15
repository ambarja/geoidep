# Download MapBiomas Alerta Peru deforestation alerts with spatial filtering

This function allows you to download the latest deforestation alerts
detected by MapBiomas Alerta Peru for a specific geographic area using
an sf object (bounding box or polygon). For more details, please visit:
[MapBiomas Alerta Platform](https://alerta.mapbiomas.org/)

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

  Character. Start date for filtering, in `"YYYY-MM-DD"` format (e.g.
  `"2024-01-01"`). If `NULL` (default), no lower bound is applied.

- to:

  Character. End date for filtering, in `"YYYY-MM-DD"` format (e.g.
  `"2024-12-31"`). If `NULL` (default), no upper bound is applied.

- dsn:

  Character. Output filename with spatial format. If missing, a
  temporary GeoJSON file is created.

- method:

  A character string specifying the spatial predicate used to filter the
  downloaded alerts against the `region`. Available options are:

  - `"intersects"` (Default): Returns alerts that touch, cross, or are
    inside the region. This is the safest option to avoid losing edge
    alerts.

  - `"within"`: Returns only alerts that are 100\\ inside the region
    boundary.

  - `"contains"`: Returns alerts that completely contain the region
    (useful if the region is a point or a very small plot).

  - `"crosses"`: Returns alerts that cut or cross the region boundary
    (ideal if the region is a linear feature like a road or river).

  - `"touches"`: Returns alerts that share a common boundary with the
    region but do not penetrate its interior.

- show_progress:

  Logical. If TRUE, shows a progress bar during download.

- quiet:

  Logical. If TRUE, suppresses messages from sf::st_read().

- timeout:

  Numeric. Seconds to wait for the server response (default 60).

## Value

An sf object containing MapBiomas Alerta geometries with alert
attributes and image URLs. The returned object includes the following
key columns:

- **id**: Unique identifier for each alert

- **geometry**: Alert polygon geometry

- **before_image_url**: URL to before deforestation image (Google Cloud
  Storage)

- **after_image_url**: URL to after deforestation image (Google Cloud
  Storage)

- Other alert attributes from MapBiomas

## Details

The function uses the MapBiomas Alerta to query deforestation alerts
within the geographic extent of the provided region. The bounding box of
the region is used to spatially filter the data. Column names are
automatically normalized to lowercase.

Image URLs are automatically generated from the alert **id** field and
point to before/after satellite imagery stored in public Google Cloud
Storage buckets. Users can access these images directly or download them
programmatically if needed.
