# geoidep 0.4.0
* Full refactor: scripts reorganised by provider (`inei.R`, `geobosque.R`,
  `serfor.R`, `mtc.R`, `sernanp.R`, `inaigem.R`, `senamhi.R`,
  `mapbiomas-alerta.R`, `mapbiomas-lulc.R`, `mapbiomas-fire.R`); dead
  MIDAGRI/SIGRID code removed.
* CRAN compliance: timeouts on every internet request, all network examples
  moved to `\dontrun{}`, tests skip gracefully offline/on CRAN, vignette
  builds without internet access.
* Dropped dependencies: `httr`, `progress`, `geojsonio`, `glue`; progress
  bars now use `cli`/`httr2::req_progress()`.
* New: MapBiomas Peru Collection 4 support in `get_mapbiomas_peru_lulc()`.
* Geobosques backend migration: the legacy `geobosques.minam.gob.pe/.../ws/rest`
  API is offline (HTTP 404), so `get_forest_loss_data()` now queries the
  current Geobosques platform (`bosques-app.pe`, `GET
  /api/forest-loss/wet-forest-list?ubigeoCode=`). Same arguments and same
  output columns (`anio`, `perdida`, `rango1`-`rango5`, `ubigeo`), now with
  the 2001-2025 wet-forest series at district, province and department level.
* Vignette: section 6 now compares each Loreto province against the
  departmental mean in a faceted line chart.

# geoidep 0.3.0
* New functions for download Serfor data (#6 y #7)
  - [get_forest_fire_data()](https://geografo.pe/geoidep/reference/get_forest_fire_data.html)
  - [get_hotspots_data()](https://geografo.pe/geoidep/reference/get_hotspots_data.html)

* Fixed issue #1 and #2
* New vigette (#7)

# geoidep 0.2.0
* New functions for download Midagri data
  - [get_midagri_data()](https://geografo.pe/geoidep/reference/get_midagri_data.html)
  
* New functions for download Sernanp data
  - [get_sernanp_data()](https://geografo.pe/geoidep/reference/get_sernanp_data.html)

* New functions for download Geobosque data
  - [get_forest_loss_data()](https://geografo.pe/geoidep/reference/get_forest_loss_data.html)
  - [get_early_warning()](https://geografo.pe/geoidep/reference/get_early_warning.html)

* Add base functions for geoidep
  - [get_providers()](https://geografo.pe/geoidep/reference/get_providers.html)
  - [get_data_sources()](https://geografo.pe/geoidep/reference/get_data_sources.html)

* Updated vignette
* Fixed GitHub actions 


# geoidep 0.1.0
* Initial CRAN release
* New functions to download INEI's political administrative boundaries
   - [get_districts()](https://geografo.pe/geoidep/reference/get_districts.html)
   - [get_provinces()](https://geografo.pe/geoidep/reference/get_provinces.html)
   - [get_departaments()](https://geografo.pe/geoidep/reference/get_departaments.html)
* Simple vignette
* Construction of a website for geoidep
