test_that("senamhi_get_spatial_alerts() devuelve un objeto sf", {
  skip_on_cran()
  skip_if_offline("idesep.Senamhi.gob.pe")  # Corrección: solo el hostname
  result <- geoidep:::senamhi_get_spatial_alerts(nro = 295, year = 2024, show_progress = FALSE)
  expect_s3_class(result, "sf")
  expect_true(nrow(result) > 0)
})

test_that("senamhi_get_meteorological_table() devuelve un tibble con columnas esperadas", {
  skip_on_cran()
  skip_if_offline("Senamhi.gob.pe")  # Corrección: solo el hostname
  result <- geoidep:::senamhi_get_meteorological_table()
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true(all(c("aviso", "nro", "emision", "inicio", "fin", "duracion", "nivel") %in% names(result)))
})

test_that("senamhi_alert_by_number() filtra correctamente los datos", {
  skip_on_cran()
  skip_if_offline("Senamhi.gob.pe")  # Corrección: solo el hostname
  result <- geoidep:::senamhi_alert_by_number(295)
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true(all(as.numeric(gsub("[^0-9]", "", result$nro)) == 295))
})

test_that("senamhi_alerts_by_year() filtra correctamente los datos por año", {
  skip_on_cran()
  skip_if_offline("Senamhi.gob.pe")  # Corrección: solo el hostname
  data <- geoidep:::senamhi_get_meteorological_table()
  result <- geoidep:::senamhi_alerts_by_year(data = data, year = 2024)
  expect_s3_class(result, "data.frame")
  expect_true(nrow(result) > 0)
  expect_true(all(substr(result$emision, 1, 4) == "2024"))
})
