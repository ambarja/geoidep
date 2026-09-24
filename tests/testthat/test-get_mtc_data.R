test_that("get_mtc_data rejects an unknown layer (offline)", {
  expect_error(geoidep::get_mtc_data(layer = "foo"), "Invalid")
  expect_error(geoidep::get_mtc_data(), "Invalid")
})

test_that("get_mtc_data returns an sf object in EPSG:4326 (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_mtc_data(layer = "aerodromos_2023", show_progress = FALSE),
    error = function(e) testthat::skip(paste("MTC service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(sf::st_crs(resultado)$epsg == 4326)
  expect_true(all(!sf::st_is_empty(resultado)))
})
