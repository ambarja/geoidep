#' Discrete fill scale for MapBiomas Peru LULC classes
#'
#' @description
#' A \code{ggplot2} discrete fill scale that applies the official MapBiomas
#' Peru Collection 3 color palette to a classified \code{SpatRaster} (as a
#' factor), for use with \code{tidyterra::geom_spatraster()}.
#'
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
#' lulc_2024 <- get_mapbiomas_peru_lulc(year = 2024, crop_to = lima)
#'
#' ggplot() +
#'   geom_spatraster(data = as.factor(lulc_2024)) +
#'   scale_fill_mapbiomas_peru_d(lang = "es") +
#'   theme_minimal() +
#'   labs(fill = "Cobertura/Uso", title = "MapBiomas Perú 2024")
#' }
#' @export
scale_fill_mapbiomas_peru_d <- function(..., lang = c("en", "es"), na.translate = FALSE) {
  lang <- match.arg(lang)
  label_col <- if (lang == "en") "class_en" else "class_es"

  legend <- get_mapbiomas_peru_legend()

  pal  <- setNames(legend$hex, legend$id)
  lbls <- setNames(legend[[label_col]], legend$id)

  ggplot2::scale_fill_manual(
    values = pal,
    labels = function(x) lbls[as.character(x)],
    na.translate = na.translate,
    ...
  )
}
