.welcome_message <- function() {
  cli::cli_h1("Welcome to geoidep")
  name.project <- cli::bg_black(cli::style_bold(cli::col_white("geoidep")))
  cli::cli_alert_info("{.emph {.href [{name.project}](https://geografo.pe/geoidep)} is a wrapper that enables you to download cartographic data for Peru directly from R.}")
  cli::cli_alert_info("{.emph Currently, `geoidep` supports data from the following providers:}")
  cli::cli_li("{.emph Geobosque}")
  cli::cli_li("{.emph INAIGEM}")
  cli::cli_li("{.emph INEI}")
  cli::cli_li("{.emph MTC}")
  cli::cli_li("{.emph and more!}")
  cli::cli_alert_info("{.emph For more information, please use the `get_data_sources()` function.}")
  invisible(NULL)
}

.onAttach <- function(libname, pkgname) {
  if (interactive() && !isTRUE(getOption("geoidep.shownWelcome"))) {
    .welcome_message()
    options(geoidep.shownWelcome = TRUE)
  }
}
