# Download Geographic Information from MIDAGRI

This function allows you to download the latest version of MIDAGRI
geographic data. For more information you can visit the following page
[Midagri Platform](https://siea.midagri.gob.pe/).

## Usage

``` r
get_midagri_data(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE)
```

## Arguments

- layer:

  A string. Specifies the layer to download. Available layers are
  detailed in the 'Details' section.

- dsn:

  Character. The output filename in **.shp or .gpkg** format. If not
  provided, a temporary file will be created.

- show_progress:

  Logical. If TRUE, displays a progress bar during the download.

- quiet:

  Logical. If TRUE, suppresses informational messages.

## Value

An `sf` object containing the downloaded geographic data.

## Details

**Note:** **\[deprecated\]**. This function is experimental and its API
may change in future versions.

Available layers are:

- **agriculture_sector:** Polygons representing the new national
  register of agricultural statistical sectors for the year 2024.

- **oil_palm_areas:** Polygons representing areas cultivated with oil
  palm in Peru for the period 2016 to 2020.

## Examples

``` r
# \donttest{
library(geoidep)
library(sf)
# Disable the use of S2 geometry for accurate spatial operations
sf_use_s2(use_s2 = FALSE)
#> Spherical geometry (s2) switched off

# Retrieve the polygon for Coronel Portillo province
coronel_portillo <- get_provinces(show_progress = FALSE)
names(coronel_portillo)
#> [1] "ccdd"     "ccpp"     "nombprov" "fuente"   "nombdep"  "geom"    

roi <- coronel_portillo |>
 subset(nombprov == "CORONEL PORTILLO") |>
 st_transform(crs = 32718)

oil_palm_areas <- get_midagri_data(layer = "oil_palm_areas", show_progress = FALSE) |>
 st_intersection(roi)
#> Error in curl::curl_fetch_disk(url, x$path, handle = handle): Timeout was reached [siea.midagri.gob.pe]:
#> Failed to connect to siea.midagri.gob.pe port 443 after 10000 ms: Timeout was reached

head(oil_palm_areas)
#> Error: object 'oil_palm_areas' not found
plot(st_geometry(oil_palm_areas))
#> Error: object 'oil_palm_areas' not found
# }
```
