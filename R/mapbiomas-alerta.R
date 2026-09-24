#' Download MapBiomas Alerta Peru deforestation alerts with spatial filtering
#'
#' @description
#' Download the latest deforestation alerts detected by MapBiomas Alerta Peru
#' for a specific geographic area using an sf object (bounding box or polygon).
#' For more details, please visit: \href{https://alerta.mapbiomas.org/}{MapBiomas Alerta Platform}
#'
#' @param region An sf object specifying the area of interest (must be in EPSG:4326 - WGS 84).
#' @param from Character. Start date in `"YYYY-MM-DD"` format. If `NULL`, no lower bound.
#' @param to Character. End date in `"YYYY-MM-DD"` format. If `NULL`, no upper bound.
#' @param dsn Character. Output filename. If missing, a temporary GeoJSON file is created.
#' @param method Character. Spatial predicate used to filter the downloaded alerts against `region`:
#'   `"intersects"` (safest default is `"within"` for backward compatibility), `"within"`, `"contains"`, `"crosses"`, `"touches"`.
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @param quiet Logical. Suppress messages from `sf::st_read()`. Default `TRUE`.
#' @param timeout Numeric. Seconds to wait for the server response (default 60).
#' @returns An sf object with alert geometries, attributes and image URLs.
#' @details
#' The bounding box of `region` is used to query the WFS service. Image URLs
#' are generated from the alert `id` and point to public Google Cloud Storage buckets.
#' Column names are normalised to lowercase.
#' @export
get_mapbiomas_peru_alerta <- \(region = NULL, from = NULL, to = NULL, dsn = NULL, method = 'within', show_progress = TRUE,
                                      quiet = TRUE, timeout = 60) {
  primary_link <- get_mapbiomas_link("dashboard_alerts")

  is_temp_file <- is.null(dsn)
  if (is_temp_file) {
    dsn <- tempfile(fileext = ".gpkg")
  }

  if (is.null(region)) {
    cli::cli_abort("Parameter {.strong region} is required. Please provide an sf object with the area of interest.")
  }

  if (sf::st_crs(region)$epsg != 4326) {
    cli::cli_abort("The {.strong region} must be in CRS: EPSG 4326 (WGS 84).")
  }

  bbox <- sf::st_bbox(region)
  bbox_str <- paste(
    format(as.numeric(bbox["ymin"]), scientific = FALSE),
    format(as.numeric(bbox["xmin"]), scientific = FALSE),
    format(as.numeric(bbox["ymax"]), scientific = FALSE),
    format(as.numeric(bbox["xmax"]), scientific = FALSE),
    "urn:ogc:def:crs:EPSG::4326",
    sep = ","
  )

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Querying MapBiomas Alerta WFS", spinner = TRUE)
  }

  req <- httr2::request(primary_link) |>
    httr2::req_url_query(
      service = "WFS",
      version = "2.0.0",
      request = "GetFeature",
      typeName = "mapbiomas-alerta-peru:dashboard-alerts-staging",
      outputFormat = "application/json",
      bbox = bbox_str
    ) |>
    httr2::req_timeout(timeout) |>
    httr2::req_options(ssl_verifypeer = FALSE) |>
    httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)

  if (isTRUE(show_progress)) {
    req <- req |> httr2::req_progress()
  }

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      cli::cli_abort(c(
        "Unable to retrieve MapBiomas alerts.",
        "x" = "The MapBiomas service may be temporarily unavailable.",
        "i" = "Please try again later."
      ))
    }
  )

  suppressMessages(sf::sf_use_s2(use_s2 = FALSE))
  spatial_formats <- httr2::resp_body_string(resp = resp) |>
    sf::st_read(quiet = quiet, stringsAsFactors = FALSE) |>
    sf::st_transform(crs = 4326) |>
    sf::st_make_valid()

  if ("bbox" %in% names(spatial_formats)) {
    spatial_formats$bbox <- NULL
  }

  from_date <- validate_date(from, "from")
  to_date   <- validate_date(to, "to")

  if (!is.null(from_date) && !is.null(to_date) && from_date > to_date) {
    cli::cli_abort(c(
      "{.arg from} must be earlier than or equal to {.arg to}.",
      "x" = "from = {.val {from}}, to = {.val {to}}"
    ))
  }

  spatial_formats <- spatial_formats |>
    dplyr::mutate(detected_at = as.Date(detected_at))

  if (!is.null(from_date)) {
    spatial_formats <- spatial_formats |> dplyr::filter(detected_at >= from_date)
  }
  if (!is.null(to_date)) {
    spatial_formats <- spatial_formats |> dplyr::filter(detected_at <= to_date)
  }

  spatial_fn <- switch(method,
    "within"     = sf::st_within,
    "intersects" = sf::st_intersects,
    "contains"   = sf::st_contains,
    "crosses"    = sf::st_crosses,
    "touches"    = sf::st_touches,
    cli::cli_abort("Invalid {.arg method}. Choose one of {.val within}, {.val intersects}, {.val contains}, {.val crosses}, {.val touches}.")
  )

  spatial_info <- spatial_formats[spatial_fn(spatial_formats, region, sparse = FALSE), ]
  sf::st_write(spatial_info, dsn = dsn, delete_dsn = TRUE, quiet = TRUE)

  sf_data <- tryCatch({
    sf::st_read(dsn, quiet = quiet)
  }, error = function(e) {
    if (is_temp_file) unlink(dsn)
    cli::cli_abort("Error to reading the download GeoJSON file: {conditionMessage(e)}")
  })

  if (is_temp_file) unlink(dsn)

  if (nrow(sf_data) == 0) {
    cli::cli_warn("No MapBiomas alerts found in the specified region.")
    return(sf_data)
  }

  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  if (length(non_geom_idx) > 0) {
    names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])
  }

  if ("id" %in% names(sf_data)) {
    sf_data <- sf_data |>
      dplyr::mutate(
        before_image_url = paste0("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/", id, "/before_deforestation.png"),
        after_image_url = paste0("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/", id, "/after_deforestation.png")
      )
  } else {
    cli::cli_warn("Column 'id' not found in the data. Image URLs were not added.")
  }

  return(sf_data)
}

