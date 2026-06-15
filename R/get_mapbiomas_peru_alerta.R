#' Download MapBiomas Alerta Peru deforestation alerts with spatial filtering
#'
#' @description
#' This function allows you to download the latest deforestation alerts detected by MapBiomas Alerta Peru
#' for a specific geographic area using an sf object (bounding box or polygon).
#' For more details, please visit: \href{https://alerta.mapbiomas.org/}{MapBiomas Alerta Platform}
#'
#' @param region An sf object specifying the area of interest (must be in EPSG:4326 - WGS 84).
#' @param from Character. Start date for filtering, in \code{"YYYY-MM-DD"} format (e.g. \code{"2024-01-01"}).
#' If \code{NULL} (default), no lower bound is applied.
#' @param to Character. End date for filtering, in \code{"YYYY-MM-DD"} format (e.g. \code{"2024-12-31"}).
#' If \code{NULL} (default), no upper bound is applied.
#' @param dsn Character. Output filename with spatial format. If missing, a temporary GeoJSON file is created.
#' @param method A character string specifying the spatial predicate used to filter
#'   the downloaded alerts against the \code{region}. Available options are:
#'   \itemize{
#'     \item \code{"intersects"} (Default): Returns alerts that touch, cross, or
#'           are inside the region. This is the safest option to avoid losing edge alerts.
#'     \item \code{"within"}: Returns only alerts that are 100\% completely contained
#'           inside the region boundary.
#'     \item \code{"contains"}: Returns alerts that completely contain the region
#'           (useful if the region is a point or a very small plot).
#'     \item \code{"crosses"}: Returns alerts that cut or cross the region boundary
#'           (ideal if the region is a linear feature like a road or river).
#'     \item \code{"touches"}: Returns alerts that share a common boundary with the
#'           region but do not penetrate its interior.
#'   }
#' @param show_progress Logical. If TRUE, shows a progress bar during download.
#' @param quiet Logical. If TRUE, suppresses messages from sf::st_read().
#' @param timeout Numeric. Seconds to wait for the server response (default 60).
#'
#' @returns An sf object containing MapBiomas Alerta geometries with alert attributes and image URLs.
#'   The returned object includes the following key columns:
#'   \itemize{
#'     \item \bold{id}: Unique identifier for each alert
#'     \item \bold{geometry}: Alert polygon geometry
#'     \item \bold{before_image_url}: URL to before deforestation image (Google Cloud Storage)
#'     \item \bold{after_image_url}: URL to after deforestation image (Google Cloud Storage)
#'     \item Other alert attributes from MapBiomas
#'   }
#'
#' @details
#' The function uses the MapBiomas Alerta to query deforestation alerts
#' within the geographic extent of the provided region. The bounding box of the region is used
#' to spatially filter the data. Column names are automatically normalized to lowercase.
#'
#' Image URLs are automatically generated from the alert \bold{id} field and point to before/after
#' satellite imagery stored in public Google Cloud Storage buckets. Users can access these images
#' directly or download them programmatically if needed.
#'
#' @export
get_mapbiomas_peru_alerta <- \(region = NULL, from = NULL, to = NULL, dsn = NULL, method = 'within', show_progress = TRUE,
                                      quiet = TRUE, timeout = 60) {

  # Definir URL del servicio WFS
  primary_link <- get_mapbiomas_link("dashboard_alerts")

  # Configurar archivo de destino
  is_temp_file <- is.null(dsn)
  if (is_temp_file) {
    dsn <- tempfile(fileext = ".gpkg")
  } else {
    dsn <- paste0(getwd(),dsn)
  }

  # Validar región y extraer bounding box
  if (is.null(region)) {
    cli::cli_abort("Parameter {.strong region} is required. Please provide an sf object with the area of interest.")
  }

  # Validar CRS
  if (sf::st_crs(region)$epsg != 4326) {
    cli::cli_abort("The {.strong region} must be in CRS: EPSG 4326 (WGS 84).")
  }

  # Extraer bounding box
  bbox <- sf::st_bbox(region)

  bbox_str <- paste(
    format(as.numeric(bbox["ymin"]), scientific = FALSE),
    format(as.numeric(bbox["xmin"]), scientific = FALSE),
    format(as.numeric(bbox["ymax"]), scientific = FALSE),
    format(as.numeric(bbox["xmax"]), scientific = FALSE),
    "urn:ogc:def:crs:EPSG::4326",
    sep = ","
  )

  # Construir la consulta con httr2
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
    httr2::req_options(ssl_verifypeer = FALSE)

  # Activar barra de progreso si es solicitado
  if (isTRUE(show_progress)) {
    req <- req |> httr2::req_progress()
  }

  resp <- tryCatch({
    httr2::req_perform(req)
  }, error = function(e) {
    cli::cli_abort("Error during download: {conditionMessage(e)}")
  })

  suppressMessages(sf::sf_use_s2(use_s2 = FALSE))
  spatial_formats <- httr2::resp_body_string(resp = resp) |>
    geojsonio::geojson_sf() |>
    dplyr::select(-bbox) |>
    sf::st_transform(crs = 4326)|>
    sf::st_make_valid()

  # Filtro por fechas
  from_date <- validate_date(from, "from")
  to_date   <- validate_date(to, "to")

  if (!is.null(from_date) && !is.null(to_date) && from_date > to_date) {
    cli::cli_abort(c(
      "{.arg from} must be earlier than or equal to {.arg to}.",
      "x" = "from = {.val {from}}, to = {.val {to}}"
    ))
  }

  if (is.null(from_date) && is.null(to_date)) {
    spatial_formats
  } else {
    spatial_formats <- spatial_formats |>
      dplyr::filter(
        if (!is.null(from_date)) as.Date(detected_at) >= from_date else TRUE,
        if (!is.null(to_date)) as.Date(detected_at) <= to_date else TRUE
      )
    spatial_formats
  }

  # Filtro por métodos
  spatial_fn <- switch(method,
                       "within"     = sf::st_within,
                       "intersects" = sf::st_intersects,
                       "contains"   = sf::st_contains,
                       "crosses"    = sf::st_crosses,
                       "touches"    = sf::st_touches,
                       stop("Invalid spatial method specified.") # Alerta por si ingresan algo raro
  )

  # Aplicar el filtro seleccionado
  spatial_info <- spatial_formats[spatial_fn(spatial_formats, region, sparse = FALSE), ]
  sf::st_write(spatial_info, dsn = dsn, delete_dsn = TRUE, quiet = TRUE)

  # Leer datos espaciales de manera limpia
  sf_data <- tryCatch({
    sf::st_read(dsn, quiet = quiet)
  }, error = function(e) {
    if (is_temp_file) unlink(dsn)
    cli::cli_abort("Error to reading the download GeoJSON file: {conditionMessage(e)}")
  })

  if (is_temp_file) {
    unlink(dsn)
  }

  if (nrow(sf_data) == 0) {
    cli::cli_warn("No MapBiomas alerts found in the specified region.")
    return(sf_data)
  }

  # Normalizar columnas a minúsculas
  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  if (length(non_geom_idx) > 0) {
    names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])
  }

  # URLs dinámicas de Google Cloud Storage
  if ("id" %in% names(sf_data)) {
    sf_data <- sf_data |>
      dplyr::mutate(
        before_image_url = glue::glue("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{id}/before_deforestation.png"),
        after_image_url = glue::glue("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{id}/after_deforestation.png")
      )
  } else {
    cli::cli_warn("Column 'id' not found in the data. Image URLs were not added.")
  }

  return(sf_data)
}
