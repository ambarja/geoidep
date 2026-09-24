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
