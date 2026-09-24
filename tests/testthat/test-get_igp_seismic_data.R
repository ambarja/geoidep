test_that("get_igp_seismic_data returns a valid sf object", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_igp_seismic_data(
      catalog = "instrumental",
      start_date = "2026-08-24",
      end_date = "2026-09-24",
      min_magnitude = 4,
      show_progress = FALSE
    ),
    error = function(e) testthat::skip(paste("IGP service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(all(c("fecha_utc", "hora_utc", "latitud", "longitud",
                    "profundidad_km", "magnitud") %in% names(resultado)))
  expect_true(sf::st_crs(resultado)$epsg == 4326)
})

test_that("get_igp_seismic_data filters by polygon", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  box <- sf::st_bbox(c(xmin = -78, ymin = -12.5, xmax = -76, ymax = -11),
                     crs = sf::st_crs(4326))
  poly <- sf::st_as_sfc(box)
  poly_sf <- sf::st_sf(geometry = poly)
  resultado <- tryCatch(
    geoidep::get_igp_seismic_data(
      catalog = "instrumental",
      start_date = "2026-08-24",
      end_date = "2026-09-24",
      min_magnitude = 4,
      polygon = poly_sf,
      show_progress = FALSE
    ),
    error = function(e) testthat::skip(paste("IGP service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  coords <- sf::st_coordinates(resultado)
  expect_true(all(coords[, "X"] >= -78 & coords[, "X"] <= -76))
  expect_true(all(coords[, "Y"] >= -12.5 & coords[, "Y"] <= -11))
  expect_true(all(lengths(sf::st_intersects(resultado, poly_sf)) > 0))
})
