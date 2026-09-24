# Local-environment hygiene: a system-wide PROJ_LIB/GDAL_DATA (e.g. from a
# PostgreSQL/PostGIS install) can point GDAL/PROJ at a stale proj.db and
# flood the suite with "DATABASE.LAYOUT.VERSION.MINOR" warnings.
# Point them at the data files bundled with sf itself (no-op on machines
# without the conflict).
if (requireNamespace("sf", quietly = TRUE)) {
  sf_proj <- system.file("proj", package = "sf")
  if (nzchar(sf_proj) && file.exists(file.path(sf_proj, "proj.db"))) {
    Sys.setenv(PROJ_LIB = sf_proj)
  }
  sf_gdal <- system.file("gdal", package = "sf")
  if (nzchar(sf_gdal) && length(list.files(sf_gdal)) > 0L) {
    Sys.setenv(GDAL_DATA = sf_gdal)
  }
}
