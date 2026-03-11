# Download the available data from MTC

This function allows you to download the latest version of data
available on the MTC geoportal. For more information, you can visit the
following web page: [MTC Geoportal](https://geoportal.mtc.gob.pe/)

## Usage

``` r
get_mtc_data(
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
  information please use `get_data_sources(provider = "mtc")`. Defaults
  to NULL.

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
aerodromo <- get_mtc_data(layer = "aerodromos_2023" , show_progress = FALSE)
head(aerodromo)
#> Simple feature collection with 6 features and 14 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -76.4666 ymin: -16.34061 xmax: -71.57079 ymax: -2.796108
#> Geodetic CRS:  WGS 84
#>                                                       gml_id id codaero
#> 1 pe_mtc_018_aerodromos_dic23.fid--4bb7d1e9_19cde1c68e0_6b77  4 0321ANS
#> 2 pe_mtc_018_aerodromos_dic23.fid--4bb7d1e9_19cde1c68e0_6b78  5 1642ADS
#> 3 pe_mtc_018_aerodromos_dic23.fid--4bb7d1e9_19cde1c68e0_6b79  6 1643ADS
#> 4 pe_mtc_018_aerodromos_dic23.fid--4bb7d1e9_19cde1c68e0_6b7a  7 0411AQP
#> 5 pe_mtc_018_aerodromos_dic23.fid--4bb7d1e9_19cde1c68e0_6b7b  8 2532ATY
#> 6 pe_mtc_018_aerodromos_dic23.fid--4bb7d1e9_19cde1c68e0_6b7c  9 0521AYP
#>                       tipo                      nombre
#> 1               Aeropuerto                 Andahuaylas
#> 2                Aeródromo                      Andoas
#> 3 Helipuerto de superficie                      Andoas
#> 4 Aeropuerto Internacional    Alfredo Rodríguez Ballon
#> 5                Aeródromo                     Atalaya
#> 6               Aeropuerto Crnl. FAP. Alfredo Mendivil
#>                                               label iddpto   feccorte
#> 1                            Aeropuerto Andahuaylas     03 31/12/2023
#> 2                                  Aeródromo Andoas     16 31/12/2023
#> 3                                 Helipuerto Andoas     16 31/12/2023
#> 4 Aeropuerto Internacional Alfredo Rodríguez Ballon     04 31/12/2023
#> 5                                 Aeródromo Atalaya     25 31/12/2023
#> 6            Aeropuerto Crnl. FAP. Alfredo Mendivil     05 31/12/2023
#>                               administ          jerarquia
#> 1                          CORPAC S.A.           Nacional
#> 2 Pacific Stratus Energy del Perú S.A. No aplica privados
#> 3 Pacific Stratus Energy del Perú S.A. No aplica privados
#> 4    Aeropuertos Andinos del Perú S.A.           Nacional
#> 5                          CORPAC S.A.           Regional
#> 6    Aeropuertos Andinos del Perú S.A.           Nacional
#>                               titular    estado        lat       lon
#> 1 Pública (Concesionada-No entregada) Operativo -13.708819 -73.35156
#> 2                             Privada Operativo  -2.796108 -76.46660
#> 3                             Privada Operativo  -2.799990 -76.45873
#> 4              Pública (Concesionada) Operativo -16.340611 -71.57079
#> 5                             Pública Operativo -10.728572 -73.76589
#> 6              Pública (Concesionada) Operativo -13.154836 -74.20442
#>                          geom
#> 1 POINT (-73.35156 -13.70882)
#> 2  POINT (-76.4666 -2.796108)
#> 3  POINT (-76.45873 -2.79999)
#> 4 POINT (-71.57079 -16.34061)
#> 5 POINT (-73.76589 -10.72857)
#> 6 POINT (-74.20442 -13.15484)
plot(st_geometry(aerodromo))

# }
```
