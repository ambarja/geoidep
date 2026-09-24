#' Download seismic data from the Geophysical Institute of Peru (IGP)
#'
#' @description
#' Download the Peruvian seismic catalogs published by the Centro
#' Sismologico Nacional (CENSIS) of the Instituto Geofisico del Peru (IGP)
#' through the same endpoint used by the
#' \href{https://ultimosismo.igp.gob.pe/repositorio/datos-sismicos}{IGP seismic data repository}:
#' a `GET` request filtered by bounding box, magnitude and depth that returns
#' an XLSX file. The epicentres are returned as an `sf` POINT layer
#' (EPSG:4326) and, optionally, clipped to any user-supplied polygon with `sf`.
#' For more information, visit \href{https://www.igp.gob.pe/}{IGP}.
#'
#' @param catalog A string. One of `instrumental` (1960 to present) or
#'   `historic` (1471-1959).
#' @param start_date,end_date Strings (`YYYY-MM-DD`). Only used when
#'   `catalog = "instrumental"`; defaults to the last 30 days. Ignored when
#'   `catalog = "historic"` (the repository fixes the period to
#'   1471-01-01/1959-12-31).
#' @param min_magnitude,max_magnitude Numerics. Magnitude range filter.
#'   Default `4` to `10`.
#' @param min_depth,max_depth Numerics. Depth range filter in km.
#'   Default `0` to `900`.
#' @param polygon An `sf` object. Its bounding box is sent to the server to
#'   narrow the download, and only the epicentres falling inside the polygon
#'   are returned. Any CRS is accepted (reprojected internally to EPSG:4326).
#' @param dsn A string. Optional path where the raw XLSX file is saved.
#'   Default `NULL` (temporary file).
#' @param show_progress Logical. Show cli progress. Default `TRUE`.
#' @param timeout Numeric. Seconds to wait for the server response. The IGP
#'   service generates the XLSX on demand, so the default is `180`.
#' @returns An `sf` object (POINT, EPSG:4326). The `instrumental` catalog has
#'   columns `fecha_utc`, `hora_utc`, `latitud`, `longitud`,
#'   `profundidad_km`, `magnitud`; the `historic` catalog reports three
#'   magnitude scales (`magnitud_mb`, `magnitud_ms`, `magnitud_mw`).
#' @details
#' The XLSX response is parsed with base R only (`utils::unzip()` plus a small
#' internal reader), so no additional package is required.
#' Very wide queries (e.g. the full `historic` catalog with low magnitudes)
#' may exceed the server capacity (HTTP 502); narrow the filters and retry.
#' @examples
#' \dontrun{
#' library(geoidep)
#' sismos <- get_igp_seismic_data(
#'   catalog = "instrumental",
#'   start_date = "2026-08-24",
#'   end_date = "2026-09-24",
#'   min_magnitude = 4,
#'   show_progress = FALSE)
#' head(sismos)
#' }
#' @export
get_igp_seismic_data <- \(catalog = c("instrumental", "historic"),
                          start_date = NULL, end_date = NULL,
                          min_magnitude = 4, max_magnitude = 10,
                           min_depth = 0, max_depth = 900,
                           polygon = NULL, dsn = NULL,
                           show_progress = TRUE, timeout = 180) {
  catalog <- match.arg(catalog)
  tipo_catalogo <- switch(catalog,
    instrumental = "Instrumental",
    historic = "Historico"
  )

  if (catalog == "historic") {
    if (!is.null(start_date) || !is.null(end_date)) {
      cli::cli_inform(c(
        "i" = "The {.val historic} catalog covers 1471-01-01 to 1959-12-31; {.arg start_date} and {.arg end_date} are ignored."
      ))
    }
    fecha_inicio <- "1471-01-01"
    fecha_fin <- "1959-12-31"
  } else {
    if (is.null(start_date)) start_date <- as.character(Sys.Date() - 30)
    if (is.null(end_date)) end_date <- as.character(Sys.Date())
    fecha_inicio <- as.character(validate_date(start_date, "start_date"))
    fecha_fin <- as.character(validate_date(end_date, "end_date"))
    if (fecha_inicio > fecha_fin) {
      cli::cli_abort(c(
        "Invalid date range.",
        "x" = "{.arg start_date} ({.val {fecha_inicio}}) is after {.arg end_date} ({.val {fecha_fin}})."
      ))
    }
  }

  for (arg in c("min_magnitude", "max_magnitude", "min_depth", "max_depth")) {
    value <- get(arg)
    if (!is.numeric(value) || length(value) != 1L || is.na(value)) {
      cli::cli_abort(c(
        "Invalid {.arg {arg}} value.",
        "x" = "You supplied: {.val {value}}",
        "i" = "Expected a single numeric value."
      ))
    }
  }
  if (min_magnitude > max_magnitude) {
    cli::cli_abort("{.arg min_magnitude} must not exceed {.arg max_magnitude}.")
  }
  if (min_depth > max_depth) {
    cli::cli_abort("{.arg min_depth} must not exceed {.arg max_depth}.")
  }

  # Query window: whole Peru by default, or the polygon bounding box.
  # The final filter to the polygon itself happens after the download.
  query_box <- c(xmin = -87.382, ymin = -25.701, xmax = -65.624, ymax = -1.396)

  if (!is.null(polygon)) {
    if (!inherits(polygon, "sf")) {
      cli::cli_abort(c(
        "Invalid {.arg polygon}.",
        "x" = "Expected an {.cls sf} object."
      ))
    }
    polygon <- sf::st_transform(polygon, 4326)
    box <- sf::st_bbox(polygon)
    query_box <- c(xmin = unname(box[["xmin"]]), ymin = unname(box[["ymin"]]),
                   xmax = unname(box[["xmax"]]), ymax = unname(box[["ymax"]]))
    # Degenerate boxes (e.g. a point polygon) are widened so the server accepts them
    if (query_box[["xmin"]] >= query_box[["xmax"]]) {
      query_box[["xmin"]] <- query_box[["xmin"]] - 0.001
      query_box[["xmax"]] <- query_box[["xmax"]] + 0.001
    }
    if (query_box[["ymin"]] >= query_box[["ymax"]]) {
      query_box[["ymin"]] <- query_box[["ymin"]] - 0.001
      query_box[["ymax"]] <- query_box[["ymax"]] + 0.001
    }
  }

  url <- .get_layer_url("igp", "descargar_datos")

  if (isTRUE(show_progress)) {
    cli::cli_progress_step("Requesting IGP seismic data", spinner = TRUE)
  }

  if (is.null(dsn)) {
    dsn <- tempfile(fileext = ".xlsx")
  }

  req <- httr2::request(url) |>
    httr2::req_url_query(
      tipoCatalogo = tipo_catalogo,
      fechaInicio = fecha_inicio,
      fechaFin = fecha_fin,
      minimaMagnitud = as.character(min_magnitude),
      maximaMagnitud = as.character(max_magnitude),
      minimaProfundidad = as.character(min_depth),
      maximaProfundidad = as.character(max_depth),
      latitudNorte = as.character(query_box[4]),
      latitudSur = as.character(query_box[2]),
      longitudEste = as.character(query_box[3]),
      longitudOeste = as.character(query_box[1])
    ) |>
    httr2::req_timeout(timeout) |>
    httr2::req_retry(max_tries = 3, retry_on_failure = TRUE)

  if (isTRUE(show_progress)) {
    req <- req |> httr2::req_progress()
  }

  tryCatch(
    httr2::req_perform(req, path = dsn),
    error = function(e) {
      message <- conditionMessage(e)
      hint <- "The IGP service may be temporarily unavailable. Try again later."
      if (grepl("400", message)) {
        hint <- "The server rejected the filters; check the date, magnitude, depth and area values."
      } else if (grepl("502|503|504", message)) {
        hint <- "The server could not generate the file; narrow the filters (shorter period, smaller area, higher magnitude) and retry."
      }
      cli::cli_abort(c(
        "IGP service request failed.",
        "x" = message,
        "i" = hint
      ))
    }
  )

  expected_cols <- switch(catalog,
    instrumental = c("fecha_utc", "hora_utc", "latitud", "longitud", "profundidad_km", "magnitud"),
    historic = c("fecha_utc", "hora_utc", "latitud", "longitud", "profundidad_km", "magnitud_mb", "magnitud_ms", "magnitud_mw")
  )

  seismic <- tryCatch(
    .read_igp_xlsx(dsn),
    error = function(e) {
      cli::cli_abort(c(
        "The IGP response could not be read as XLSX.",
        "x" = conditionMessage(e)
      ))
    }
  )

  if (ncol(seismic) != length(expected_cols)) {
    cli::cli_abort(c(
      "Unexpected IGP response layout.",
      "x" = "Expected {length(expected_cols)} columns, got {ncol(seismic)}.",
      "i" = "The IGP repository may have changed its format; please report it."
    ))
  }
  names(seismic) <- expected_cols

  seismic <- seismic |>
    dplyr::mutate(
      fecha_utc = suppressWarnings(as.Date(fecha_utc)),
      dplyr::across(c(latitud, longitud, profundidad_km, dplyr::starts_with("magnitud")),
                    \(x) suppressWarnings(as.numeric(x)))
    )

  dropped <- sum(is.na(seismic$latitud) | is.na(seismic$longitud))
  if (dropped > 0) {
    cli::cli_warn(c(
      "!" = "{dropped} record{?s} without coordinates {?was/were} dropped."
    ))
    seismic <- seismic |> dplyr::filter(!is.na(latitud) & !is.na(longitud))
  }

  seismic <- seismic |>
    sf::st_as_sf(coords = c("longitud", "latitud"), crs = 4326, remove = FALSE) |>
    dplyr::arrange(fecha_utc)

  if (!is.null(polygon)) {
    keep <- lengths(sf::st_intersects(seismic, polygon)) > 0
    seismic <- seismic[keep, , drop = FALSE]
    if (nrow(seismic) == 0L) {
      cli::cli_warn(c(
        "!" = "No epicentres fall inside {.arg polygon}; returning an empty {.cls sf} object.",
        "i" = "Widen the filters or use a larger polygon."
      ))
    }
  }

  return(seismic)
}

