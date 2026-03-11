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
#> 1 DESCENSO DE TEMPERATURA NOCTURNA EN… 085 … 2026-0… 2026-… 2026… 47 Hrs.  NARA…
#> 2 LLUVIA EN LA SELVA                   084 … 2026-0… 2026-… 2026… 47 Hrs.  NARA…
#> 3 PRECIPITACIONES EN LA COSTA Y SIERRA 083 … 2026-0… 2026-… 2026… 47 Hrs.  NARA…
#> 4 LLUVIA EN LA SELVA                   082 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 5 PRECIPITACIONES EN LA SIERRA Y COST… 081 … 2026-0… 2026-… 2026… 71 Hrs.  NARA…
#> 6 PRECIPITACIONES EN LA SIERRA Y COST… 080   2026-0… 2026-… 2026… 47 Hrs.  NARA…
# }
```
