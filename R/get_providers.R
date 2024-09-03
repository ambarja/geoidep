#' List resources and count layers of IDEP
#'
#' @description
#' Summary of providers
#' @returns A sf or tibble object.
#' @examples
#' \donttest{
#' library(geoidep)
#' dep <- get_departaments(show_progress = FALSE)
#' head(dep)
#' }
#' @export

get_providers <- function(){
  providers_count <- get_data_sources() |>
    subset(select = "provider") |>
    table() |>
    as.data.frame() |>
    tidyr::as_tibble()
  names(providers_count) <- c("provider", "layer_count")
  return(providers_count)
}
