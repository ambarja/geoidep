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
#> Reading layer `file1f0555ad04e1' from data source 
#>   `/tmp/RtmpUHgu9h/file1f0555ad04e1.geojson' using driver `GeoJSON'
#> Simple feature collection with 650 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -80.93436 ymin: -17.31912 xmax: -69.09772 ymax: -2.99036
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -70.20063 ymin: -17.31912 xmax: -69.52892 ymax: -17.14184
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15063815 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15063816 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15063817 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15063818 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15063819 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15063820 Servicio Nacional Forestal y de Fauna Silvestre       
#>                FECREG
#> 1 2026-06-23 05:00:00
#> 2 2026-06-23 05:00:00
#> 3 2026-06-23 05:00:00
#> 4 2026-06-23 05:00:00
#> 5 2026-06-23 05:00:00
#> 6 2026-06-23 05:00:00
#>                                                                                        OBSERV
#> 1 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 2 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 3 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 4 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 5 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 6 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#>   ZONUTM ORIGEN NOMDEP    NOMPRO    NOMDIS   CAPITAL               FECHA
#> 1     19      2  TACNA CANDARAVE CANDARAVE CANDARAVE 2026-06-23 05:00:00
#> 2     19      2  TACNA CANDARAVE CANDARAVE CANDARAVE 2026-06-23 05:00:00
#> 3     19      2   PUNO  CHUCUITO  PISACOMA  PISACOMA 2026-06-22 05:00:00
#> 4     19      2   PUNO  CHUCUITO  PISACOMA  PISACOMA 2026-06-22 05:00:00
#> 5     19      2   PUNO  CHUCUITO  PISACOMA  PISACOMA 2026-06-22 05:00:00
#> 6     19      2   PUNO  CHUCUITO  PISACOMA  PISACOMA 2026-06-22 05:00:00
#>       HORA CATEG NOMCATEG   LATITUD  LONGITUD   COORES  COORNO created_user
#> 1 13:02:00    30          -17.31912 -70.19975 372505.1 8084744       USUFMS
#> 2 13:02:00    30          -17.31664 -70.20063 372409.9 8085018       USUFMS
#> 3 13:19:00    30          -17.14307 -69.53616 442972.2 8104539       USUFMS
#> 4 13:19:00    30          -17.14253 -69.53253 443358.1 8104600       USUFMS
#> 5 13:19:00    30          -17.14199 -69.52892 443741.9 8104661       USUFMS
#> 6 13:41:00    30          -17.14184 -69.53745 442834.6 8104675       USUFMS
#>          created_date last_edited_user    last_edited_date             TIPCOB
#> 1 2026-06-24 01:12:56           USUFMS 2026-06-24 01:12:56 Cobertura Forestal
#> 2 2026-06-24 01:12:56           USUFMS 2026-06-24 01:12:56 Cobertura Forestal
#> 3 2026-06-24 01:12:56           USUFMS 2026-06-24 01:12:56 Cobertura Forestal
#> 4 2026-06-24 01:12:56           USUFMS 2026-06-24 01:12:56 Cobertura Forestal
#> 5 2026-06-24 01:12:56           USUFMS 2026-06-24 01:12:56 Cobertura Forestal
#> 6 2026-06-24 01:12:56           USUFMS 2026-06-24 01:12:56 Cobertura Forestal
#>   SENSAT PELIGRO CATDEP CATPRO CATDIS                    geometry
#> 1      N       0     23   2302 230201 POINT (-70.19975 -17.31912)
#> 2      N       0     23   2302 230201 POINT (-70.20063 -17.31664)
#> 3      N       0     21   2104 210405 POINT (-69.53616 -17.14307)
#> 4      N       0     21   2104 210405 POINT (-69.53253 -17.14253)
#> 5      N       0     21   2104 210405 POINT (-69.52892 -17.14199)
#> 6    N20       0     21   2104 210405 POINT (-69.53745 -17.14184)
# }
```