#' Download before/after deforestation images from MapBiomas Alerta Peru
#'
#' @description
#' Download satellite imagery (before/after deforestation) for specific MapBiomas Alerta alerts
#' from public Google Cloud Storage buckets. Progress uses [cli][cli::cli_progress_bar()].
#'
#' @param alert_ids Character or numeric vector. Alert IDs to download images for.
#' @param download_dir Character. Directory where images will be saved. If NULL, a temporary directory is used.
#' @param image_type Character. Which images to download: "both" (default), "before", or "after".
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @param overwrite Logical. Overwrite existing files. Default `FALSE`.
#' @returns A tibble with columns `alert_id`, `image_type`, `url`, `local_path`, `status`, `error_message`.
#' @details
#' File names follow the pattern `alert_{id}_before_deforestation.png` and
#' `alert_{id}_after_deforestation.png`. Each image has a 120-second timeout.
#' @examples
#' \dontrun{
#' library(geoidep)
#' aoi <- get_departaments(show_progress = FALSE) |>
#'   subset(nombdep == "UCAYALI")
#' alerts <- get_mapbiomas_peru_alerta(region = aoi, show_progress = FALSE)
#' alert_ids <- alerts$id[1:5]
#' download_dir <- file.path(tempdir(), "mapbiomas_images")
#' results <- get_mapbiomas_alert_images(
#'   alert_ids = alert_ids,
#'   download_dir = download_dir,
#'   show_progress = FALSE
#' )
#' head(results)
#' }
#' @export
get_mapbiomas_alert_images <- \(alert_ids, download_dir = NULL,
                                  image_type = "both", show_progress = TRUE,
                                  overwrite = FALSE) {
  if (is.null(alert_ids) || length(alert_ids) == 0) {
    cli::cli_abort("Parameter {.strong alert_ids} cannot be empty.")
  }

  alert_ids <- as.character(alert_ids)

  if (is.null(download_dir)) {
    download_dir <- file.path(tempdir(), "mapbiomas_alerts_images")
  }
  if (!dir.exists(download_dir)) {
    dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)
  }

  if (!image_type %in% c("both", "before", "after")) {
    cli::cli_abort("Parameter {.strong image_type} must be 'both', 'before', or 'after'.")
  }

  types <- if (image_type == "both") c("before", "after") else image_type

  download_tasks <- expand.grid(
    alert_id = alert_ids,
    image_type = types,
    stringsAsFactors = FALSE
  )

  if (isTRUE(show_progress)) {
    cli::cli_progress_bar("Downloading MapBiomas images", total = nrow(download_tasks))
  }

  results <- vector("list", nrow(download_tasks))
  for (i in seq_len(nrow(download_tasks))) {
    alert_id <- download_tasks$alert_id[i]
    img_type <- download_tasks$image_type[i]

    url <- paste0("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/", alert_id, "/", img_type, "_deforestation.png")
    filename <- paste0("alert_", alert_id, "_", img_type, "_deforestation.png")
    local_path <- file.path(download_dir, filename)

    if (file.exists(local_path) && !isTRUE(overwrite)) {
      status <- "skipped"
      error_msg <- "File already exists"
    } else {
      resp <- tryCatch({
        httr2::request(url) |>
          httr2::req_timeout(120) |>
          httr2::req_options(ssl_verifypeer = FALSE) |>
          httr2::req_perform(path = local_path)
        list(status = "success", error = NA_character_)
      }, error = function(e) {
        list(status = "failed", error = conditionMessage(e))
      })
      status <- resp$status
      error_msg <- resp$error
    }

    results[[i]] <- data.frame(
      alert_id = alert_id,
      image_type = img_type,
      url = as.character(url),
      local_path = local_path,
      status = status,
      error_message = error_msg,
      stringsAsFactors = FALSE
    )

    if (isTRUE(show_progress)) cli::cli_progress_update()
  }

  if (isTRUE(show_progress)) cli::cli_progress_done()

  results_df <- do.call(rbind, results) |>
    dplyr::as_tibble() |>
    dplyr::mutate(error_message = ifelse(is.na(error_message), "", error_message))

  success_count <- sum(results_df$status == "success")
  failed_count <- sum(results_df$status == "failed")
  skipped_count <- sum(results_df$status == "skipped")

  cli::cli_inform(c(
    "Download summary: {success_count} ok, {failed_count} failed, {skipped_count} skipped."
  ))

  return(results_df)
}
