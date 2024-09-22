#' List resources and count layers of IDEP
#'
#' @description
#' Summary of providers
#'
#' @param query Character. Default is NULL.
#' @returns An sf or tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' get_providers()
#' }
#' @export
get_providers <- \(query = NULL){

  if(is.null(query)){
    providers_count <- get_data() |>
      subset(select = "provider") |>
      table() |>
      as.data.frame() |>
      tidyr::as_tibble()
    names(providers_count) <- c("provider", "layer_count")

  } else {
    stop("Please, only NULL is valid")
  }
  return(providers_count)
}
