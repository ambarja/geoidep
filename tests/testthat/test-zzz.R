test_that(".onAttach() muestra los mensajes correctos", {
  output <- expect_snapshot_output(geoidep:::.onAttach(libname = NULL, pkgname = "geoidep"))
})
