# Geobosque data (MINAM)

Forest stock / loss statistics
([`get_forest_loss_data()`](https://geografo.pe/geoidep/reference/get_forest_loss_data.md))
and last-week deforestation alerts
([`get_early_warning()`](https://geografo.pe/geoidep/reference/get_early_warning.md))
from the Geobosque platform: <https://geobosques.minam.gob.pe>. The
forest-loss endpoint is a `GET` JSON API served by the current
Geobosques backend (<https://bosques-app.pe/geobosques/api-bosques>), so
progress is reported with a
[cli](https://cli.r-lib.org/reference/cli_progress_step.html) spinner.
