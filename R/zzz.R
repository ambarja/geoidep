.onAttach <- function(libname, pkgname) {
  if (interactive() && !isTRUE(getOption("geoidep.shownWelcome"))) {

    cli::cli_h1("Welcome to geoidep")
    name.project <- cli::bg_black(cli::style_bold(cli::col_white("geoidep")))
    cli::cli_alert_info("{.emph {.href [{name.project}](https://geografo.pe/geoidep)} is a wrapper that enables you to download cartographic data for Peru directly from R.}")
    cli::cli_alert_info("{.emph Currently, `geoidep` supports data from the following providers:}")

    providers_data <- get_providers()
    providers <- c(if (is.data.frame(providers_data) && "provider" %in% names(providers_data)) {
      providers_data$provider[1:min(4, nrow(providers_data))] |> as.vector()
    } else character(),"and more!")

    for (provider in providers) {
      cli::cli_li("{.emph {provider}}")
    }

    cli::cli_alert_info("{.emph For more information, please use the `get_data_sources()` function.}")

    options(geoidep.shownWelcome = TRUE)
  }
}

