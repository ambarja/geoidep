# inei --------------------------------------------------------------------
test_that("get_inei_link returns the correct URL or raises an error", {
  expect_equal(
    geoidep:::get_inei_link("distrito"),
    "https://ide.inei.gob.pe/files/Distrito.rar"
  )

  expect_equal(
    geoidep:::get_inei_link("provincia"),
    "https://ide.inei.gob.pe/files/Provincia.rar"
  )

  expect_equal(
    geoidep:::get_inei_link("departamento"),
    "https://ide.inei.gob.pe/files/Departamento.rar"
  )

  expect_error(
    geoidep:::get_inei_link("foo"),
    "Invalid type. Please choose from 'districto', 'provincia', or 'departmento'."
  )

  expect_error(
    geoidep:::get_inei_link(NULL),
    "Invalid type. Please choose from 'districto', 'provincia', or 'departmento'."
  )
})

# sernanp -----------------------------------------------------------------
test_that("get_sernanp_link returns the correct URL or raises an error", {
  expect_equal(
    get_sernanp_link("anp_nacional"),
    "https://geoservicios.sernanp.gob.pe/arcgis/rest/services/sernanp_visor/servicio_descarga/MapServer/1/query"
  )

  expect_equal(
    get_sernanp_link("ecorregiones_cdc"),
    "https://geoservicios.sernanp.gob.pe/arcgis/rest/services/sernanp_visor/servicio_descarga/MapServer/31/query"
  )

  expect_error(
    get_sernanp_link("foo"),
    "Invalid type. Please choose one layer"
  )

  expect_error(
    get_sernanp_link(NULL),
    "Invalid type. Please choose one layer"
  )
})


# midagri -----------------------------------------------------------------
test_that("get_midagri_link returns the correct URL or raises an error", {
  expect_equal(
    get_midagri_link("agriculture_sector"),
    "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/sectores/2024/SectoresEstadisticos_2024_04.zip"
  )

  expect_equal(
    get_midagri_link("oil_palm_areas"),
    "https://siea.midagri.gob.pe/portal/media/attachments/publicaciones/superficie/temas/PALMA_ACEITERA_2016_2020.zip"
  )

  expect_error(
    get_midagri_link("foo"),
    "Invalid type. Please choose from 'agriculture_sector' or 'oil_palm'"
  )

  expect_error(
    get_midagri_link(NULL),
    "Invalid type. Please choose from 'agriculture_sector' or 'oil_palm'"
  )
})

# geobosque ---------------------------------------------------------------
test_that("get_geobosque_link returns the correct URL or raises an error", {
  expect_equal(
    get_geobosque_link("stock_bosque_perdida_distrito"),
    "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaDistrito"
  )

  expect_equal(
    get_geobosque_link("stock_bosque_perdida_provincia"),
    "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaProvincia"
  )

  expect_equal(
    get_geobosque_link("stock_bosque_perdida_departamento"),
    "http://geobosques.minam.gob.pe/geobosque/ws/rest/BOSQUEPERDIDA/stockBosquePerdidaRegion"
  )

  expect_error(
    get_geobosque_link("foo"),
    "Invalid type. Please choose from 'dist', 'prov' or 'dep'"
  )

  expect_error(
    get_geobosque_link(NULL),
    "Invalid type. Please choose from 'dist', 'prov' or 'dep'"
  )
})

test_that("get_early_warning_link returns the correct URL or raises an error", {
  expect_equal(
    get_early_warning_link("warning_last_week"),
    "http://geobosques.minam.gob.pe/geobosque/ws/rest/ALERTAS/ultimasByCobertura"
  )

  expect_error(
    get_early_warning_link("foo"),
    "Invalid type. Please choose 'warning_last_week'"
  )

  expect_error(
    get_early_warning_link(NULL),
    "Invalid type. Please choose 'warning_last_week'"
  )
})

test_that("get_heat_spot_link returns the correct URL or raises an error", {
  expect_equal(
    get_heat_spot_link("heat_spot"),
    "https://geo.serfor.gob.pe/geoservicios/rest/services/Servicios_OGC/Unidad_Monitoreo_Satelital/MapServer/0/query"
  )

  expect_error(
    get_heat_spot_link("foo"),
    "Invalid type. Please choose 'heat_spot'"
  )

  expect_error(
    get_heat_spot_link(NULL),
    "Invalid type. Please choose 'heat_spot'"
  )
})

