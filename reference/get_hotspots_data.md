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
#> Reading layer `file1f396e1a56df' from data source 
#>   `/tmp/RtmpcVvIKR/file1f396e1a56df.geojson' using driver `GeoJSON'
#> Simple feature collection with 160 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -81.19237 ymin: -17.66986 xmax: -69.00619 ymax: -3.52901
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -75.00967 ymin: -15.34127 xmax: -69.15167 ymax: -14.43423
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15026684 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15026685 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15026686 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15026687 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15026688 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15026689 Servicio Nacional Forestal y de Fauna Silvestre       
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
#>   ZONUTM ORIGEN   NOMDEP   NOMPRO    NOMDIS   CAPITAL               FECHA
#> 1     19      2     PUNO HUANCANE    TARACO    TARACO 2026-06-14 05:00:00
#> 2     19      2     PUNO HUANCANE    TARACO    TARACO 2026-06-14 05:00:00
#> 3     18      2 AREQUIPA LA UNION      TORO      TORO 2026-06-14 05:00:00
#> 4     18      2 AREQUIPA LA UNION      TORO      TORO 2026-06-14 05:00:00
#> 5     18      2      ICA    NASCA     NASCA     NASCA 2026-06-14 05:00:00
#> 6     19      2     PUNO   SANDIA YANAHUAYA YANAHUAYA 2026-06-14 05:00:00
#>       HORA CATEG                NOMCATEG   LATITUD  LONGITUD   COORES  COORNO
#> 1 13:36:00    13                    RN05 -15.34127 -69.84551 409244.3 8303750
#> 2 13:36:00    13                    RN05 -15.34059 -69.84174 409648.7 8303827
#> 3 13:36:00     6 Subcuenca del Cotahuasi -15.33309 -73.02268 712280.5 8303863
#> 4 14:13:00     6 Subcuenca del Cotahuasi -15.33036 -73.01949 712625.9 8304162
#> 5 01:37:00    30                         -14.98391 -75.00967 498960.3 8343454
#> 6 12:49:00    30                         -14.43423 -69.15167 483652.2 8404244
#>   created_user        created_date last_edited_user    last_edited_date
#> 1       USUFMS 2026-06-16 00:09:29           USUFMS 2026-06-16 00:09:29
#> 2       USUFMS 2026-06-16 00:09:29           USUFMS 2026-06-16 00:09:29
#> 3       USUFMS 2026-06-16 00:09:29           USUFMS 2026-06-16 00:09:29
#> 4       USUFMS 2026-06-16 00:09:29           USUFMS 2026-06-16 00:09:29
#> 5       USUFMS 2026-06-16 00:09:29           USUFMS 2026-06-16 00:09:29
#> 6       USUFMS 2026-06-16 00:09:29           USUFMS 2026-06-16 00:09:29
#>               TIPCOB SENSAT PELIGRO CATDEP CATPRO CATDIS
#> 1 Cobertura Forestal    N21       0     21   2106 210607
#> 2 Cobertura Forestal    N21       0     21   2106 210607
#> 3 Cobertura Forestal    N21       0     04   0408 040811
#> 4 Cobertura Forestal      N       0     04   0408 040811
#> 5 Cobertura Agrícola      N       0     11   1103 110301
#> 6 Cobertura Forestal    N20       0     21   2112 211208
#>                      geometry
#> 1 POINT (-69.84551 -15.34127)
#> 2 POINT (-69.84174 -15.34059)
#> 3 POINT (-73.02268 -15.33309)
#> 4 POINT (-73.01949 -15.33036)
#> 5 POINT (-75.00967 -14.98391)
#> 6 POINT (-69.15167 -14.43423)
# }
```
