.onAttach <- function(libname, pkgname) {
  if (interactive() && !isTRUE(getOption("geoidep.shownWelcome"))) {

    cli::cli_h1("Welcome to geoidep")

    cli::cli_alert_info("geoidep is a wrapper that enables you to download cartographic data for Peru directly from R.")
    cli::cli_alert_info("Currently, `geoidep` supports data from the following providers:")

    providers_data <- get_providers()
    providers <- c(if (is.data.frame(providers_data) && "provider" %in% names(providers_data)) {
      providers_data$provider[1:min(4, nrow(providers_data))] |> as.vector()
    } else character(),"and more!")

    for (provider in providers) {
      cli::cli_alert_success(provider)
    }

    cli::cli_alert_info("For more information, please use the `get_data_sources()` function.")

    options(geoidep.shownWelcome = TRUE)
  }
}

