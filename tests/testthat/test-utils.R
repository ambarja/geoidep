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

# Extra -------------------------------------------------------------------
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






