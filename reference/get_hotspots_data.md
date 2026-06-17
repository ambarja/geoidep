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
#> Reading layer `file1f4944e6b00e' from data source 
#>   `/tmp/Rtmp3GDgWY/file1f4944e6b00e.geojson' using driver `GeoJSON'
#> Simple feature collection with 169 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -80.89928 ymin: -17.51561 xmax: -69.09373 ymax: -3.53471
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -71.84528 ymin: -17.51561 xmax: -69.09737 ymax: -16.32551
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15033953 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15033954 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15033955 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15033956 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15033957 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15033958 Servicio Nacional Forestal y de Fauna Silvestre       
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
#>   ZONUTM ORIGEN   NOMDEP        NOMPRO        NOMDIS  CAPITAL
#> 1     19      2    TACNA JORGE BASADRE       ILABAYA  ILABAYA
#> 2     19      2 AREQUIPA         ISLAY DEAN VALDIVIA LA CURVA
#> 3     19      2 AREQUIPA         ISLAY DEAN VALDIVIA LA CURVA
#> 4     19      2 AREQUIPA         ISLAY DEAN VALDIVIA LA CURVA
#> 5     19      2     PUNO      CHUCUITO        ZEPITA   ZEPITA
#> 6     19      2     PUNO       YUNGUYO       YUNGUYO  YUNGUYO
#>                 FECHA     HORA CATEG                          NOMCATEG
#> 1 2026-06-16 05:00:00 12:58:00    30                                  
#> 2 2026-06-16 05:00:00 13:34:00    30                                  
#> 3 2026-06-16 05:00:00 13:34:00    30                                  
#> 4 2026-06-16 05:00:00 12:58:00    30                                  
#> 5 2026-06-16 05:00:00 15:02:00    30                                  
#> 6 2026-06-16 05:00:00 12:58:00     5 Reserva Paisajística Cerro Khapia
#>     LATITUD  LONGITUD   COORES  COORNO created_user        created_date
#> 1 -17.51561 -70.57429 332875.1 8062713       USUFMS 2026-06-17 22:10:07
#> 2 -17.13727 -71.81108 200898.4 8103096       USUFMS 2026-06-17 22:10:07
#> 3 -17.13230 -71.84528 197248.9 8103593       USUFMS 2026-06-17 22:10:07
#> 4 -17.11487 -71.78090 204076.2 8105623       USUFMS 2026-06-17 22:10:07
#> 5 -16.51920 -69.22974 475484.2 8173618       USUFMS 2026-06-17 22:10:07
#> 6 -16.32551 -69.09737 489599.3 8195055       USUFMS 2026-06-17 22:10:07
#>   last_edited_user    last_edited_date             TIPCOB SENSAT PELIGRO CATDEP
#> 1           USUFMS 2026-06-17 22:10:07 Cobertura Forestal    N21       0     23
#> 2           USUFMS 2026-06-17 22:10:07 Cobertura Agrícola      N       0     04
#> 3           USUFMS 2026-06-17 22:10:07 Cobertura Agrícola      N       0     04
#> 4           USUFMS 2026-06-17 22:10:07 Cobertura Agrícola    N21       0     04
#> 5           USUFMS 2026-06-17 22:10:07 Cobertura Forestal      A       0     21
#> 6           USUFMS 2026-06-17 22:10:07 Cobertura Agrícola    N21       0     21
#>   CATPRO CATDIS                    geometry
#> 1   2303 230302 POINT (-70.57429 -17.51561)
#> 2   0407 040703 POINT (-71.81108 -17.13727)
#> 3   0407 040703  POINT (-71.84528 -17.1323)
#> 4   0407 040703  POINT (-71.7809 -17.11487)
#> 5   2104 210407  POINT (-69.22974 -16.5192)
#> 6   2113 211301 POINT (-69.09737 -16.32551)
# }
```
