test_that("get_provinces return a sf object", {
  resultado <- geoidep::get_provinces()
  expect_s3_class(resultado, "sf")
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON")))
  expect_true(all(!sf::st_is_empty(resultado)))
  expect_gt(nrow(resultado), 0)
})