# validate_date -----------------------------------------------------------
test_that("validate_date accepts real dates and rejects the rest (offline)", {
  expect_equal(
    geoidep:::validate_date("2024-01-31", "start_date"),
    as.Date("2024-01-31")
  )
  expect_null(geoidep:::validate_date(NULL, "start_date"))
  expect_error(
    geoidep:::validate_date("2024/01/01", "start_date"),
    "Invalid"
  )
  expect_error(
    geoidep:::validate_date("2024-02-30", "start_date"),
    "not a real calendar date"
  )
})

# .get_layer_url ----------------------------------------------------------
test_that(".get_layer_url resolves known pairs and rejects the rest (offline)", {
  expect_match(
    geoidep:::.get_layer_url("igp", "descargar_datos"),
    "ultimosismo.igp.gob.pe"
  )
  expect_error(geoidep:::.get_layer_url("nope", "x"), "should be one of")
  expect_error(geoidep:::.get_layer_url("igp", "foo"), "Invalid")
  expect_error(geoidep:::.get_layer_url("igp"), "Invalid")
})

# mtc / inaigem / mapbiomas links ------------------------------------------
test_that("provider link wrappers resolve and reject (offline)", {
  for (provider in c("mtc", "inaigem")) {
    keys <- names(geoidep:::.internal_urls[[provider]])
    link_fn <- get(paste0("get_", provider, "_link"))
    expect_match(link_fn(keys[1]), "^https?://")
    expect_error(link_fn("foo"), "Invalid")
    expect_error(link_fn(NULL), "Invalid")
  }

  mb_keys <- names(geoidep:::.internal_urls$mapbiomas)
  expect_match(geoidep:::get_mapbiomas_link(mb_keys[1]), "^https?://")
  expect_error(geoidep:::get_mapbiomas_link("foo"), "Invalid type")
  expect_error(geoidep:::get_mapbiomas_link(NULL), "Invalid type")
})

# mapbiomas legend ----------------------------------------------------------
test_that("get_mapbiomas_peru_legend returns the class table (offline)", {
  legend <- geoidep:::get_mapbiomas_peru_legend()
  expect_s3_class(legend, "tbl_df")
  expect_gt(nrow(legend), 0)
  expect_true(all(c("id", "class_en", "class_es", "hex") %in% names(legend)))
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", legend$hex)))
})

# .read_spatial_normalised --------------------------------------------------
test_that(".read_spatial_normalised lowercases column names (offline)", {
  pts <- sf::st_sf(
    NAME = c("a", "b"),
    VALUE = c(1, 2),
    geometry = sf::st_sfc(sf::st_point(c(-77, -12)), sf::st_point(c(-76, -11)), crs = 4326)
  )
  path <- file.path(tempdir(), "geoidep_norm_test.geojson")
  suppressMessages(sf::st_write(pts, path, delete_dsn = TRUE, quiet = TRUE))
  out <- geoidep:::.read_spatial_normalised(path, quiet = TRUE)
  expect_s3_class(out, "sf")
  expect_equal(nrow(out), 2)
  expect_true(all(c("name", "value") %in% names(out)))
})

# get_data ------------------------------------------------------------------
test_that("get_data aborts gracefully on an unreachable catalogue (offline)", {
  expect_error(
    geoidep:::get_data(url = "http://127.0.0.1:1/nope.csv", timeout = 5),
    "The catalogue could not be read"
  )
})
test_that("as_data_time converts milliseconds to correct POSIXct date", {
  # Caso base: 0 ms corresponde a la fecha origen
  expect_equal(
    as_data_time(0),
    as.POSIXct("1970-01-01", tz = "UTC")
  )

  # 1000 ms deben equivaler a 1 segundo después de la fecha origen
  expect_equal(
    as_data_time(1000),
    as.POSIXct("1970-01-01 00:00:01", tz = "UTC")
  )

  # Caso adicional: 1609459200000 ms deben equivaler a "2021-01-01 00:00:00" UTC
  expect_equal(
    as_data_time(1609459200000),
    as.POSIXct("2021-01-01 00:00:00", tz = "UTC")
  )
})






