test_that(".onAttach prints welcome messages in interactive mode", {
  # .welcome_message() holds the printing logic so it can be tested
  # directly (mocking interactive() is unreliable across R versions)
  # NOTE: cli >= 3.x sends all output (including cli_h1) to the message
  # stream, so type = "message" is required here.
  out <- utils::capture.output(geoidep:::.welcome_message(), type = "message")
  expect_true(any(grepl("Welcome to geoidep", out, fixed = TRUE)))
  expect_true(any(grepl("get_data_sources", out, fixed = TRUE)))
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
