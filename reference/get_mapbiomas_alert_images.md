# Download before/after deforestation images from MapBiomas Alerta Peru

This function downloads satellite imagery (before/after deforestation)
for specific MapBiomas Alerta alerts from public Google Cloud Storage
buckets.

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

  Character vector or numeric vector. Alert IDs to download images for.

- download_dir:

  Character. Directory path where images will be saved. If NULL, creates
  a temporary directory.

- image_type:

  Character. Which images to download: "both" (default), "before", or
  "after".

- show_progress:

  Logical. If TRUE, shows progress bar during download.

- overwrite:

  Logical. If TRUE, overwrites existing files (default FALSE).

## Value

A data frame (tibble) with columns:

- alert_id: The alert ID

- image_type: "before" or "after"

- url: Download URL

- local_path: Path to downloaded file

- status: "success" or "failed"

- error_message: Error message if download failed

## Details

Images are downloaded from public Google Cloud Storage URLs. File names
follow the pattern: `alert_{id}_before_deforestation.png` and
`alert_{id}_after_deforestation.png`

The function uses HTTP GET requests with a 120-second timeout per image.

## Examples

``` r
# \donttest{
library(geoidep)

# Download images for specific alerts
# First get some alerts
aoi <- get_departaments(show_progress = FALSE) |>
  subset(nombdep == "UCAYALI")

alerts <- get_mapbiomas_peru_alerta(region = aoi, show_progress = FALSE)
#> Error in value[[3L]](cond): Unable to retrieve MapBiomas alerts.
#> ✖ The MapBiomas service may be temporarily unavailable.
#> ℹ Please try again later.

# Get alert IDs
alert_ids <- alerts$id[1:5]  # First 5 alerts
#> Error: object 'alerts' not found

# Get images to a directory
download_dir <- file.path(tempdir(), "mapbiomas_images")
results <- get_mapbiomas_alert_images(
  alert_ids = alert_ids,
  download_dir = download_dir,
  show_progress = TRUE
)
#> Error: object 'alert_ids' not found

head(results)
#> Error: object 'results' not found
# }
```
