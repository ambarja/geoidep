test_that("R/get_hotspots_data return a sf object", {
  resultado <- geoidep::get_hotspots_data(show_progress = FALSE)
  expect_s3_class(resultado, "sf")
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POINT", "MULTIPOINT")))
  expect_true(all(!sf::st_is_empty(resultado)))
  expect_gt(nrow(resultado), 0)
})
