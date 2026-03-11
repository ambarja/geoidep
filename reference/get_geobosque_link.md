# Geobosque API that returns data on forest stock, forest loss, forest loss by ranges for a given department, province and district.

Geobosque API that returns data on forest stock, forest loss, forest
loss by ranges for a given department, province and district.

## Usage

``` r
get_geobosque_link(type = NULL)
```

## Arguments

- type:

  A string. Select only one of the following layers; 'dist', 'pro',
  'dep'. Defaults to NULL.

## Value

A string containing the URL of the requested file.
