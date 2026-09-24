test_that("get_forest_loss_data validates layer and ubigeo (offline)", {
  expect_error(geoidep::get_forest_loss_data(layer = "foo", ubigeo = "010101"), "Invalid")
  expect_error(geoidep::get_forest_loss_data(ubigeo = "010101"), "Invalid")
  expect_error(
    geoidep::get_forest_loss_data(layer = "stock_bosque_perdida_distrito", ubigeo = "01"),
    "Expected"
  )
  expect_error(
    geoidep::get_forest_loss_data(layer = "stock_bosque_perdida_distrito", ubigeo = 10101),
    "Expected"
  )
  expect_error(
    geoidep::get_forest_loss_data(layer = "stock_bosque_perdida_provincia"),
    "Expected"
  )
})

test_that("get_forest_loss_data returns the 2001-2025 series (live)", {
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
  expect_true(all(
    c("anio", "perdida", "rango1", "rango2", "rango3", "rango4", "rango5", "ubigeo") %in%
      names(resultado)
  ))
  expect_true(all(2001:2025 %in% resultado$anio))
  expect_equal(resultado$anio, sort(resultado$anio))
  expect_true(is.numeric(resultado$perdida))
  expect_true(all(resultado$ubigeo == "010101"))
})
