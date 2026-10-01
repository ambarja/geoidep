test_that("bundled catalogue loads offline without network (CRAN-safe)", {
  # No skip_*: must pass on CRAN with no internet. Uses the catalogue
  # shipped inside the package, never the remote copy.
  result <- geoidep:::get_data()
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("provider", "category", "layer") %in% names(result)))
  expect_gt(nrow(result), 0)

  providers <- geoidep::get_providers()
  expect_s3_class(providers, "tbl_df")
  expect_true(all(c("provider", "layer_count") %in% names(providers)))

  sources <- geoidep::get_data_sources(NULL)
  expect_equal(nrow(sources), nrow(result))
})

test_that("get_data_sources() return a tibble when the query argument es NULL", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- tryCatch(
    geoidep::get_data_sources(NULL),
    error = function(e) testthat::skip(paste("Catalogue unavailable:", conditionMessage(e)))
  )
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("provider", "category", "layer") %in% names(result)))
})

test_that("get_data_sources() return all nrows when the query is NULL", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- tryCatch(
    geoidep::get_data_sources(NULL),
    error = function(e) testthat::skip(paste("Catalogue unavailable:", conditionMessage(e)))
  )
  original_data <- geoidep:::get_data()
  expect_equal(nrow(result), nrow(original_data))
})

test_that("get_data_sources() valid filter", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  result <- tryCatch(
    geoidep::get_data_sources("Sernanp"),
    error = function(e) testthat::skip(paste("Catalogue unavailable:", conditionMessage(e)))
  )
  expect_s3_class(result, "data.frame")
  expect_true(all(result$provider == "Sernanp"))
})

test_that("get_data_sources() Show error with a invalid query", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  expect_error(geoidep::get_data_sources("ProveedorInexistente"), "Invalid")
})
