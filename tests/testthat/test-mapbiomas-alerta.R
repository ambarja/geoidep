test_that("get_mapbiomas_peru_alerta requires a region in EPSG:4326 (offline)", {
  expect_error(
    geoidep::get_mapbiomas_peru_alerta(region = NULL, show_progress = FALSE),
    "required"
  )
  pt <- sf::st_sfc(sf::st_point(c(-6000000, -1100000)), crs = 3857)
  bad_crs <- sf::st_sf(geometry = pt)
  expect_error(
    geoidep::get_mapbiomas_peru_alerta(region = bad_crs, show_progress = FALSE),
    "EPSG 4326"
  )
})

test_that("get_mapbiomas_alert_images validates its arguments (offline)", {
  expect_error(
    geoidep::get_mapbiomas_alert_images(alert_ids = NULL),
    "cannot be empty"
  )
  expect_error(
    geoidep::get_mapbiomas_alert_images(alert_ids = "1", image_type = "foo"),
    "both"
  )
})

test_that("get_mapbiomas_peru_alerta returns an sf layer (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  aoi <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = -76, ymin = -9, xmax = -74, ymax = -7), crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  resultado <- tryCatch(
    geoidep::get_mapbiomas_peru_alerta(
      region = aoi, from = "2024-01-01", to = "2024-02-01",
      method = "within", show_progress = FALSE
    ),
    error = function(e) testthat::skip(paste("MapBiomas service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_equal(attr(resultado, "sf_column"), "geom")
  expect_true(all(
    sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON", "GEOMETRYCOLLECTION")
  ))
  expect_true(all(c("id", "detected_at", "before_image_url", "after_image_url") %in% names(resultado)))
  expect_true(all(sf::st_is_valid(resultado)))
})

test_that("get_mapbiomas_alert_images downloads one 'before' image (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  aoi <- sf::st_sf(geometry = sf::st_sfc(
    sf::st_bbox(c(xmin = -76, ymin = -9, xmax = -74, ymax = -7), crs = sf::st_crs(4326)) |>
      sf::st_as_sfc()
  ))
  alertas <- tryCatch(
    geoidep::get_mapbiomas_peru_alerta(
      region = aoi, from = "2024-01-01", to = "2024-02-01",
      method = "within", show_progress = FALSE
    ),
    error = function(e) testthat::skip(paste("MapBiomas service unavailable:", conditionMessage(e)))
  )
  testthat::skip_if(nrow(alertas) == 0 || !"id" %in% names(alertas), "No alerts with id in the window")
  dl <- tryCatch(
    geoidep::get_mapbiomas_alert_images(
      alert_ids = utils::head(alertas$id, 1), image_type = "before",
      download_dir = file.path(tempdir(), "mb_test_images"),
      show_progress = FALSE
    ),
    error = function(e) testthat::skip(paste("MapBiomas images unavailable:", conditionMessage(e)))
  )
  expect_s3_class(dl, "tbl_df")
  expect_true(all(c("alert_id", "image_type", "url", "local_path", "status") %in% names(dl)))
  expect_true(all(dl$status %in% c("success", "failed", "skipped")))
})
