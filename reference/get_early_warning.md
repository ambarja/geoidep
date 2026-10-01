# Download information on the latest deforestation alerts detected by Geobosque

Download deforestation alert information detected by Geobosque for any
polygon in Peru. The points come from the official vector service
`alertas_tempranas_pt_2026` (interop layer "Ultima semana") published at
[Geobosque
Interoperability](https://geobosques.minam.gob.pe/geobosque/view/servicios.php).
For more details, visit [Geobosque
Platform](https://geobosques.minam.gob.pe).

## Usage

``` r
get_early_warning(region, sf = TRUE, show_progress = TRUE)
```

## Arguments

- region:

  An sf object. Area of interest (must be EPSG:4326).

- sf:

  Logical. Return an `sf` object (`TRUE`) or a tibble (`FALSE`).

- show_progress:

  Logical. Show cli progress. Default `TRUE`.

## Value

A tibble or sf object with the alert points (`lng`, `lat`,
`fecha_alerta`, `dia_jul`, `mes_alerta`, `ubigeo`).

## Examples

``` r
if (FALSE) { # \dontrun{
library(geoidep)
loreto <- get_departaments(show_progress = FALSE) |> subset(nombdep == "LORETO")
warning_point <- get_early_warning(region = loreto, sf = TRUE, show_progress = FALSE)
head(warning_point)
} # }
```
