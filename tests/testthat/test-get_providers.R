test_that("get_providers() devuelve un tibble con la columna esperada", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- tryCatch(
    geoidep:::get_data(),
    error = function(e) testthat::skip(paste("Catalogue unavailable:", conditionMessage(e)))
  )
  expect_s3_class(result, "data.frame")       # Verifica que la salida es un tibble
  expect_true("provider" %in% names(result))  # Verifica que tiene la columna "provider"
})

test_that("get_providers() cuenta correctamente los proveedores", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- tryCatch(
    geoidep::get_providers(NULL),
    error = function(e) testthat::skip(paste("Catalogue unavailable:", conditionMessage(e)))
  )
  expect_equal(factor(result$provider), result$provider)
  expect_equal(as.integer(result$layer_count), result$layer_count)
})

test_that("get_providers() lanza error si query no es NULL", {
  expect_error(geoidep::get_providers("algo"), "Please, only")
})
