test_that(".onAttach prints welcome messages in interactive mode (snapshot)", {
  # Forzamos modo interactivo y reiniciamos la opción para mostrar el mensaje
  orig_interactive <- base::interactive
  unlockBinding("interactive", baseenv())
  assign("interactive", function() TRUE, envir = baseenv())
  on.exit({
    assign("interactive", orig_interactive, envir = baseenv())
    lockBinding("interactive", baseenv())
  })

  old_opt <- getOption("geoidep.shownWelcome")
  options(geoidep.shownWelcome = NULL)
  on.exit({
    options(geoidep.shownWelcome = old_opt)
  }, add = TRUE)

  # Usamos snapshot para capturar toda la salida
  expect_snapshot_output(geoidep:::.onAttach(libname = NULL, pkgname = "geoidep"))
})

test_that(".onAttach does not print messages when non-interactive", {
  # Forzamos modo NO interactivo
  orig_interactive <- base::interactive
  unlockBinding("interactive", baseenv())
  assign("interactive", function() FALSE, envir = baseenv())
  on.exit({
    assign("interactive", orig_interactive, envir = baseenv())
    lockBinding("interactive", baseenv())
  })

  # Si no es interactivo, .onAttach no debería imprimir nada
  out <- capture.output(geoidep:::.onAttach(libname = NULL, pkgname = "geoidep"))
  expect_equal(out, character(0))
})

