# Download the forest and loss information from Geobosque

Download the **ubigeos** corresponding to the official political
division of the district, province or region boundaries of Peru with
**forest and loss information**. For more information, visit [Geobosque
Platform](https://geobosques.minam.gob.pe).

## Usage

``` r
get_forest_loss_data(layer = NULL, ubigeo = NULL, show_progress = TRUE)
```

## Arguments

- layer:

  A string. One of `stock_bosque_perdida_distrito`,
  `stock_bosque_perdida_provincia`, `stock_bosque_perdida_departamento`.

- ubigeo:

  A string. Ubigeo code: 6 digits (distrito), 4 digits (provincia), 2
  digits (departamento).

- show_progress:

  Logical. Show cli progress. Default `TRUE`.

## Value

A tibble object.

## Details

Available layers:

- **stock_bosque_perdida_distrito:** forest stock/loss for a district.

- **stock_bosque_perdida_provincia:** forest stock/loss for a province.

- **stock_bosque_perdida_departamento:** forest stock/loss for a region.

The data come from the wet-forest (`bosque humedo`) loss series of the
current Geobosques API (years 2001-2025) and are returned with the
historical column layout (`anio`, `perdida`, `rango1`-`rango5`,
`ubigeo`).

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
geobosque <- get_forest_loss_data(
  layer = "stock_bosque_perdida_distrito",
  ubigeo = "010101",
  show_progress = FALSE)
head(geobosque)
} # }
```
