# Download information on the latest deforestation alerts detected by Geobosque

This function allows you to download deforestation alert information
detected by Geobosque for any polygon located in Peru. For more details,
please visit the following website: [Geobosque
Platform](https://geobosques.minam.gob.pe)

## Usage

``` r
get_early_warning(region, sf = TRUE, show_progress = TRUE)
```

## Arguments

- region:

  A string Specifies the unique geographical code of interest.

- sf:

  Logical. Indicates whether to return the data as an `sf` object.

- show_progress:

  Logical. If TRUE, shows a progress bar during download.

## Value

A tibble or sf object, depending on the value of `sf`.

## Examples

``` r
# \donttest{
library(geoidep)
loreto <- get_departaments(show_progress = FALSE) |> subset(nombdep == "LORETO")
warning_point <- get_early_warning(region = loreto, sf = TRUE, show_progress = FALSE)
head(warning_point)
#> Simple feature collection with 6 features and 1 field
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -76.02536 ymin: -2.711665 xmax: -75.99904 ymax: -2.70054
#> Geodetic CRS:  WGS 84
#> # A tibble: 6 × 2
#>   descrip                     geometry
#>   <chr>                    <POINT [°]>
#> 1 Warning points  (-76.01695 -2.70054)
#> 2 Warning points (-76.02536 -2.706781)
#> 3 Warning points (-76.02455 -2.709223)
#> 4 Warning points  (-76.01614 -2.71058)
#> 5 Warning points (-75.99904 -2.711665)
#> 6 Warning points (-76.01641 -2.700811)
# }
```
