test_that("R/get_early_warning return a sf object", {
  amazonas <- get_departaments(show_progress = FALSE) |> subset(NOMBDEP == "AMAZONAS")
  resultado <- geoidep::get_early_warning(region = amazonas, sf = TRUE, show_progress = FALSE)
  # Verifica que el resultado sea un objeto de clase 'sf'
  expect_s3_class(resultado, "sf")

  # Verifica que el objeto tiene geometría tipo 'POLYGON' o 'MULTIPOLYGON'
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POINT", "MULTIPOINT")))

  # Verifica que no hay geometrías vacías
  expect_true(all(!sf::st_is_empty(resultado)))

  # Verifica que el número de filas sea mayor que cero
  expect_gt(nrow(resultado), 0)
})
