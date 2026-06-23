"""geoidep — Datos geográficos del Perú gestionados por la IDEP.

Puerto Python del paquete R `geoidep` (autoría original: Antony Barja,
https://github.com/ambarja/geoidep). Esta versión preserva los nombres
de funciones del paquete R y devuelve objetos pandas / geopandas en
vez de tibble / sf.

Proveedores soportados:

- **INEI**     → :func:`get_departaments`, :func:`get_provinces`, :func:`get_districts`
- **Geobosque** → :func:`get_forest_loss_data`, :func:`get_early_warning`
- **Sernanp**   → :func:`get_sernanp_data`
- **Serfor**    → :func:`get_hotspots_data`, :func:`get_forest_fire_data`
- **MapBiomas** → :func:`get_mapbiomas_peru_lulc`, :func:`get_mapbiomas_peru_alerta`, :func:`get_mapbiomas_peru_fire`
- **MTC**       → :func:`get_mtc_data`
- **INAIGEM**   → :func:`get_inaigem_data`
- **SENAMHI**   → :func:`senamhi_get_meteorological_table`
- **SIGRID**    → :func:`get_hazard_data`
- **MIDAGRI**   → :func:`get_midagri_data`

Example
-------
>>> import geoidep as gd
>>> dep = gd.get_departaments()
>>> dep.head()
"""

from __future__ import annotations

__version__ = "0.2.0"

# Catálogo
from ._sources import get_data_sources, get_providers

# Geobosque
from .geobosque import get_early_warning, get_forest_loss_data

# INAIGEM
from .inaigem import get_inaigem_data, list_inaigem_layers

# INEI
from .inei import get_departaments, get_departments, get_districts, get_provinces

# MapBiomas
from .mapbiomas import (
    get_mapbiomas_alert_images,
    get_mapbiomas_peru_alerta,
    get_mapbiomas_peru_fire,
    get_mapbiomas_peru_fire_legend,
    get_mapbiomas_peru_fire_products,
    get_mapbiomas_peru_legend,
    get_mapbiomas_peru_lulc,
    get_mapbiomas_peru_lulc_series,
    get_mapbiomas_peru_lulc_url,
    plot_mapbiomas_fire,
    plot_mapbiomas_lulc,
)

# MIDAGRI
from .midagri import get_midagri_data, list_midagri_layers

# MTC
from .mtc import get_mtc_data, list_mtc_layers

# Paletas de colores
from .palettes import (
    mapbiomas_peru_fire_palette,
    mapbiomas_peru_fire_palette_by_id,
    mapbiomas_peru_lulc_palette,
    mapbiomas_peru_lulc_palette_by_id,
)

# SENAMHI
from .senamhi import (
    senamhi_alert_by_number,
    senamhi_alerts_by_year,
    senamhi_geometry_by_level,
    senamhi_get_meteorological_table,
    senamhi_get_spatial_alerts,
)

# Serfor
from .serfor import get_forest_fire_data, get_hotspots_data

# Sernanp
from .sernanp import get_sernanp_data, list_sernanp_layers

# SIGRID
from .sigrid import get_hazard_data, list_sigrid_layers

__all__ = [
    "__version__",
    # catálogo
    "get_data_sources",
    "get_providers",
    # INEI
    "get_departaments",
    "get_departments",
    "get_provinces",
    "get_districts",
    # Geobosque
    "get_forest_loss_data",
    "get_early_warning",
    # Sernanp
    "get_sernanp_data",
    "list_sernanp_layers",
    # Serfor
    "get_hotspots_data",
    "get_forest_fire_data",
    # MTC
    "get_mtc_data",
    "list_mtc_layers",
    # INAIGEM
    "get_inaigem_data",
    "list_inaigem_layers",
    # SIGRID
    "get_hazard_data",
    "list_sigrid_layers",
    # MIDAGRI
    "get_midagri_data",
    "list_midagri_layers",
    # SENAMHI
    "senamhi_get_meteorological_table",
    "senamhi_alert_by_number",
    "senamhi_alerts_by_year",
    "senamhi_get_spatial_alerts",
    "senamhi_geometry_by_level",
    # MapBiomas
    "get_mapbiomas_peru_lulc",
    "get_mapbiomas_peru_lulc_series",
    "get_mapbiomas_peru_lulc_url",
    "get_mapbiomas_peru_alerta",
    "get_mapbiomas_alert_images",
    "get_mapbiomas_peru_fire",
    "get_mapbiomas_peru_fire_products",
    "get_mapbiomas_peru_fire_legend",
    "get_mapbiomas_peru_legend",
    # Visualización
    "plot_mapbiomas_fire",
    "plot_mapbiomas_lulc",
    # Paletas
    "mapbiomas_peru_lulc_palette",
    "mapbiomas_peru_lulc_palette_by_id",
    "mapbiomas_peru_fire_palette",
    "mapbiomas_peru_fire_palette_by_id",
]
