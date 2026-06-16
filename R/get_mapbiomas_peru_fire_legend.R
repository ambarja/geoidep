#' Get the MapBiomas Peru Fire legend for a given product
#'
#' @description
#' Returns a lookup table with the pixel value codes, English/Spanish class
#' names, and hexadecimal colors used by a given MapBiomas Fuego Peru
#' sub-product (Collection 1). Useful for building color scales (see
#' \code{\link{scale_fill_mapbiomas_peru_fire_d}}).
#'
#' @param product Character. One of the products listed in
#' \code{\link{get_mapbiomas_peru_fire_products}}.
#'
#' @returns A tibble with columns \code{id}, \code{class_en}, \code{class_es},
#' and \code{hex}.
#'
#' @details
#' \itemize{
#'   \item \code{annual_burned} and \code{accumulated_burned}: binary
#'   classification (\code{1 = "Burned area"}).
#'   \item \code{annual_burned_coverage} and \code{accumulated_burned_coverage}:
#'   share the LULC legend (see \code{get_mapbiomas_peru_legend}),
#'   since these products classify the burned pixels by land cover class.
#'   \item \code{monthly_burned}: pixel values \code{1-12} represent the
#'   month (January-December) in which the pixel burned.
#'   \item \code{frequency_burned}: pixel values \code{1-12} represent the
#'   number of times a pixel burned during the period (\code{12} = "12 or more times").
#'   \item \code{year_last_fire}: pixel values are the actual years (\code{2013-2024})
#'   of the most recent fire.
#'   \item \code{annual_burned_scar_size_range}: pixel values \code{1-5}
#'   represent burned scar size classes (from \code{< 25 ha} to \code{> 5000 ha}).
#' }
#'
#' @examples
#' library(geoidep)
#' get_mapbiomas_peru_fire_legend("frequency_burned")
#' @export
get_mapbiomas_peru_fire_legend <- function(product) {

  products <- get_mapbiomas_peru_fire_products()

  if (!product %in% products$product) {
    cli::cli_abort(c(
      "Invalid {.arg product} for MapBiomas Fuego Peru.",
      "x" = "You supplied: {.val {product}}",
      "i" = "Available products: {.val {products$product}}"
    ))
  }

  switch(product,

         annual_burned = ,
         accumulated_burned = tibble::tribble(
           ~id, ~class_en,     ~class_es,       ~hex,
           1,   "Burned area", "\u00c1rea quemada",  "#ff5340"
         ),

         annual_burned_coverage = ,
         accumulated_burned_coverage = get_mapbiomas_peru_legend(),

         monthly_burned = tibble::tribble(
           ~id, ~class_en,   ~class_es,   ~hex,
           1,  "January",    "Enero",     "#CC00FF",
           2,  "February",   "Febrero",   "#6600FF",
           3,  "March",      "Marzo",     "#0000FF",
           4,  "April",      "Abril",     "#00CCFF",
           5,  "May",        "Mayo",      "#00FFCC",
           6,  "June",       "Junio",     "#FFFF00",
           7,  "July",       "Julio",     "#FF9900",
           8,  "August",     "Agosto",    "#FF3300",
           9,  "September",  "Setiembre", "#CC0000",
           10, "October",    "Octubre",   "#00CC00",
           11, "November",   "Noviembre", "#009900",
           12, "December",   "Diciembre", "#66FF66"
         ),

         frequency_burned = tibble::tribble(
           ~id, ~class_en,           ~class_es,                  ~hex,
           1,  "Burned once",        "Quemado 1 vez",        "#FAF3CD",
           2,  "Burned twice",       "Quemado 2 veces",      "#F9E676",
           3,  "Burned 3 times",     "Quemado 3 veces",      "#F1CD38",
           4,  "Burned 4 times",     "Quemado 4 veces",      "#DDA71C",
           5,  "Burned 5 times",     "Quemado 5 veces",      "#C77E14",
           6,  "Burned 6 times",     "Quemado 6 veces",      "#B0540F",
           7,  "Burned 7 times",     "Quemado 7 veces",      "#992A0A",
           8,  "Burned 8 times",     "Quemado 8 veces",      "#7B1208",
           9,  "Burned 9 times",     "Quemado 9 veces",      "#5C0407",
           10, "Burned 10 times",    "Quemado 10 veces",     "#440508",
           11, "Burned 11 times",    "Quemado 11 veces",     "#260405",
           12, "Burned 12+ times",   "Quemado 12+ veces",    "#040101"
         ),

         year_last_fire = tibble::tribble(
           ~id,   ~class_en, ~class_es, ~hex,
           2013, "2013",     "2013",    "#010079",
           2014, "2014",     "2014",    "#00287F",
           2015, "2015",     "2015",    "#004D86",
           2016, "2016",     "2016",    "#07728F",
           2017, "2017",     "2017",    "#239B9C",
           2018, "2018",     "2018",    "#74B29A",
           2019, "2019",     "2019",    "#AD9963",
           2020, "2020",     "2020",    "#C25407",
           2021, "2021",     "2021",    "#AF2A13",
           2022, "2022",     "2022",    "#A01D1A",
           2023, "2023",     "2023",    "#911416",
           2024, "2024",     "2024",    "#810000"
         ),

         annual_burned_scar_size_range = tibble::tribble(
           ~id, ~class_en,      ~class_es,       ~hex,
           1,  "< 25 ha",       "< 25 ha",       "#D9B646",
           2,  "25 - 50 ha",    "25 - 50 ha",    "#E58B2F",
           3,  "50 - 500 ha",   "50 - 500 ha",   "#D46B27",
           4,  "500 - 5000 ha", "500 - 5000 ha", "#96352A",
           5,  "> 5000 ha",     "> 5000 ha",     "#2B110C"
         ),

         cli::cli_abort(c(
           "No legend is defined for product {.val {product}}.",
           "i" = "Available products: {.val {products$product}}"
         ))
  )
}
