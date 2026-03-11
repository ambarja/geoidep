# Download INEI departmental boundaries

This function allows you to download the latest version of the
**geometry** and **ubigeos** corresponding to the **official political
division** of the departament boundaries of Peru. For more information,
you can visit the following page [INEI Spatial Data
Portal](https://ide.inei.gob.pe/).

## Usage

``` r
get_departaments(dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60)
```

## Arguments

- dsn:

  Character. Path to the output `.gpkg` file or a directory where the
  file will be saved. If a directory is provided, the file will be saved
  as `DEPARTAMENTO.gpkg` inside it. If `NULL`, a temporary file will be
  created. If the path contains multiple subdirectories, they will be
  created automatically if they do not exist.

- show_progress:

  Logical. Suppress bar progress.

- quiet:

  Logical. Suppress info message.

- timeout:

  Seconds. Number of seconds to wait for a response until giving up.
  Cannot be less than 1 ms. Default is 60.

## Value

An sf or tibble object.

## Examples

``` r
# \donttest{
library(geoidep)
dep <- get_departaments(show_progress = FALSE)
head(dep)
#> Simple feature collection with 6 features and 3 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -79.45857 ymin: -17.28501 xmax: -70.80408 ymax: -2.986125
#> Geodetic CRS:  WGS 84
#>   ccdd   nombdep                     fuente                           geom
#> 1   01  AMAZONAS V Censo Nacional Economico MULTIPOLYGON (((-77.81399 -...
#> 2   02    ANCASH V Censo Nacional Economico MULTIPOLYGON (((-77.64697 -...
#> 3   03  APURIMAC V Censo Nacional Economico MULTIPOLYGON (((-73.74655 -...
#> 4   04  AREQUIPA V Censo Nacional Economico MULTIPOLYGON (((-71.98109 -...
#> 5   05  AYACUCHO V Censo Nacional Economico MULTIPOLYGON (((-74.34843 -...
#> 6   06 CAJAMARCA V Censo Nacional Economico MULTIPOLYGON (((-78.70034 -...
# }
```
