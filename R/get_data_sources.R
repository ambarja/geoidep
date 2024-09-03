#' List providers, description, year and link
#'
#' @description
#' Metadata information
#'
#' @returns A tibble object.
#' @examples
#' \donttest{
#' library(geoidep)
#' get_data_sources()
#' }
#' @export

get_data_sources <- function(){
  sources <- get_data() |>
    tidyr::as_tibble()
  return(sources)
}
