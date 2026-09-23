# Download before/after deforestation images from MapBiomas Alerta Peru

Download satellite imagery (before/after deforestation) for specific
MapBiomas Alerta alerts from public Google Cloud Storage buckets.
Progress uses
[cli](https://cli.r-lib.org/reference/cli_progress_bar.html).

## Usage

``` r
get_mapbiomas_alert_images(
  alert_ids,
  download_dir = NULL,
  image_type = "both",
  show_progress = TRUE,
  overwrite = FALSE
)
```

## Arguments

- alert_ids:

  Character or numeric vector. Alert IDs to download images for.

- download_dir:

  Character. Directory where images will be saved. If NULL, a temporary
  directory is used.

- image_type:

  Character. Which images to download: "both" (default), "before", or
  "after".

- show_progress:

  Logical. Show cli progress. Default `TRUE`.

- overwrite:

  Logical. Overwrite existing files. Default `FALSE`.

## Value

A tibble with columns `alert_id`, `image_type`, `url`, `local_path`,
`status`, `error_message`.

## Details

File names follow the pattern `alert_{id}_before_deforestation.png` and
`alert_{id}_after_deforestation.png`. Each image has a 120-second
timeout.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
aoi <- get_departaments(show_progress = FALSE) |>
  subset(nombdep == "UCAYALI")
alerts <- get_mapbiomas_peru_alerta(region = aoi, show_progress = FALSE)
alert_ids <- alerts$id[1:5]
download_dir <- file.path(tempdir(), "mapbiomas_images")
results <- get_mapbiomas_alert_images(
  alert_ids = alert_ids,
  download_dir = download_dir,
  show_progress = FALSE
)
head(results)
} # }
```
