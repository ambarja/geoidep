test_that("get_forest_loss_data returns a valid data.frame object", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_forest_loss_data(
      layer = "stock_bosque_perdida_distrito",
      ubigeo = "010101",
      show_progress = FALSE
    ),
    error = function(e) testthat::skip(paste("Geobosque service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "data.frame")
  expect_gt(nrow(resultado), 0)

})
