test_that("get_provinces requires departamento to filter by provincia (offline)", {
  expect_error(
    geoidep::get_provinces(provincia = "Lima"),
    "Must specify"
  )
})

test_that("get_provinces filters by department (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_provinces(departamento = "LORETO", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(all(resultado$nombdep == "LORETO"))
  expect_true(all(c("ccdd", "ccpp", "nombdep", "nombprov") %in% names(resultado)))
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON")))
  expect_true(all(!sf::st_is_empty(resultado)))
})

test_that("get_provinces filters by department and province (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_provinces(departamento = "lima", provincia = "lima", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(all(resultado$nombprov == "LIMA"))
})
