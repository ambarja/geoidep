test_that("get_departaments filters by department (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_departaments(departamento = "loreto", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(all(resultado$nombdep == "LORETO"))
  expect_true(all(c("ccdd", "nombdep") %in% names(resultado)))
  expect_true(all(sf::st_geometry_type(resultado) %in% c("POLYGON", "MULTIPOLYGON")))
  expect_true(all(!sf::st_is_empty(resultado)))
})

test_that("get_departaments is case-insensitive (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  lower <- tryCatch(
    geoidep::get_departaments(departamento = "loreto", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  upper <- tryCatch(
    geoidep::get_departaments(departamento = "LORETO", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INEI service unavailable:", conditionMessage(e)))
  )
  expect_equal(nrow(lower), nrow(upper))
})
