#' List resources and count layers of IDEP
#'
#' @description
#' Summary of providers
#' @param query description
#' @returns A sf or tibble object.
#' @examples
#' \donttest{
#' library(geoidep)
#' get_providers()
#' }
#' @export

get_providers <- function(query = "provider"){
  providers_count <- get_data_sources() |>
    subset(select = query) |>
    table() |>
    as.data.frame() |>
    tidyr::as_tibble()
  names(providers_count) <- c("provider", "layer_count")
  return(providers_count)
}
