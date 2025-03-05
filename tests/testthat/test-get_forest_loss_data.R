test_that("get_forest_loss_data returns a valid data.frame object", {
  resultado <- geoidep::get_forest_loss_data(
    layer = "stock_bosque_perdida_distrito",
    ubigeo = "010101",
    show_progress = FALSE
  )

  # Verifica que el resultado sea un objeto de clase 'data.frame'
  expect_s3_class(resultado, "data.frame")

  # Verifica que el data.frame tenga al menos una fila
  expect_gt(nrow(resultado), 0)

})

