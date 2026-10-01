# Introduction to geoidep

## 1. Introduction

This package aims to provide R users with a new way of accessing
official Peruvian cartographic data on various topics that are managed
by the country’s Spatial Data Infrastructure.

By offering a new approach to accessing this official data, both from
technical-scientific entities and from regional and local governments,
it facilitates the automation of processes, thereby optimizing the
analysis and use of geospatial information across various fields.

**However, this project is still under construction, for more
information you can visit the GitHub official repository
<https://github.com/ambarja/geoidep>.**

If you want to support this project, you can support me with a coffee
for my programming moments.

## 2. Package installation

``` r

install.packages("geoidep")
```

Also, you can install the development version as follows:

``` r

install.packages('pak')
pak::pkg_install('ambarja/geoidep')
```

``` r

library(geoidep)
```

## 3. Basic usage

``` r

providers
#> # A tibble: 280 × 7
#>    provider  category   layer layer_can_be_actived admin_en year  link_geoportal
#>    <chr>     <chr>      <chr> <lgl>                <chr>    <chr> <chr>         
#>  1 INEI      General    depa… TRUE                 Nationa… 2019  https://ide.i…
#>  2 INEI      General    prov… TRUE                 Nationa… 2019  https://ide.i…
#>  3 INEI      General    dist… TRUE                 Nationa… 2019  https://ide.i…
#>  4 Geobosque Forest     stoc… FALSE                Ministr… 2001… https://geobo…
#>  5 Geobosque Forest     stoc… TRUE                 Ministr… 2001… https://geobo…
#>  6 Geobosque Forest     stoc… TRUE                 Ministr… 2001… https://geobo…
#>  7 Geobosque Forest     stoc… TRUE                 Ministr… 2001… https://geobo…
#>  8 Geobosque Forest     warn… TRUE                 Ministr… last… https://geobo…
#>  9 Sernanp   Enviroment anp_… TRUE                 Ministr… Not … https://geo.s…
#> 10 Sernanp   Enviroment zona… TRUE                 Ministr… Not … https://geo.s…
#> # ℹ 270 more rows
```

``` r

layers_available
#> # A tibble: 12 × 2
#>    provider  layer_count
#>    <fct>           <int>
#>  1 Ana                50
#>  2 Ceplan             83
#>  3 Geobosque           5
#>  4 IGP                 2
#>  5 INAIGEM             5
#>  6 INEI                7
#>  7 MapBiomas           1
#>  8 MTC                26
#>  9 Oefa               68
#> 10 Senamhi             1
#> 11 Serfor              1
#> 12 Sernanp            31
```

## 4. Download Official Administrative Boundaries by INEI

``` r

# Region boundaries download (done once in the setup chunk above)
head(loreto_prov, 3)
```

    #> Live INEI/Geobosque examples were skipped: the data services are unreachable from this machine.

``` r

library(mapgl)
library(sf)
maplibre_view(data = loreto_prov)
```

## 5. Working with Geobosque data

``` r

my_fun <- function(x){
  data <- get_forest_loss_data(
    layer = 'stock_bosque_perdida_provincia',
    ubigeo = loreto_prov[["ubigeo"]][x],
    show_progress = FALSE )
  return(data)
}
historico_list <- lapply(X = 1:nrow(loreto_prov),FUN = my_fun)
historico_df <- do.call(rbind.data.frame,historico_list)
```

``` r

# The first five rows
head(historico_df)
```

## 6. Simple visualization with ggplot

``` r

library(ggplot2)
library(dplyr)

historico_prov <- historico_df |>
  inner_join(y = loreto_prov, by = "ubigeo")

promedio_loreto <- historico_prov |>
  group_by(anio) |>
  summarise(perdida = mean(perdida), .groups = "drop")
```

``` r

ggplot(historico_prov, aes(x = anio, y = perdida)) +
  geom_line(aes(group = nombprov, color = "Provincia"), linewidth = 0.6) +
  geom_line(
    data = promedio_loreto,
    aes(color = "Promedio Loreto"),
    linewidth = 0.6,
    linetype = "dashed",
    ) +
  scale_color_manual(name = NULL, values = c("Provincia" = "red", "Promedio Loreto" = "black")) +
  facet_wrap(nombprov ~ .) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom") +
  labs(
    title = "Pérdida de bosque 2001-2025: provincias de Loreto vs. promedio departamental",
    caption = "Fuente: Geobosque",
    x = "",
    y = "")
```
