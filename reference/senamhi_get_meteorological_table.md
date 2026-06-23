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
#> 1 CUARTO FRIAJE EN LA SELVA            251 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 2 INCREMENTO DE VIENTO EN LA COSTA     250 … 2026-0… 2026-… 2026… 47 Hrs.  NARA…
#> 3 DESCENSO DE TEMPERATURA NOCTURNA EN… 249 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 4 INCREMENTO DE VIENTO EN LA SIERRA C… 248 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 5 DESCENSO DE TEMPERATURA DIURNA EN L… 247 … 2026-0… 2026-… 2026… 85 Hrs.  ROJO 
#> 6 INCREMENTO DE VIENTO EN LA SELVA-CU… 246 … 2026-0… 2026-… 2026… 61 Hrs.  NARA…
# }
```
