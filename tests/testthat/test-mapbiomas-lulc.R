test_that("get_mapbiomas_peru_lulc validates collection (offline)", {
  expect_error(
    geoidep::get_mapbiomas_peru_lulc(2024, collection = 5),
    "Available collections"
  )
})

test_that("get_mapbiomas_peru_lulc_series validates years (offline)", {
  expect_error(geoidep::get_mapbiomas_peru_lulc_series("2024"), "Invalid")
  expect_error(geoidep::get_mapbiomas_peru_lulc_series(numeric(0)), "Invalid")
  expect_error(geoidep::get_mapbiomas_peru_lulc_series(NULL), "Invalid")
})

test_that("mapbiomas lulc legend and scale work offline", {
  legend <- geoidep:::get_mapbiomas_peru_legend()
  expect_s3_class(legend, "tbl_df")
  expect_gt(nrow(legend), 0)
  expect_true(all(c("id", "class_en", "class_es", "hex") %in% names(legend)))

  testthat::skip_if_not_installed("ggplot2")
  sc <- geoidep::scale_fill_mapbiomas_peru_lulc_d(lang = "es")
  expect_true(inherits(sc, "Scale"))
})

test_that(".mapbiomas_lulc_url builds exact URLs without downloading (offline)", {
  expect_identical(
    geoidep:::.mapbiomas_lulc_url(2024, 4),
    "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/collection4/lulc/coverage/peru_coverage/peru_coverage-col4_2024.tif"
  )
  expect_identical(
    geoidep:::.mapbiomas_lulc_url(2024, 3),
    "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/collection_3/LULC/peru_collection3_integration_v1-classification_2024.tif"
  )
  expect_identical(
    geoidep:::.mapbiomas_lulc_url(2000, 1),
    "https://storage.googleapis.com/mapbiomas-public/initiatives/peru/collection_1/LULC/peru_collection1_integration_v1-classification_2000.tif"
  )
})

test_that(".crop_mapbiomas_raster crops and names a synthetic raster (offline)", {
  testthat::skip_if_not_installed("terra")
  r <- terra::rast(nrows = 10, ncols = 10, xmin = 0, xmax = 1, ymin = 0, ymax = 1,
                   crs = "EPSG:4326")
  terra::values(r) <- 1:100
  zone <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = 0, ymin = 0, xmax = 0.5, ymax = 0.5),
                crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  out <- geoidep:::.crop_mapbiomas_raster(r, zone, "classification_2024")
  testthat::expect_s4_class(out, "SpatRaster")
  expect_identical(names(out), "classification_2024")
  expect_equal(terra::ncol(out), 5)
  expect_equal(terra::nrow(out), 5)

  # NULL crop_to only renames
  out_full <- geoidep:::.crop_mapbiomas_raster(r, NULL, "classification_2024")
  expect_equal(terra::ncol(out_full), 10)
  expect_identical(names(out_full), "classification_2024")
})

test_that("get_mapbiomas_peru_lulc returns a cropped SpatRaster (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("terra")
  testthat::skip_if_not(
    identical(Sys.getenv("GEOIDEP_RUN_HEAVY"), "1"),
    "Heavy raster download skipped (set GEOIDEP_RUN_HEAVY=1 to run)."
  )
  lima <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = -77.2, ymin = -12.6, xmax = -76.6, ymax = -11.7),
                crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  r <- tryCatch(
    geoidep::get_mapbiomas_peru_lulc(2024, crop_to = lima),
    error = function(e) testthat::skip(paste("MapBiomas service unavailable:", conditionMessage(e)))
  )
  testthat::expect_s4_class(r, "SpatRaster")
  expect_equal(names(r), "classification_2024")
})

test_that("get_mapbiomas_peru_lulc_series stacks yearly layers (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  testthat::skip_if_not_installed("terra")
  testthat::skip_if_not(
    identical(Sys.getenv("GEOIDEP_RUN_HEAVY"), "1"),
    "Heavy raster download skipped (set GEOIDEP_RUN_HEAVY=1 to run)."
  )
  lima <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = -77.2, ymin = -12.6, xmax = -76.6, ymax = -11.7),
                crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  r <- tryCatch(
    geoidep::get_mapbiomas_peru_lulc_series(2023:2024, crop_to = lima, show_progress = FALSE),
    error = function(e) testthat::skip(paste("MapBiomas service unavailable:", conditionMessage(e)))
  )
  testthat::expect_s4_class(r, "SpatRaster")
  expect_equal(terra::nlyr(r), 2)
  expect_equal(names(r), c("classification_2023", "classification_2024"))
})
