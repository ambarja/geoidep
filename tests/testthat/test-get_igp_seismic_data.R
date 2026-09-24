test_that("get_igp_seismic_data validates its arguments (offline)", {
  expect_error(
    geoidep::get_igp_seismic_data(catalog = "foo"),
    "should be one of"
  )
  expect_error(
    geoidep::get_igp_seismic_data(start_date = "2024/01/01", end_date = "2024-02-01"),
    "Invalid"
  )
  expect_error(
    geoidep::get_igp_seismic_data(start_date = "2024-02-30", end_date = "2024-03-01"),
    "not a real calendar date"
  )
  expect_error(
    geoidep::get_igp_seismic_data(start_date = "2024-03-01", end_date = "2024-02-01"),
    "Invalid date range"
  )
  expect_error(
    geoidep::get_igp_seismic_data(min_magnitude = "4"),
    "Invalid"
  )
  expect_error(
    geoidep::get_igp_seismic_data(min_magnitude = 6, max_magnitude = 4),
    "must not exceed"
  )
  expect_error(
    geoidep::get_igp_seismic_data(min_depth = 500, max_depth = 100),
    "must not exceed"
  )
  expect_error(
    geoidep::get_igp_seismic_data(polygon = data.frame(x = 1)),
    "Invalid"
  )
})

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
