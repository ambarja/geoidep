# Download Weather Alert Table from Senamhi

This function downloads the table of weather warnings provided by
Senamhi. For more information, please visit the following link:
<https://www.Senamhi.gob.pe/?&p=aviso-meteorologico>

## Usage

``` r
senamhi_get_meteorological_table()
```

## Value

A tibble object containing the weather alert data.

## Examples

``` r
# \donttest{
data <- senamhi_get_meteorological_table()
#> Reading data from the website...
#> Data successfully uploaded.
head(data)
#> # A tibble: 6 × 7
#>   aviso                                nro   emision inicio fin   duracion nivel
#>   <chr>                                <chr> <chr>   <chr>  <chr> <chr>    <chr>
#> 1 INCREMENTO DE VIENTO EN LA SIERRA N… 235 … 2026-0… 2026-… 2026… 47 Hrs.  AMAR…
#> 2 INCREMENTO DE TEMPERATURA DIURNA EN… 234 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 3 PRECIPITACIONES EN LA COSTA NORTE Y… 233 … 2026-0… 2026-… 2026… 23 Hrs.  AMAR…
#> 4 LLUVIA EN LA SELVA (EXTENSIÓN DEL A… 232   2026-0… 2026-… 2026… 23 Hrs.  AMAR…
#> 5 INCREMENTO DE TEMPERATURA DIURNA EN… 231 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 6 DESCENSO DE TEMPERATURA NOCTURNA EN… 230   2026-0… 2026-… 2026… 47 Hrs.  ROJO 
# }
```
