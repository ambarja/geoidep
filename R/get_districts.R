#' Download INEI district boundaries
#'
#' @description
#' This function allows you to download the latest version of the **geometry** and **ubigeos**
#' corresponding to the **official political division** of the district boundaries of Peru.
#' For more information, you can visit the following page \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @details
#' - `r lifecycle::badge("stable")`. This function is considered stable and its API is unlikely to change in future versions.
#' - If no values are provided for the `departamento`, `provincia`, or `distrito` parameters, the function
#' will download and return the complete dataset containing district boundaries for the entire country.
#'
#' @param departamento Character. Name of the level-1 administrative boundary (department) to query. The input is case-insensitive.
#' @param provincia Character. Name of the level-2 administrative boundary (province) to query. The input is case-insensitive.
#' @param distrito Character. Name of the level-3 administrative boundary (district) to query. The input is case-insensitive.
#' @param dsn Character. Path to the output \code{.gpkg} file or a directory where the file will be saved.
#' If a directory is provided, the file will be saved as \code{DISTRITO.gpkg} inside it.
#' If \code{NULL}, a temporary file will be created.
#' If the path contains multiple subdirectories, they will be created automatically if they do not exist.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#' @param timeout Seconds. Number of seconds to wait for a response until giving up. Cannot be less than 1 ms. Default is 60.
#'
#' @returns An sf object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' library(mapgl)
#' # Download all district boundaries (entire country)
#' dist <- get_districts(show_progress = FALSE)
#' head(dist)
#'
#' # Download all district boundaries for Lima
#' lima <-  get_districts(departamento = 'lima', provincia = 'lima',show_progress = FALSE)
#' head(lima)
#'
#' # Visualization
#' maplibre(bounds = lima) |>
#'   add_fill_layer(id = "lima", source = lima, fill_color = "blue", fill_opacity = 0.5)
#' }
#' @export
get_districts <- \(departamento = NULL, provincia = NULL, distrito = NULL,
                   dsn = NULL, timeout = 60, show_progress = TRUE, quiet = TRUE) {
  primary_link <- get_inei_link("distrito")

  if (is.null(dsn)) {
    dsn <- tempfile(pattern = "distrito", fileext = ".rar")
  } else {
    if (!dir.exists(dsn)) {
      dir.create(dsn, recursive = TRUE, showWarnings = FALSE)
    }
    dsn <- file.path(dsn, "distrito.rar")
  }

  rar.download <- tryCatch({
    if (isTRUE(show_progress)) {
      httr::GET(
        primary_link,
        config = c(
          httr::config(ssl_verifypeer = FALSE),
          httr::timeout(seconds = timeout)
        ),
        httr::write_disk(dsn, overwrite = TRUE),
        httr::progress()
      )
    } else {
      httr::GET(
        primary_link,
        config = c(
          httr::config(ssl_verifypeer = FALSE),
          httr::timeout(seconds = timeout)
        ),
        httr::write_disk(dsn, overwrite = TRUE)
      )
    }
  }, error = function(e) {
    stop("Error during download: ", conditionMessage(e))
  })

  if (httr::http_error(rar.download)) {
    stop("Error downloading the file. Check the URL or connection")
  }

  extract_dir <- file.path(tempdir(), paste0("geoidep_data_", "distrito"))
  dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
  archive::archive_extract(archive = dsn, dir = extract_dir)
  gpkg_files <- dplyr::first(list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE))

  if (length(gpkg_files) == 0) {
    stop("No .gpkg file was found after extraction in: ", extract_dir)
  }

  gpkg_file <- dplyr::first(gpkg_files)

  if (!file.exists(gpkg_file)) {
    stop("Extracted file does not exist: ", gpkg_file)
  }

  new_gpkg_file <- file.path(dirname(gpkg_file), tolower(basename(gpkg_file)))

  if (!file.rename(from = gpkg_file, to = new_gpkg_file)) {
    stop("Error renaming file from: ", gpkg_file, " to: ", new_gpkg_file)
  }

  if (file.exists(dsn)) {
    suppressMessages(invisible(file.remove(dsn)))
  }

  sf_data <- sf::st_read(new_gpkg_file, quiet = quiet)

  # Convert column names to lower case (except geometry)
  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])

  # New filter Applied by R users
  if (!is.null(departamento)) {
    sf_data <- sf_data[tolower(sf_data$nombdep) == tolower(departamento), ]
  }
  if (!is.null(provincia)) {
    sf_data <- sf_data[tolower(sf_data$nombprov) == tolower(provincia), ]
  }
  if (!is.null(distrito)) {
    sf_data <- sf_data[tolower(sf_data$nombdist) == tolower(distrito), ]
  }

  return(sf_data)
}
