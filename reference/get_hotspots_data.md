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
#> Reading layer `file1f39d5becea' from data source 
#>   `/tmp/Rtmp5U2nWm/file1f39d5becea.geojson' using driver `GeoJSON'
#> Simple feature collection with 299 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -80.91536 ymin: -17.51561 xmax: -69.08943 ymax: -3.52722
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -71.84528 ymin: -17.51561 xmax: -69.09737 ymax: -16.32551
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15031051 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15031052 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15031053 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15031054 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15031055 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15031056 Servicio Nacional Forestal y de Fauna Silvestre       
#>                FECREG
#> 1 2026-06-16 05:00:00
#> 2 2026-06-16 05:00:00
#> 3 2026-06-16 05:00:00
#> 4 2026-06-16 05:00:00
#> 5 2026-06-16 05:00:00
#> 6 2026-06-16 05:00:00
#>                                                                                        OBSERV
#> 1 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 2 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 3 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 4 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 5 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#> 6 Información generada por la Unidad Funcional de Monitoreo Satelital de la DGIOFFS de SERFOR
#>   ZONUTM ORIGEN   NOMDEP                NOMPRO        NOMDIS  CAPITAL
#> 1     19      2    TACNA         JORGE BASADRE       ILABAYA  ILABAYA
#> 2     19      2 AREQUIPA                 ISLAY DEAN VALDIVIA LA CURVA
#> 3     19      2 AREQUIPA                 ISLAY DEAN VALDIVIA LA CURVA
#> 4     19      2 AREQUIPA                 ISLAY DEAN VALDIVIA LA CURVA
#> 5     19      2 MOQUEGUA GENERAL SANCHEZ CERRO       PUQUINA  PUQUINA
#> 6     19      2     PUNO               YUNGUYO       YUNGUYO  YUNGUYO
#>                 FECHA     HORA CATEG                          NOMCATEG
#> 1 2026-06-16 05:00:00 12:58:00    30                                  
#> 2 2026-06-16 05:00:00 13:34:00    30                                  
#> 3 2026-06-16 05:00:00 13:34:00    30                                  
#> 4 2026-06-16 05:00:00 12:58:00    30                                  
#> 5 2026-06-15 05:00:00 13:17:00    25                         TALAMOLLE
#> 6 2026-06-16 05:00:00 12:58:00     5 Reserva Paisajística Cerro Khapia
#>     LATITUD  LONGITUD   COORES  COORNO created_user        created_date
#> 1 -17.51561 -70.57429 332875.1 8062713       USUFMS 2026-06-17 02:10:08
#> 2 -17.13727 -71.81108 200898.4 8103096       USUFMS 2026-06-17 02:10:08
#> 3 -17.13230 -71.84528 197248.9 8103593       USUFMS 2026-06-17 02:10:08
#> 4 -17.11487 -71.78090 204076.2 8105623       USUFMS 2026-06-17 02:10:08
#> 5 -16.59121 -71.23073 261994.5 8164343       USUFMS 2026-06-17 02:10:08
#> 6 -16.32551 -69.09737 489599.3 8195055       USUFMS 2026-06-17 02:10:08
#>   last_edited_user    last_edited_date             TIPCOB SENSAT PELIGRO CATDEP
#> 1           USUFMS 2026-06-17 02:10:08 Cobertura Forestal    N21       0     23
#> 2           USUFMS 2026-06-17 02:10:08 Cobertura Agrícola      N       0     04
#> 3           USUFMS 2026-06-17 02:10:08 Cobertura Agrícola      N       0     04
#> 4           USUFMS 2026-06-17 02:10:08 Cobertura Agrícola    N21       0     04
#> 5           USUFMS 2026-06-17 02:10:08 Cobertura Forestal    N21       0     18
#> 6           USUFMS 2026-06-17 02:10:08 Cobertura Agrícola    N21       0     21
#>   CATPRO CATDIS                    geometry
#> 1   2303 230302 POINT (-70.57429 -17.51561)
#> 2   0407 040703 POINT (-71.81108 -17.13727)
#> 3   0407 040703  POINT (-71.84528 -17.1323)
#> 4   0407 040703  POINT (-71.7809 -17.11487)
#> 5   1802 180208 POINT (-71.23073 -16.59121)
#> 6   2113 211301 POINT (-69.09737 -16.32551)
# }
```
