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
#> 1 INCREMENTO DE TEMPERATURA DIURNA EN… 239 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 2 DESCENSO DE TEMPERATURA NOCTURNA EN… 238 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 3 INCREMENTO DE VIENTO EN LA COSTA     237 … 2026-0… 2026-… 2026… 71 Hrs.  AMAR…
#> 4 INCREMENTO DE VIENTO EN LA SIERRA N… 236 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 5 INCREMENTO DE VIENTO EN LA SIERRA N… 235   2026-0… 2026-… 2026… 47 Hrs.  AMAR…
#> 6 INCREMENTO DE TEMPERATURA DIURNA EN… 234 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
# }
```
