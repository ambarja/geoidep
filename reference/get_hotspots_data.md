# Download available hot spot data from Serfor's Satellite Monitoring Unit

This function allows you to download the latest version of forest fire
data available from the Satellite Monitoring Unit of the National
Forestry and Wildlife Service of Peru. For more information, please
visit the following website: [Serfor
Platform](https://sniffs.serfor.gob.pe/monitoreo/sami/index.html)

## Usage

``` r
get_hotspots_data(dsn = NULL, show_progress = TRUE, quiet = FALSE)
```

## Arguments

- dsn:

  Character. Output filename with the **spatial format**. If missing, a
  temporary file is created.

- show_progress:

  Logical. Suppress bar progress.

- quiet:

  Logical. Suppress info message.

## Value

An sf object.

## Examples

``` r
# \donttest{
library(geoidep)
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
hot_spots <- get_hotspots_data(show_progress = FALSE)
#> Reading layer `file1f5065fba660' from data source 
#>   `/tmp/Rtmpuvdb7v/file1f5065fba660.geojson' using driver `GeoJSON'
#> Simple feature collection with 239 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -80.89928 ymin: -17.51561 xmax: -69.09373 ymax: -3.53332
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -71.84528 ymin: -17.51561 xmax: -69.22974 ymax: -16.5192
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15034844 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15034845 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15034846 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15034847 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15034848 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15034849 Servicio Nacional Forestal y de Fauna Silvestre       
#>                FECREG
#> 1 2026-06-17 05:00:00
#> 2 2026-06-17 05:00:00
#> 3 2026-06-17 05:00:00
#> 4 2026-06-17 05:00:00
#> 5 2026-06-17 05:00:00
#> 6 2026-06-17 05:00:00
#>                                                                                        OBSERV
#> 1 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 2 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 3 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 4 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 5 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 6 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#>   ZONUTM ORIGEN   NOMDEP         NOMPRO        NOMDIS  CAPITAL
#> 1     19      2    TACNA  JORGE BASADRE       ILABAYA  ILABAYA
#> 2     19      2 MOQUEGUA MARISCAL NIETO      MOQUEGUA MOQUEGUA
#> 3     19      2 AREQUIPA          ISLAY DEAN VALDIVIA LA CURVA
#> 4     19      2 AREQUIPA          ISLAY DEAN VALDIVIA LA CURVA
#> 5     19      2 AREQUIPA          ISLAY DEAN VALDIVIA LA CURVA
#> 6     19      2     PUNO       CHUCUITO        ZEPITA   ZEPITA
#>                 FECHA     HORA CATEG NOMCATEG   LATITUD  LONGITUD   COORES
#> 1 2026-06-16 05:00:00 12:58:00    30          -17.51561 -70.57429 332875.1
#> 2 2026-06-17 05:00:00 13:13:00    30          -17.17776 -71.11855 274665.7
#> 3 2026-06-16 05:00:00 13:34:00    30          -17.13727 -71.81108 200898.4
#> 4 2026-06-16 05:00:00 13:34:00    30          -17.13230 -71.84528 197248.9
#> 5 2026-06-16 05:00:00 12:58:00    30          -17.11487 -71.78090 204076.2
#> 6 2026-06-16 05:00:00 15:02:00    30          -16.51920 -69.22974 475484.2
#>    COORNO created_user        created_date last_edited_user    last_edited_date
#> 1 8062713       USUFMS 2026-06-18 03:11:07           USUFMS 2026-06-18 03:11:07
#> 2 8099549       USUFMS 2026-06-18 03:11:07           USUFMS 2026-06-18 03:11:07
#> 3 8103096       USUFMS 2026-06-18 03:11:07           USUFMS 2026-06-18 03:11:07
#> 4 8103593       USUFMS 2026-06-18 03:11:07           USUFMS 2026-06-18 03:11:07
#> 5 8105623       USUFMS 2026-06-18 03:11:07           USUFMS 2026-06-18 03:11:07
#> 6 8173618       USUFMS 2026-06-18 03:11:07           USUFMS 2026-06-18 03:11:07
#>               TIPCOB SENSAT PELIGRO CATDEP CATPRO CATDIS
#> 1 Cobertura Forestal    N21       0     23   2303 230302
#> 2 Cobertura Forestal      N       0     18   1801 180101
#> 3 Cobertura Agrícola      N       0     04   0407 040703
#> 4 Cobertura Agrícola      N       0     04   0407 040703
#> 5 Cobertura Agrícola    N21       0     04   0407 040703
#> 6 Cobertura Forestal      A       0     21   2104 210407
#>                      geometry
#> 1 POINT (-70.57429 -17.51561)
#> 2 POINT (-71.11855 -17.17776)
#> 3 POINT (-71.81108 -17.13727)
#> 4  POINT (-71.84528 -17.1323)
#> 5  POINT (-71.7809 -17.11487)
#> 6  POINT (-69.22974 -16.5192)
# }
```
