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
#> Reading layer `file1f7b656044a3' from data source 
#>   `/tmp/RtmpeQ7gNG/file1f7b656044a3.geojson' using driver `GeoJSON'
#> Simple feature collection with 646 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -80.93436 ymin: -17.31912 xmax: -69.09772 ymax: -2.99036
#> Geodetic CRS:  WGS 84
head(hot_spots)
#> Simple feature collection with 6 features and 29 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -79.88718 ymin: -6.692449 xmax: -78.44987 ymax: -5.758201
#> Geodetic CRS:  WGS 84
#>   OBJECTID                                          FUENTE DOCREG
#> 1 15063774 Servicio Nacional Forestal y de Fauna Silvestre       
#> 2 15063775 Servicio Nacional Forestal y de Fauna Silvestre       
#> 3 15063776 Servicio Nacional Forestal y de Fauna Silvestre       
#> 4 15063777 Servicio Nacional Forestal y de Fauna Silvestre       
#> 5 15063778 Servicio Nacional Forestal y de Fauna Silvestre       
#> 6 15063779 Servicio Nacional Forestal y de Fauna Silvestre       
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
#>   ZONUTM ORIGEN     NOMDEP     NOMPRO     NOMDIS      CAPITAL
#> 1     17      2  CAJAMARCA  HUALGAYOC BAMBAMARCA   BAMBAMARCA
#> 2     17      2   AMAZONAS  UTCUBAMBA EL MILAGRO BAGUA GRANDE
#> 3     17      2   AMAZONAS  UTCUBAMBA EL MILAGRO BAGUA GRANDE
#> 4     17      2  CAJAMARCA    CUTERVO SANTA CRUZ      CUTERVO
#> 5     17      2 LAMBAYEQUE LAMBAYEQUE LAMBAYEQUE   LAMBAYEQUE
#> 6     17      2 LAMBAYEQUE LAMBAYEQUE LAMBAYEQUE   LAMBAYEQUE
#>                 FECHA     HORA CATEG NOMCATEG  LATITUD  LONGITUD   COORES
#> 1 2026-06-23 05:00:00 08:10:00    30          -6.63855 -78.44987 781966.5
#> 2 2026-06-23 05:00:00 14:00:00    30          -5.75820 -78.62954 762525.0
#> 3 2026-06-23 05:00:00 14:00:00    30          -5.77617 -78.62954 762516.7
#> 4 2026-06-23 05:00:00 11:10:00    30          -6.04566 -78.88107 734534.4
#> 5 2026-06-23 05:00:00 11:20:00    30          -6.67448 -79.88718 623003.1
#> 6 2026-06-23 05:00:00 11:20:00    30          -6.69245 -79.88718 622998.6
#>    COORNO created_user        created_date last_edited_user    last_edited_date
#> 1 9265482       USUFMS 2026-06-24 00:58:30           USUFMS 2026-06-24 00:58:30
#> 2 9362979       USUFMS 2026-06-24 00:58:30           USUFMS 2026-06-24 00:58:30
#> 3 9360992       USUFMS 2026-06-24 00:58:30           USUFMS 2026-06-24 00:58:30
#> 4 9331291       USUFMS 2026-06-24 00:58:30           USUFMS 2026-06-24 00:58:30
#> 5 9262097       USUFMS 2026-06-24 00:58:30           USUFMS 2026-06-24 00:58:30
#> 6 9260110       USUFMS 2026-06-24 00:58:30           USUFMS 2026-06-24 00:58:30
#>               TIPCOB         SENSAT PELIGRO CATDEP CATPRO CATDIS
#> 1 Cobertura Agrícola GOES (18 y 19)       0     06   0607 060701
#> 2 Cobertura Forestal GOES (18 y 19)       0     01   0107 010704
#> 3 Cobertura Forestal GOES (18 y 19)       0     01   0107 010704
#> 4 Cobertura Forestal GOES (18 y 19)       0     06   0606 060611
#> 5 Cobertura Agrícola GOES (18 y 19)       0     14   1403 140301
#> 6 Cobertura Agrícola GOES (18 y 19)       0     14   1403 140301
#>                      geometry
#> 1  POINT (-78.44987 -6.63855)
#> 2 POINT (-78.62954 -5.758201)
#> 3 POINT (-78.62954 -5.776167)
#> 4 POINT (-78.88107 -6.045662)
#> 5 POINT (-79.88718 -6.674483)
#> 6 POINT (-79.88718 -6.692449)
# }
```
