# Download INEI province boundaries

This function allows you to download the latest version of the
**geometry** and **ubigeos** corresponding to the **official political
division** of the province boundaries of Peru. For more information, you
can visit the following page [INEI Spatial Data
Portal](https://ide.inei.gob.pe/).

## Usage

``` r
get_provinces(dsn = NULL, show_progress = TRUE, quiet = TRUE, timeout = 60)
```

## Arguments

- dsn:

  Character. Path to the output `.gpkg` file or a directory where the
  file will be saved. If a directory is provided, the file will be saved
  as `PROVINCIA.gpkg` inside it. If `NULL`, a temporary file will be
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
prov <- get_provinces(show_progress = FALSE)
head(prov)
#> Simple feature collection with 6 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -78.71089 ymin: -6.986759 xmax: -77.1323 ymax: -2.986125
#> Geodetic CRS:  WGS 84
#>   ccdd ccpp             nombprov                     fuente  nombdep
#> 1   01   01          CHACHAPOYAS V Censo Nacional Economico AMAZONAS
#> 2   01   02                BAGUA V Censo Nacional Economico AMAZONAS
#> 3   01   03              BONGARA V Censo Nacional Economico AMAZONAS
#> 4   01   04         CONDORCANQUI V Censo Nacional Economico AMAZONAS
#> 5   01   05                 LUYA V Censo Nacional Economico AMAZONAS
#> 6   01   06 RODRIGUEZ DE MENDOZA V Censo Nacional Economico AMAZONAS
#>                             geom
#> 1 MULTIPOLYGON (((-77.72614 -...
#> 2 MULTIPOLYGON (((-78.61909 -...
#> 3 MULTIPOLYGON (((-77.72759 -...
#> 4 MULTIPOLYGON (((-77.81399 -...
#> 5 MULTIPOLYGON (((-78.13023 -...
#> 6 MULTIPOLYGON (((-77.44452 -...
# }
```
