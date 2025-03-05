test_that("R/get_districts return a sf object", {
  resultado <- geoidep::get_districts()
  # Verifica que el resultado sea un objeto de clase 'sf'
  expect_s3_class(resultado, "sf")

  # Verifica que el objeto tiene geometría tipo 'POLYGON' o 'MULTIPOLYGON'
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON")))

  # Verifica que no hay geometrías vacías
  expect_true(all(!sf::st_is_empty(resultado)))

  # Verifica que el número de filas sea mayor que cero
  expect_gt(nrow(resultado), 0)
})
