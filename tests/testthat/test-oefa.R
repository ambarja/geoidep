test_that("get_oefa_data validates layer (offline)", {
  expect_error(geoidep::get_oefa_data(layer = "foo"), "Invalid")
  expect_error(geoidep::get_oefa_data(), "Invalid")
})

test_that("get_oefa_data validates region (offline)", {
  expect_error(
    geoidep::get_oefa_data(region = data.frame(x = 1), layer = "derechos_mineros"),
    "sf"
  )
  pt <- sf::st_sfc(sf::st_point(c(-77, -12)), crs = 4326)
  bad_crs <- sf::st_sf(geometry = sf::st_transform(pt, 3857))
  expect_error(
    geoidep::get_oefa_data(region = bad_crs, layer = "derechos_mineros"),
    "EPSG 4326"
  )
})

test_that("get_oefa_data downloads a full layer (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_oefa_data(layer = "derechos_mineros", show_progress = FALSE),
    error = function(e) testthat::skip(paste("OEFA service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(sf::st_crs(resultado)$epsg == 4326)
})

test_that("get_oefa_data filters features inside region (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  lima <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = -77.2, ymin = -12.6, xmax = -76.6, ymax = -11.7),
                crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  resultado <- tryCatch(
    geoidep::get_oefa_data(region = lima, layer = "denuncias_ambientales",
                           show_progress = FALSE),
    error = function(e) testthat::skip(paste("OEFA service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  inside <- sf::st_within(resultado, lima, sparse = FALSE)[, 1]
  expect_true(all(inside))
})
