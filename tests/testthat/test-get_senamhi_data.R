test_that("R/senamhi_get_spatial_alerts return a sf object", {
  resultado <- geoidep::senamhi_get_spatial_alerts(nro = 295, year = 2024, show_progress = FALSE)
  expect_s3_class(resultado, "sf")
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON")))
  expect_true(all(!sf::st_is_empty(resultado)))
  expect_gt(nrow(resultado), 0)
})

test_that("R/senamhi_get_meteorological_table returns a valid tibble object", {
  resultado <- geoidep::senamhi_get_meteorological_table()
  expect_s3_class(resultado, "tbl")
  expect_gt(nrow(resultado), 0)

})

test_that("R/enamhi_alert_by_number returns a valid tibble object", {
  resultado <- geoidep::senamhi_alert_by_number(nro = 295)
  expect_s3_class(resultado, "tbl")
  expect_gt(nrow(resultado), 0)

})


