test_that("R/get_departaments return a sf object", {
  resultado <- geoidep::get_departaments()
  # Verifica que el resultado sea un objeto de clase 'sf'
  expect_s3_class(resultado, "sf")

  # Verifica que el objeto tiene geometría tipo 'POLYGON' o 'MULTIPOLYGON'
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON")))

  # Verifica que no hay geometrías vacías
  expect_true(all(!sf::st_is_empty(resultado)))

  # Verifica que el número de filas sea mayor que cero
  expect_gt(nrow(resultado), 0)
})

test_that("get_departaments() maneja errores si `get_inei_link()` recibe un argumento inválido", {
  skip_on_cran()
  skip_if_offline("geoidep.gob.pe")
  expect_error(
    geoidep:::get_inei_link("invalid_type"),
    "Invalid type. Please choose from 'districts', 'provinces', or 'departments'."
  )
})
