# Filter alert geometry by danger level

This function filters the `sf` object from Senamhi by alert level (e.g.,
1 to 4).

## Usage

``` r
senamhi_geometry_by_level(sf_data, level)
```

## Arguments

- sf_data:

  An sf object returned by
  [`senamhi_get_spatial_alerts()`](https://geografo.pe/geoidep/reference/senamhi_get_spatial_alerts.md).

- level:

  Numeric or character vector: values like 1, 2, 3, 4 or "Nivel 1", etc.

## Value

Filtered sf object.

## Examples

``` r
# \donttest{
senamhi_get_meteorological_table() |>
  senamhi_alert_by_number(295) |>
  senamhi_alerts_by_year(2024) |>
  senamhi_get_spatial_alerts(show_progress = FALSE) |>
  senamhi_geometry_by_level(3) |>
  plot()
#> Reading data from the website...
#> Data successfully uploaded.
#> Warning: plotting the first 10 out of 13 attributes; use max.plot = 13 to plot all

# }
```
