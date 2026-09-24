test_that("get_early_warning requires EPSG:4326 (offline)", {
  pt <- sf::st_sfc(sf::st_point(c(-77, -12)), crs = 4326)
  bad_crs <- sf::st_sf(geometry = sf::st_transform(pt, 3857))
  expect_error(
    geoidep::get_early_warning(region = bad_crs, show_progress = FALSE),
    "EPSG 4326"
  )
})

test_that("get_early_warning returns alert points as sf (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  loreto <- tryCatch(
    geoidep::get_departaments(departamento = "LORETO", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  resultado <- tryCatch(
    geoidep::get_early_warning(region = loreto, sf = TRUE, show_progress = FALSE),
    error = function(e) testthat::skip(paste("Geobosque service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(sf::st_crs(resultado)$epsg == 4326)
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POINT", "MULTIPOINT")))
})

test_that("get_early_warning returns a lng/lat tibble with sf = FALSE (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  loreto <- tryCatch(
    geoidep::get_departaments(departamento = "LORETO", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  resultado <- tryCatch(
    geoidep::get_early_warning(region = loreto, sf = FALSE, show_progress = FALSE),
    error = function(e) testthat::skip(paste("Geobosque service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "tbl_df")
  expect_true(all(c("lng", "lat") %in% names(resultado)))
  expect_gt(nrow(resultado), 0)
})
