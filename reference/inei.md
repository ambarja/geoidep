# INEI administrative boundaries

Download the official political-division geometries published by the
National Institute of Statistics and Informatics (INEI):
<https://ide.inei.gob.pe/>. All three helpers share the same download /
extract / read pipeline with a
[cli](https://cli.r-lib.org/reference/cli_progress_bar.html) progress
bar.

## Details

- [`get_departaments()`](https://geografo.pe/geoidep/reference/get_departaments.md)
  — level-1 (departamento).

- [`get_provinces()`](https://geografo.pe/geoidep/reference/get_provinces.md)
  — level-2 (provincia).

- [`get_districts()`](https://geografo.pe/geoidep/reference/get_districts.md)
  — level-3 (distrito).

Column names are normalised to lowercase (except the geometry column).
