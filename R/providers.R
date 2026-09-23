#' Catalogue helpers: providers and data sources
#'
#' @description
#' List the providers and layers indexed in `inst/sources-idep/sources_geoidep.csv`.
#'
#' @name providers
NULL

#' List providers, description, year and link
#'
#' @description
#' List the available providers of the geoidep package.
#'
#' @param query A string. Default is NULL. Filter by provider name(s). For valid values use `get_providers()`.
#' @returns A tibble object.
#' @examples
#' \dontrun{
#' library(geoidep)
#' get_data_sources()
#' }
#' @export
get_data_sources <- \(query = NULL) {
  available_providers <- get_providers() |> dplyr::select(provider) |> dplyr::pull()

  if (is.null(query)) {
    sources <- get_data() |> tidyr::as_tibble()
  } else if (all(query %in% available_providers)) {
    sources <- get_data() |>
      tidyr::as_tibble() |>
      dplyr::filter(provider %in% query)
  } else {
    cli::cli_abort(c(
      "Invalid {.arg query}.",
      "x" = "You supplied: {.val {query}}",
      "i" = "Available providers: {.val {available_providers}}"
    ))
  }

  return(sources)
}

#' List resources and count layers of IDEP
#'
#' @description Summary of providers.
#' @param query Character. Default is NULL (only `NULL` is valid).
#' @returns A tibble with columns `provider` and `layer_count`.
#' @examples
#' \dontrun{
#' library(geoidep)
#' get_providers()
#' }
#' @export
get_providers <- \(query = NULL){
  if (!is.null(query)) {
    cli::cli_abort("Please, only {.code NULL} is valid for {.arg query}.")
  }
  providers_count <- get_data() |>
    subset(select = "provider") |>
    table() |>
    as.data.frame() |>
    tidyr::as_tibble()
  names(providers_count) <- c("provider", "layer_count")
  return(providers_count)
}
