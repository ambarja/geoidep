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
#> Reading layer `file1f0e7f49284d' from data source 
#>   `/tmp/RtmpH6aCmb/file1f0e7f49284d.geojson' using driver `GeoJSON'
#> Simple feature collection with 55 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -81.28606 ymin: -17.86464 xmax: -70.21046 ymax: -4.57511
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -74.90163 ymin: -17.86464 xmax: -70.61704 ymax: -15.19325
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 14798861 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 14798862 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 14798863 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 14798864 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 14798865 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 14798866 Servicio Nacional Forestal y de Fauna Silvestre       
#>                FECREG
#> 1 2026-03-11 05:00:00
#> 2 2026-03-11 05:00:00
#> 3 2026-03-11 05:00:00
#> 4 2026-03-11 05:00:00
#> 5 2026-03-11 05:00:00
#> 6 2026-03-11 05:00:00
#>                                                                                        OBSERV
#> 1 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 2 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 3 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 4 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 5 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 6 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#>   ZONUTM ORIGEN   NOMDEP         NOMPRO   NOMDIS   CAPITAL               FECHA
#> 1     19      2    TACNA          TACNA     SAMA LAS YARAS 2026-03-10 05:00:00
#> 2     19      2 MOQUEGUA            ILO      ILO       ILO 2026-03-11 05:00:00
#> 3     19      2 MOQUEGUA MARISCAL NIETO MOQUEGUA  MOQUEGUA 2026-03-10 05:00:00
#> 4     19      2 AREQUIPA          ISLAY MOLLENDO  MOLLENDO 2026-03-11 05:00:00
#> 5     18      2 AREQUIPA       CASTILLA    APLAO     APLAO 2026-03-11 05:00:00
#> 6     18      2 AREQUIPA       CARAVELI    LOMAS     LOMAS 2026-03-11 05:00:00
#>       HORA CATEG NOMCATEG   LATITUD  LONGITUD   COORES  COORNO created_user
#> 1 14:08:00    30          -17.86464 -70.61704 328667.2 8024048       USUFMS
#> 2 00:46:00    30          -17.77728 -71.18802 268035.2 8033102       USUFMS
#> 3 01:05:00    30          -17.29446 -71.14857 271615.0 8086596       USUFMS
#> 4 00:46:00    30          -17.03881 -71.97790 182969.0 8113736       USUFMS
#> 5 00:46:00    30          -16.10023 -72.62702 753823.7 8218519       USUFMS
#> 6 00:46:00    30          -15.19325 -74.90163 510566.0 8320297       USUFMS
#>          created_date last_edited_user    last_edited_date             TIPCOB
#> 1 2026-03-12 02:10:40           USUFMS 2026-03-12 02:10:40 Cobertura Forestal
#> 2 2026-03-12 02:10:40           USUFMS 2026-03-12 02:10:40 Cobertura Forestal
#> 3 2026-03-12 02:10:40           USUFMS 2026-03-12 02:10:40 Cobertura Forestal
#> 4 2026-03-12 02:10:40           USUFMS 2026-03-12 02:10:40 Cobertura Agrícola
#> 5 2026-03-12 02:10:40           USUFMS 2026-03-12 02:10:40 Cobertura Forestal
#> 6 2026-03-12 02:10:40           USUFMS 2026-03-12 02:10:40 Cobertura Forestal
#>   SENSAT PELIGRO CATDEP CATPRO CATDIS                    geometry
#> 1      N       0     23   2301 230109 POINT (-70.61704 -17.86464)
#> 2    N21       0     18   1803 180301 POINT (-71.18802 -17.77728)
#> 3    N21       0     18   1801 180101 POINT (-71.14857 -17.29446)
#> 4    N21       0     04   0407 040701  POINT (-71.9779 -17.03881)
#> 5    N21       0     04   0404 040401 POINT (-72.62702 -16.10023)
#> 6    N21       0     04   0403 040311 POINT (-74.90163 -15.19325)
# }
```
