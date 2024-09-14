#' List providers, description, year and link
#'
#' @description
#' This function allows you to list the list of available providers of the geoidep package.
#'
#' @param providers A string. List of available providers. For more details, use the get_providers function.
#' @returns A tibble object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' get_data_sources()
#' }
#' @export

get_data_sources <- \(provider = "all"){

  availabe.providers <- get_providers()[["provider"]] |> as.vector()

  if(providers == "all"){
    sources <- get_data() |> tidyr::as_tibble()

  } else if (provider %in% availabe.providers){
    sources <- get_data() |> dplyr::filter(provider %in% provider)

  } else {
    stop('Please select a valid provider from the available providers')

  }
  return(sources)
}
