# Download INEI district boundaries

Download the latest version of the **geometry** and **ubigeos**
corresponding to the official political division of the district
boundaries of Peru. For more information, visit [INEI Spatial Data
Portal](https://ide.inei.gob.pe/).

## Usage

``` r
get_districts(
  departamento = NULL,
  provincia = NULL,
  distrito = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
```

## Arguments

- departamento:

  Character. Level-1 name. Case-insensitive.

- provincia:

  Character. Level-2 name. Case-insensitive.

- distrito:

  Character. Level-3 name. Case-insensitive.

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

## Details

- **\[stable\]**. Stable API.

- If no filter is supplied, the full national district dataset is
  returned.

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
dist <- get_districts(show_progress = FALSE)
head(dist)
lima <- get_districts(departamento = "lima", provincia = "lima", show_progress = FALSE)
head(lima)
} # }
```
