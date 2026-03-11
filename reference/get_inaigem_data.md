# Download the available data from INAIGEM

This function allows you to download the latest version of data
available on the INAIGEM geoportal. For more information, you can visit
the following web page: [INAIGEM
Geoportal](https://geoportal.inaigem.gob.pe/)

## Usage

``` r
get_inaigem_data(
  layer = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- layer:

  Select only one from the list of available layers, for more
  information please use `get_data_sources(provider = "INAIGEM")`.
  Defaults to NULL.

- dsn:

  Character. Output filename with the **spatial format**. If missing, a
  temporary file is created.

- show_progress:

  Logical. Suppress bar progress.

- quiet:

  Logical. Suppress info message.

- timeout:

  Seconds. Number of seconds to wait for a response until giving up.
  Cannot be less than 1 ms. Default is 60.

## Value

An sf object.

## Examples

``` r
# \donttest{
library(geoidep)
library(sf)
glaciar <- get_inaigem_data(layer = "glaciares_1989" , show_progress = FALSE)
head(glaciar)
#> Simple feature collection with 6 features and 6 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -70.79637 ymin: -13.60624 xmax: -70.7372 ymax: -13.56705
#> Geodetic CRS:  WGS 84
#>   fid nomb_70 shape_leng cordillera  shape__area shape__length
#> 1   1          8426.4513   Carabaya 1.902752e-04   0.077164599
#> 2   2           532.8161   Carabaya 1.551516e-06   0.004855436
#> 3   3           860.0855   Carabaya 2.904320e-06   0.007824580
#> 4   4           578.4839   Carabaya 1.682193e-06   0.005273105
#> 5   5          1820.3381   Carabaya 1.606429e-05   0.016674543
#> 6   6          1995.2061   Carabaya 1.933081e-05   0.018262215
#>                         geometry
#> 1 MULTIPOLYGON (((-70.7685 -1...
#> 2 MULTIPOLYGON (((-70.78551 -...
#> 3 MULTIPOLYGON (((-70.79576 -...
#> 4 MULTIPOLYGON (((-70.79413 -...
#> 5 MULTIPOLYGON (((-70.74827 -...
#> 6 MULTIPOLYGON (((-70.74066 -...
plot(st_geometry(glaciar))

# }
```
