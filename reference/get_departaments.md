# Download INEI departmental boundaries

Download the latest version of the **geometry** and **ubigeos**
corresponding to the official political division of the departament
boundaries of Peru. For more information, visit [INEI Spatial Data
Portal](https://ide.inei.gob.pe/).

## Usage

``` r
get_departaments(
  departamento = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- departamento:

  Character. Name or names in a vector of the level-1 administrative
  boundary (department) to query. Case-insensitive.

- dsn:

  Character. Directory where the file will be saved. If `NULL`, a
  temporary file is used.

- show_progress:

  Logical. Show a
  [cli](https://cli.r-lib.org/reference/cli_progress_bar.html) progress
  bar. Default `TRUE`.

- quiet:

  Logical. Suppress info message from
  [`sf::st_read()`](https://r-spatial.github.io/sf/reference/st_read.html).

- timeout:

  Numeric. Seconds to wait for a response. Default 60.

## Value

An sf object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
dep <- get_departaments(show_progress = FALSE)
head(dep)
loreto <- get_departaments(departamento = "loreto", show_progress = FALSE)
head(loreto)
} # }
```
