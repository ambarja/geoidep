# Download INEI province boundaries

Download the latest version of the **geometry** and **ubigeos**
corresponding to the official political division of the province
boundaries of Peru. For more information, visit [INEI Spatial Data
Portal](https://ide.inei.gob.pe/).

## Usage

``` r
get_provinces(
  departamento = NULL,
  provincia = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- departamento:

  Character. Name of the level-1 administrative boundary (department).
  Case-insensitive.

- provincia:

  Character. Name of the level-2 administrative boundary (province).
  Case-insensitive. Requires `departamento`.

- dsn:

  Character. Directory where the file will be saved. If `NULL`, a
  temporary file is used.

- show_progress:

  Logical. Show a
  [cli](https://cli.r-lib.org/reference/cli_progress_bar.html) progress
  bar.

- quiet:

  Logical. Suppress info message.

- timeout:

  Numeric. Seconds to wait for a response. Default 60.

## Value

An sf object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
prov <- get_provinces(show_progress = FALSE)
head(prov)
} # }
```
