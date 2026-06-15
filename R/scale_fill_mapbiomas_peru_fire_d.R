#' Discrete fill scale for MapBiomas Peru Fire products
#'
#' @description
#' A \code{ggplot2} discrete fill scale that applies the official
#' MapBiomas Fuego Peru (Collection 1) color palette for a given sub-product
#' to a classified \code{SpatRaster} (as a factor), for use with
#' \code{tidyterra::geom_spatraster()}.
#'
#' @param product Character. One of the products listed in
#' \code{\link{get_mapbiomas_peru_fire_products}}.
#' @param lang Character. Language for the legend labels, either
#' \code{"en"} (default) or \code{"es"}.
#' @param na.translate Logical. Should \code{NA} values be displayed in the
#' legend? Default is \code{FALSE}.
#' @param ... Additional arguments passed to \code{\link[ggplot2]{scale_fill_manual}}.
#'
#' @returns A \code{ggplot2} discrete scale object.
#'
#' @examples
#' \donttest{
#' library(geoidep)
#' library(ggplot2)
#' library(tidyterra)
#'
#' lima <- get_departaments("LIMA")
#'
#' # Frecuencia de área quemada
#' freq <- get_mapbiomas_peru_fire(
#'   product = "frequency_burned",
#'   year = 2024,
#'   crop_to = lima
#' )
#'
#' ggplot() +
#'   geom_spatraster(data = as.factor(freq)) +
#'   scale_fill_mapbiomas_peru_fire_d("frequency_burned", lang = "es") +
#'   theme_minimal() +
#'   labs(fill = "N° de quemas", title = "Frecuencia de área quemada 2013-2024")
#'
#' # Año del último fuego
#' last_fire <- get_mapbiomas_peru_fire(
#'   product = "year_last_fire",
#'   year = 2024,
#'   crop_to = lima
#' )
#'
#' ggplot() +
#'   geom_spatraster(data = as.factor(last_fire)) +
#'   scale_fill_mapbiomas_peru_fire_d("year_last_fire", lang = "es") +
#'   theme_minimal() +
#'   labs(fill = "Año", title = "Año del último fuego")
#' }
#' @export
scale_fill_mapbiomas_peru_fire_d <- function(product, ..., lang = c("en", "es"), na.translate = FALSE) {
  lang <- match.arg(lang)
  label_col <- if (lang == "en") "class_en" else "class_es"

  legend <- get_mapbiomas_peru_fire_legend(product)

  pal  <- setNames(legend$hex, legend$id)
  lbls <- setNames(legend[[label_col]], legend$id)

  ggplot2::scale_fill_manual(
    values = pal,
    labels = function(x) lbls[as.character(x)],
    na.translate = na.translate,
    ...
  )
}
