.onAttach <- function(...) {
  # Usar `cli` para formatear el mensaje
  cli::cli_h1("Welcome to geoidep")

  cli::cli_alert_info(
    "geoidep is a wrapper that allows you to download cartographic data for Peru from R.
    Currently, `geoidep` supports the following providers:"
  )
  # Lista de proveedores con mensajes de éxito
  providers <- get_providers()[["provider"]] |> as.vector()
  for (provider in providers) {
    cli::cli_alert_success(provider)
  }

  cli::cli_alert_info(
    "For more information, please use the `get_data_sources()` function."
  )
}
