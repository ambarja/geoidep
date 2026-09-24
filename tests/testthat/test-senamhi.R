test_that("senamhi_alert_by_number filters offline on synthetic data", {
  fake <- data.frame(
    aviso = c("Lluvia intensa", "Viento fuerte"),
    nro = c("295-2024", "12-2023"),
    emision = c("2024-03-01", "2023-05-01"),
    stringsAsFactors = FALSE
  )
  hit <- geoidep::senamhi_alert_by_number(fake, 2952024)
  expect_equal(nrow(hit), 1)
  expect_equal(hit$nro, "295-2024")
  expect_false("nro_clean" %in% names(hit))

  miss <- geoidep::senamhi_alert_by_number(fake, 999)
  expect_equal(nrow(miss), 0)
})

test_that("senamhi_alerts_by_year filters offline on synthetic data", {
  fake <- data.frame(
    aviso = c("Lluvia intensa", "Viento fuerte"),
    nro = c("295-2024", "12-2023"),
    emision = c("2024-03-01", "2023-05-01"),
    stringsAsFactors = FALSE
  )
  expect_equal(nrow(geoidep::senamhi_alerts_by_year(fake, 2024)), 1)
  expect_equal(nrow(geoidep::senamhi_alerts_by_year(fake, 2020)), 0)
})

test_that("senamhi_get_spatial_alerts requires an alert reference (offline)", {
  expect_error(
    geoidep::senamhi_get_spatial_alerts(),
    "Missing alert reference"
  )
})

test_that("senamhi_geometry_by_level requires an sf object (offline)", {
  expect_error(
    geoidep::senamhi_geometry_by_level(data.frame(nivel = "Nivel 3"), 3),
    "Input must be an sf object"
  )
})

test_that("senamhi_get_meteorological_table returns the 7-column catalogue (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  tabla <- tryCatch(
    geoidep::senamhi_get_meteorological_table(show_progress = FALSE),
    error = function(e) testthat::skip(paste("SENAMHI service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(tabla, "tbl_df")
  expect_true(all(
    c("aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel") %in% names(tabla)
  ))
  expect_gt(nrow(tabla), 0)
})

test_that("senamhi chain table -> geometry -> level works (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  tabla <- tryCatch(
    geoidep::senamhi_get_meteorological_table(show_progress = FALSE),
    error = function(e) testthat::skip(paste("SENAMHI service unavailable:", conditionMessage(e)))
  )
  testthat::skip_if(nrow(tabla) == 0, "SENAMHI catalogue is empty today")
  geom <- tryCatch(
    geoidep::senamhi_get_spatial_alerts(data = tabla[1, ], show_progress = FALSE),
    error = function(e) testthat::skip(paste("SENAMHI geometry unavailable:", conditionMessage(e)))
  )
  expect_s3_class(geom, "sf")
  expect_gt(nrow(geom), 0)
  expect_true("nivel" %in% names(geom))

  level_value <- geom$nivel[1]
  filtrada <- geoidep::senamhi_geometry_by_level(geom, level_value)
  expect_s3_class(filtrada, "sf")
  expect_gt(nrow(filtrada), 0)
  expect_true(all(filtrada$nivel == level_value))
})
