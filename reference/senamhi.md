# SENAMHI weather alerts

Meteorological warning tables and alert geometries from SENAMHI:
<https://www.senamhi.gob.pe/?&p=aviso-meteorologico>. Progress is
reported with
[cli](https://cli.r-lib.org/reference/cli_progress_bar.html); the legacy
`progress::progress_bar` dependency was removed.

Only two functions hit the network
([`senamhi_get_meteorological_table()`](https://geografo.pe/geoidep/reference/senamhi_get_meteorological_table.md)
and
[`senamhi_get_spatial_alerts()`](https://geografo.pe/geoidep/reference/senamhi_get_spatial_alerts.md));
the remaining three are pure in-memory filters kept for convenience.
