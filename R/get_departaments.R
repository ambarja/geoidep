#' Download INEI departmental boundaries
#'
#' @description
#' This function allows you to download the latest version of the \bold{geometry} and \bold{ubigeos}
#' corresponding to the \bold{official political division} of the departament boundaries of Peru.
#' For more information, you can visit the following page \href{https://ide.inei.gob.pe/}{INEI Spatial Data Portal}.
#'
#' @param departamento Character. Name o names in a vector of the level-1 administrative boundary (department) to query. The input is case-insensitive.
#' @param dsn Character. Path to the output \code{.gpkg} file or a directory where the file will be saved.
#' If a directory is provided, the file will be saved as \code{departamento.gpkg} inside it.
#' If \code{NULL}, a temporary file will be created.
#' If the path contains multiple subdirectories, they will be created automatically if they do not exist.
#' @param show_progress Logical. Suppress bar progress.
#' @param quiet Logical. Suppress info message.
#' @param timeout Seconds. Number of seconds to wait for a response until giving up. Cannot be less than 1 ms. Default is 60.
#'
#' @returns An sf or tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' dep <- get_departaments(show_progress = FALSE)
#' head(dep)
#'
#' loreto <- get_departaments(departamento = "loreto",show_progress = FALSE)
#' head(loreto)
#'
#' ica_junin <- get_departaments(departamento = c("ica","junin"),show_progress = FALSE)
#' head(ica_junin)
#' }
#' @export

get_departaments <- \(
  departamento = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
  ) {

  primary_link <- get_inei_link("departamento")

  if (is.null(dsn)) {
    dsn_rar <-  tempfile(pattern = "departamento", fileext = ".rar")
  } else {
    if (!dir.exists(dsn)) {
      dir.create(dsn, recursive = TRUE, showWarnings = FALSE)
    }
    dsn_rar <- file.path(dsn, "departamento.rar")
  }

  rar.download <- tryCatch({
    if (isTRUE(show_progress)) {
      httr::GET(
        primary_link,
        config = c(
          httr::config(ssl_verifypeer = FALSE),
          httr::timeout(seconds = timeout)),
        httr::write_disk(dsn_rar, overwrite = TRUE),
        httr::progress()
      )
    } else {
      httr::GET(
        primary_link,
        config = c(
          httr::config(ssl_verifypeer = FALSE),
          httr::timeout(seconds = timeout)),
        httr::write_disk(dsn_rar, overwrite = TRUE)
      )
    }
  }, error = function(e) {
    cli::cli_abort(c(
      "Error during download.",
      "x" = "{conditionMessage(e)}"
    ))
  }
  )

  if (httr::http_error(rar.download)) {
    cli::cli_abort(c(
      "Download failed.",
      "x" = "Status code: {httr::status_code(rar.download)}",
      "i" = "Check the URL or your internet connection."
    ))
  }

  if(is.null(dsn)){
    extract_dir <- file.path(tempdir(), paste0("geoidep_data_","departamento"))
    dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
    archive::archive_extract(archive = dsn_rar, dir = extract_dir)
  } else {
    extract_dir <- gsub(".rar","",file.path(getwd(), dsn))
    dir.create(extract_dir, recursive = TRUE, showWarnings = FALSE)
    archive::archive_extract(archive = dsn_rar, dir = extract_dir)
  }

  gpkg_files <- dplyr::first(list.files(extract_dir, pattern = "\\.gpkg$", full.names = TRUE))

  if (length(gpkg_files) == 0) {
    cli::cli_abort(c(
      "No {.field .gpkg} file was found after extraction.",
      "x" = "Directory checked: {.path {extract_dir}}"
    ))
  }

  gpkg_file <- dplyr::first(gpkg_files)

  if (!file.exists(gpkg_file)) {
    cli::cli_abort(c(
      "Extracted file does not exist.",
      "x" = "Expected file: {.path {gpkg_file}}"
    ))
  }

  new_gpkg_file <- file.path(dirname(gpkg_file), tolower(basename(gpkg_file)))

  if (!file.rename(from = gpkg_file, to = new_gpkg_file)) {
    cli::cli_abort(c(
      "Failed to rename the extracted file.",
      "x" = "From: {.path {gpkg_file}}",
      "x" = "To: {.path {new_gpkg_file}}"
    ))
  }

  if (file.exists(dsn_rar)) {
    suppressMessages(invisible(file.remove(dsn_rar)))
  }

  sf_data <- sf::st_read(new_gpkg_file, quiet = quiet)
  non_geom_idx <- which(!grepl("^(geom|geometry)$", names(sf_data), ignore.case = TRUE))
  names(sf_data)[non_geom_idx] <- tolower(names(sf_data)[non_geom_idx])

  if (!is.null(departamento)) {
    name_departamento <- toupper(departamento)
    sf_data <- sf_data |> dplyr::filter(nombdep %in% name_departamento)
    sf::write_sf(obj = sf_data, dsn = new_gpkg_file, delete_dsn = TRUE)
  }

  return(sf_data)
}

