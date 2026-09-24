test_that("get_mapbiomas_peru_fire_products lists 8 products (offline)", {
  prods <- geoidep::get_mapbiomas_peru_fire_products()
  expect_s3_class(prods, "tbl_df")
  expect_equal(nrow(prods), 8)
  expect_true(all(
    c("product", "description_en", "description_es", "temporal") %in% names(prods)
  ))
  expect_true(all(prods$temporal %in% c("annual", "range")))
})

test_that("get_mapbiomas_peru_fire_legend returns class tables (offline)", {
  freq <- geoidep::get_mapbiomas_peru_fire_legend("frequency_burned")
  expect_s3_class(freq, "tbl_df")
  expect_equal(nrow(freq), 12)
  expect_true(all(c("id", "class_en", "class_es", "hex") %in% names(freq)))
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", freq$hex)))

  annual <- geoidep::get_mapbiomas_peru_fire_legend("annual_burned")
  expect_gt(nrow(annual), 0)

  expect_error(geoidep::get_mapbiomas_peru_fire_legend("foo"), "Invalid")
})

test_that("get_mapbiomas_peru_fire validates product, collection and year (offline)", {
  expect_error(geoidep::get_mapbiomas_peru_fire("foo", 2024), "Invalid")
  expect_error(
    geoidep::get_mapbiomas_peru_fire("annual_burned", 2024, collection = 2),
    "only collection"
  )
  expect_error(
    geoidep::get_mapbiomas_peru_fire("annual_burned", 1990),
    "1999"
  )
  expect_error(
    geoidep::get_mapbiomas_peru_fire("frequency_burned", 2000),
    "2014"
  )
})

test_that("mapbiomas fire scale builds without raster or network (offline)", {
  testthat::skip_if_not_installed("ggplot2")
  sc <- geoidep::scale_fill_mapbiomas_peru_fire_d("frequency_burned", lang = "es")
  expect_true(inherits(sc, "Scale"))
  expect_error(geoidep::scale_fill_mapbiomas_peru_fire_d("foo"), "Invalid")
})

test_that("get_mapbiomas_peru_fire returns a cropped SpatRaster (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("terra")
  lima <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = -77.2, ymin = -12.6, xmax = -76.6, ymax = -11.7),
                crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  r <- tryCatch(
    geoidep::get_mapbiomas_peru_fire("annual_burned", 2024, crop_to = lima),
    error = function(e) testthat::skip(paste("MapBiomas service unavailable:", conditionMessage(e)))
  )
  testthat::expect_s4_class(r, "SpatRaster")
  expect_equal(terra::nlyr(r), 1)
})
