test_that("R/get_sernanp return a sf object", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_sernanp_data(layer = "zonificacion_anp" , show_progress = FALSE),
    error = function(e) testthat::skip(paste("SERNANP service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON", "LINE", "LINSTRING", "POINT", "MULTIPOINT")))
  expect_true(all(!sf::st_is_empty(resultado)))
  expect_gt(nrow(resultado), 0)
})

