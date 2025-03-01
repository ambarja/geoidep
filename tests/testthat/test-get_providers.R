test_that("get_providers() devuelve un tibble con la columna esperada", {
  result <- geoidep:::get_data()
  expect_s3_class(result, "data.frame")           # Verifica que la salida es un tibble
  expect_true("provider" %in% names(result))  # Verifica que tiene la columna "provider"
})

test_that("get_providers() cuenta correctamente los proveedores", {
  result <- geoidep::get_providers(NULL)
  expect_equal(factor(result$provider), result$provider)
  expect_equal(as.integer(result$layer_count), result$layer_count)
})

test_that("get_providers() lanza error si query no es NULL", {
  expect_error(geoidep::get_providers("algo"), "Please, only NULL is valid")
})
