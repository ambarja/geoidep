test_that("get_data_sources() return a tibble when the query argument es NULL", {
  result <- geoidep::get_data_sources(NULL)
  expect_s3_class(result, "tbl_df")
})

test_that("get_data_sources() return all nrows when the query is NULL", {
  result <- geoidep::get_data_sources(NULL)
  original_data <- geoidep:::get_data()
  expect_equal(nrow(result), nrow(original_data))
})

test_that("get_data_sources() valid filter", {
  result <- geoidep::get_data_sources("Sernanp")
  expect_s3_class(result, "data.frame")
  expect_true(all(result$provider == "Sernanp"))
})

test_that("get_data_sources() Show error with a invalid query", {
  expect_error(geoidep::get_data_sources("ProveedorInexistente"), "Please select valid providers from the available providers")
})
