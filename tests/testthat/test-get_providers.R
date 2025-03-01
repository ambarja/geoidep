test_that("get_providers() devuelve un tibble con la columna esperada", {
  result <- get_data() |> tibble::as_tibble()

  expect_s3_class(result, "tbl_df")           # Verifica que la salida es un tibble
  expect_true("provider" %in% names(result))  # Verifica que tiene la columna "provider"
})

test_that("get_providers() cuenta correctamente los proveedores", {
  result <- get_providers(NULL)
  expect_equal(as.character(result$provider), c("Geobosque", "INEI", "Midagri", "Senamhi", "Serfor", "Sernanp"))
  expect_equal(result$layer_count, c(5, 3, 4, 1, 2, 61))
})

test_that("get_providers() lanza error si query no es NULL", {
  expect_error(get_providers("algo"), "Please, only NULL is valid")
})
