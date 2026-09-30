#' Download OEFA-PIFA geospatial layers with spatial filtering
#'
#' @description
#' Download any public layer from the environmental enforcement IDE of the
#' Environmental Assessment and Enforcement Agency - OEFA
#' (\href{https://sistemas.oefa.gob.pe/pifa/mfe/#/interoperabilidad}{https://sistemas.oefa.gob.pe/pifa/mfe/#/interoperabilidad}).
#' When `region` is supplied, its bounding box is used to query the WFS
#' service and the downloaded features are then filtered to those falling
#' inside `region`. When `region` is `NULL`, the whole layer is downloaded.
#'
#' @param region An sf object specifying the area of interest (must be in EPSG:4326 - WGS 84).
#'   If `NULL`, the full layer is downloaded.
#' @param layer A string. Layer key (e.g. `"derechos_mineros"`). Run
#'   `get_data_sources("Oefa")` to list the 68 available layers.
#' @param dsn Character. Output filename. If supplied, the result is written
#'   to this file. If missing, a temporary file is used internally.
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @param quiet Logical. Suppress messages from `sf::st_read()`. Default `TRUE`.
#' @param timeout Numeric. Seconds to wait for the server response (default 60).
#' @returns An sf object with the layer geometries and attributes.
#' @details
#' Column names are normalised to lowercase. The WFS 2.0.0 `bbox` filter
#' requires latitude/longitude axis order for EPSG:4326, which is handled
#' internally.
#' @examples
#' \dontrun{
#' library(geoidep)
#' get_data_sources("Oefa")
#'
#' # Full layer download (mining rights countrywide)
#' mining <- get_oefa_data(layer = "derechos_mineros", show_progress = FALSE)
#' head(mining)
#'
#' # Features inside a region of interest
#' lima <- sf::st_sf(geometry = sf::st_sfc(
#'   sf::st_bbox(c(xmin = -77.2, ymin = -12.6, xmax = -76.6, ymax = -11.7),
#'               crs = sf::st_crs(4326)) |>
#'     sf::st_as_sfc()
#' ))
#' mining_lima <- get_oefa_data(region = lima, layer = "derechos_mineros",
#'                               show_progress = FALSE)
#' nrow(mining_lima)
#' }
#' @export
get_oefa_data <- \(region = NULL, layer = NULL, dsn = NULL,
                  show_progress = TRUE, quiet = TRUE, timeout = 60) {
  base_url <- get_oefa_link(layer)

  url <- base_url
  if (!is.null(region)) {
    if (!inherits(region, "sf")) {
      cli::cli_abort(c(
        "Invalid {.arg region}.",
        "x" = "Expected an {.cls sf} object."
      ))
    }

    if (sf::st_crs(region)$epsg != 4326) {
      cli::cli_abort("The {.arg region} must be in CRS: EPSG 4326 (WGS 84).")
    }

    # WFS 2.0.0 + EPSG:4326 requires lat/lon axis order in bbox.
    bbox <- sf::st_bbox(region)
    bbox_str <- paste(
      format(as.numeric(bbox[["ymin"]]), scientific = FALSE),
      format(as.numeric(bbox[["xmin"]]), scientific = FALSE),
      format(as.numeric(bbox[["ymax"]]), scientific = FALSE),
      format(as.numeric(bbox[["xmax"]]), scientific = FALSE),
      "urn:ogc:def:crs:EPSG::4326",
      sep = ","
    )
    url <- paste0(base_url, "&bbox=", bbox_str)
  }

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Querying OEFA WFS", spinner = TRUE)
  }

  req <- httr2::request(url) |>
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
        "OEFA server is inactive.",
        "x" = "{conditionMessage(e)}",
        "i" = "The OEFA PIFA server may be temporarily down. Try again later."
      ))
    }
  )

  sf_data <- tryCatch(
    httr2::resp_body_string(resp = resp) |>
      sf::st_read(quiet = quiet, stringsAsFactors = FALSE) |>
      sf::st_transform(crs = 4326) |>
      sf::st_make_valid(),
    error = function(e) {
      cli::cli_abort(c(
        "OEFA server is inactive.",
        "x" = "The response could not be read as spatial data: {conditionMessage(e)}",
        "i" = "The OEFA PIFA server may be temporarily down. Try again later."
      ))
    }
  )

  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  if (length(non_geom_idx) > 0) {
    names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])
  }

  # Keep only the features falling inside the requested region
  if (!is.null(region) && nrow(sf_data) > 0L) {
    inside <- sf::st_intersects(
      sf_data,
      sf::st_union(sf::st_geometry(region)),
      sparse = FALSE
    )[, 1]
    sf_data <- sf_data[inside, , drop = FALSE]
  }

  if (nrow(sf_data) == 0L) {
    cli::cli_warn("No OEFA features found for the requested query; returning an empty object.")
  }

  if (!is.null(dsn)) {
    sf::st_write(sf_data, dsn = dsn, delete_dsn = TRUE, quiet = quiet)
  }

  return(sf_data)
}
