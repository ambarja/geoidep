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
#> Reading layer `file1f50543fa366' from data source 
#>   `/tmp/RtmpEawHVM/file1f50543fa366.geojson' using driver `GeoJSON'
#> Simple feature collection with 365 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -81.19237 ymin: -17.66986 xmax: -69.00619 ymax: -3.52722
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -75.00967 ymin: -16.59121 xmax: -69.84174 ymax: -14.98391
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15027632 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15027633 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15027634 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15027635 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15027636 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15027637 Servicio Nacional Forestal y de Fauna Silvestre       
#>                FECREG
#> 1 2026-06-15 05:00:00
#> 2 2026-06-15 05:00:00
#> 3 2026-06-15 05:00:00
#> 4 2026-06-15 05:00:00
#> 5 2026-06-15 05:00:00
#> 6 2026-06-15 05:00:00
#>                                                                                        OBSERV
#> 1 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 2 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 3 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 4 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 5 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 6 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#>   ZONUTM ORIGEN   NOMDEP                NOMPRO  NOMDIS CAPITAL
#> 1     19      2 MOQUEGUA GENERAL SANCHEZ CERRO PUQUINA PUQUINA
#> 2     19      2     PUNO              HUANCANE  TARACO  TARACO
#> 3     19      2     PUNO              HUANCANE  TARACO  TARACO
#> 4     18      2 AREQUIPA              LA UNION    TORO    TORO
#> 5     18      2 AREQUIPA              LA UNION    TORO    TORO
#> 6     18      2      ICA                 NASCA   NASCA   NASCA
#>                 FECHA     HORA CATEG                NOMCATEG   LATITUD
#> 1 2026-06-15 05:00:00 13:17:00    25               TALAMOLLE -16.59121
#> 2 2026-06-14 05:00:00 13:36:00    13                    RN05 -15.34127
#> 3 2026-06-14 05:00:00 13:36:00    13                    RN05 -15.34059
#> 4 2026-06-14 05:00:00 13:36:00     6 Subcuenca del Cotahuasi -15.33309
#> 5 2026-06-14 05:00:00 14:13:00     6 Subcuenca del Cotahuasi -15.33036
#> 6 2026-06-14 05:00:00 01:37:00    30                         -14.98391
#>    LONGITUD   COORES  COORNO created_user        created_date last_edited_user
#> 1 -71.23073 261994.5 8164343       USUFMS 2026-06-16 04:10:47           USUFMS
#> 2 -69.84551 409244.3 8303750       USUFMS 2026-06-16 04:10:47           USUFMS
#> 3 -69.84174 409648.7 8303827       USUFMS 2026-06-16 04:10:47           USUFMS
#> 4 -73.02268 712280.5 8303863       USUFMS 2026-06-16 04:10:47           USUFMS
#> 5 -73.01949 712625.9 8304162       USUFMS 2026-06-16 04:10:47           USUFMS
#> 6 -75.00967 498960.3 8343454       USUFMS 2026-06-16 04:10:47           USUFMS
#>      last_edited_date             TIPCOB SENSAT PELIGRO CATDEP CATPRO CATDIS
#> 1 2026-06-16 04:10:47 Cobertura Forestal    N21       0     18   1802 180208
#> 2 2026-06-16 04:10:47 Cobertura Forestal    N21       0     21   2106 210607
#> 3 2026-06-16 04:10:47 Cobertura Forestal    N21       0     21   2106 210607
#> 4 2026-06-16 04:10:47 Cobertura Forestal    N21       0     04   0408 040811
#> 5 2026-06-16 04:10:47 Cobertura Forestal      N       0     04   0408 040811
#> 6 2026-06-16 04:10:47 Cobertura Agrícola      N       0     11   1103 110301
#>                      geometry
#> 1 POINT (-71.23073 -16.59121)
#> 2 POINT (-69.84551 -15.34127)
#> 3 POINT (-69.84174 -15.34059)
#> 4 POINT (-73.02268 -15.33309)
#> 5 POINT (-73.01949 -15.33036)
#> 6 POINT (-75.00967 -14.98391)
# }
```
