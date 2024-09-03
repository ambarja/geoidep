#' List providers, description, year and link
#'
#' @description
#' Metadata information
#'
#' @returns A tibble object.
#' @examples
#' \donttest{
#' library(geoidep)
#' dep <- get_departaments(show_progress = FALSE)
#' head(dep)
#' }
#' @export

get_data_sources <- function(){
  sources <- get_data() |>
    tidyr::as_tibble()
  return(sources)
}
