test_that("R/get_hotspots_data return a sf object", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_hotspots_data(show_progress = FALSE),
    error = function(e) testthat::skip(paste("SERFOR service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POINT", "MULTIPOINT")))
  expect_true(all(!sf::st_is_empty(resultado)))
  expect_gt(nrow(resultado), 0)
  expect_true(all(
    c("FECREG", "FECHA", "created_date", "last_edited_date") %in% names(resultado)
  ))
})
