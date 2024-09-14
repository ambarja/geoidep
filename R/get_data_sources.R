#' List providers, description, year and link
#'
#' @description
#' This function allows you to list the list of available providers of the geoidep package.
#'
#' @param query A string. Default is NULL. List of available providers. For more details, use the `get_providers` function.
#' @returns A tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' get_data_sources()
#' }
#' @export

get_data_sources <- \(query = NULL) {

  available_providers <- get_providers() |> dplyr::select(provider) |> as.vector()

  if (is.null(query)) {
    sources <- get_data() |>
      tidyr::as_tibble()

  } else if (all(query %in% available_providers)) {
    sources <- get_data() |>
      tidyr::as_tibble() |>
      dplyr::filter(provider %in% query)

  } else {
    stop("Please select valid providers from the available providers")
  }

  return(sources)
}
