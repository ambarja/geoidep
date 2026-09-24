test_that("get_inaigem_data rejects an unknown layer (offline)", {
  expect_error(geoidep::get_inaigem_data(layer = "foo"), "Invalid")
  expect_error(geoidep::get_inaigem_data(), "Invalid")
})

test_that("get_inaigem_data returns an sf object (live)", {
  testthat::skip_on_cran()
  testthat::skip_if_offline()
  resultado <- tryCatch(
    geoidep::get_inaigem_data(layer = "glaciares_1989", show_progress = FALSE),
    error = function(e) testthat::skip(paste("INAIGEM service unavailable:", conditionMessage(e)))
  )
  expect_s3_class(resultado, "sf")
  expect_gt(nrow(resultado), 0)
  expect_true(all(!sf::st_is_empty(resultado)))
})
