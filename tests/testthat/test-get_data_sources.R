test_that("get_data_sources() return a tibble when the query argument es NULL", {
  result <- get_data_sources(NULL)
  expect_s3_class(result, "tbl_df")
})

test_that("get_data_sources() return all nrows when the query is NULL", {
  result <- get_data_sources(NULL)
  original_data <- get_data() |> tidyr::as_tibble()
  expect_equal(nrow(result), nrow(original_data))
})

test_that("get_data_sources() valid filter", {
  result <- get_data_sources("Sernanp")
  expect_s3_class(result, "tbl_df")
  expect_true(all(result$provider == "Sernanp"))
})

test_that("get_data_sources() Show error with a invalid query", {
  expect_error(get_data_sources("ProveedorInexistente"), "Please select valid providers from the available providers")
})
