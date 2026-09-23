# Download Weather Alert Table from Senamhi

This function downloads the table of weather warnings provided by
Senamhi. For more information, please visit the following link:
<https://www.senamhi.gob.pe/?&p=aviso-meteorologico>

## Usage

``` r
senamhi_get_meteorological_table(show_progress = TRUE, timeout = 60)
```

## Arguments

- show_progress:

  Logical. Show a cli progress bar. Default `TRUE`.

- timeout:

  Numeric. Seconds to wait for the server response. Default 60.

## Value

A tibble object containing the weather alert data.

## Examples

``` r
if (FALSE) { # \dontrun{
data <- senamhi_get_meteorological_table(show_progress = FALSE)
head(data)
} # }
```