# Minimal XLSX reader for the IGP repository files (base R only).
#
# The IGP generator stores every cell as a shared string, so no date-serial
# or style handling is needed; plain numeric cells and inline strings are
# supported as fallback.
.read_igp_xlsx <- \(path) {
  listing <- utils::unzip(path, list = TRUE)
  sheet <- grep("^xl/worksheets/sheet[0-9]+\\.xml$", listing$Name, value = TRUE)[1L]
  if (is.na(sheet)) {
    stop("No worksheet found inside the file.")
  }

  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
  files <- intersect(c(sheet, "xl/sharedStrings.xml"), listing$Name)
  utils::unzip(path, files = files, exdir = tmp)

  strings <- character(0)
  sst_file <- file.path(tmp, "xl/sharedStrings.xml")
  if (file.exists(sst_file)) {
    sst <- paste(readLines(sst_file, warn = FALSE, encoding = "UTF-8"), collapse = "")
    parts <- strsplit(sst, "</si>", fixed = TRUE)[[1L]]
    parts <- parts[grepl("<si[> ]", parts)]
    strings <- vapply(parts, function(p) {
      hits <- regmatches(p, gregexpr("<t[^>]*>.*?</t>", p, perl = TRUE))[[1L]]
      .xml_unescape(paste(gsub("^<t[^>]*>|</t>$", "", hits), collapse = ""))
    }, character(1L), USE.NAMES = FALSE)
  }

  xml <- paste(readLines(file.path(tmp, sheet), warn = FALSE, encoding = "UTF-8"),
               collapse = "")
  rows <- strsplit(xml, "</row>", fixed = TRUE)[[1L]]
  rows <- rows[grepl("<row[> ]", rows)]

  col_index <- function(letters) {
    idx <- 0L
    for (ch in strsplit(letters, "", fixed = TRUE)[[1L]]) {
      idx <- idx * 26L + match(ch, LETTERS)
    }
    idx
  }

  parsed <- lapply(rows, function(row) {
    hits <- regmatches(row,
      gregexpr("<c r=\"[A-Z]+[0-9]+\"[^>]*/>|<c r=\"[A-Z]+[0-9]+\"[^>]*>.*?</c>",
               row, perl = TRUE))[[1L]]
    lapply(hits, function(cell) {
      ref <- sub(".*r=\"([A-Z]+)([0-9]+)\".*", "\\1:\\2", cell)
      parts <- strsplit(ref, ":", fixed = TRUE)[[1L]]
      col <- col_index(parts[1L])
      row_n <- as.integer(parts[2L])
      value <- NA_character_
      if (grepl("t=\"s\"", cell, fixed = TRUE)) {
        idx <- as.integer(sub(".*<v>([0-9]+)</v>.*", "\\1", cell)) + 1L
        if (!is.na(idx) && idx >= 1L && idx <= length(strings)) {
          value <- strings[idx]
        }
      } else if (grepl("<v>", cell, fixed = TRUE)) {
        value <- sub(".*<v>(.*?)</v>.*", "\\1", cell, perl = TRUE)
      } else if (grepl("<is>", cell, fixed = TRUE)) {
        hits <- regmatches(cell, gregexpr("<t[^>]*>.*?</t>", cell, perl = TRUE))[[1L]]
        value <- .xml_unescape(paste(gsub("^<t[^>]*>|</t>$", "", hits), collapse = ""))
      }
      list(row = row_n, col = col, value = value)
    })
  })

  cells <- unlist(parsed, recursive = FALSE)
  if (length(cells) == 0L) {
    stop("The worksheet is empty.")
  }
  n_row <- max(vapply(cells, \(x) x$row, integer(1L)))
  n_col <- max(vapply(cells, \(x) x$col, integer(1L)))
  mat <- matrix(NA_character_, nrow = n_row, ncol = n_col)
  for (cell in cells) {
    mat[cell$row, cell$col] <- cell$value
  }

  out <- as.data.frame(mat, stringsAsFactors = FALSE)
  names(out) <- .xml_unescape(trimws(out[1L, ]))
  out <- out[-1L, , drop = FALSE]
  rownames(out) <- NULL
  out
}

.xml_unescape <- \(x) {
  x <- gsub("&lt;", "<", x, fixed = TRUE)
  x <- gsub("&gt;", ">", x, fixed = TRUE)
  x <- gsub("&quot;", "\"", x, fixed = TRUE)
  x <- gsub("&apos;", "'", x, fixed = TRUE)
  x <- gsub("&amp;", "&", x, fixed = TRUE)
  x
}
