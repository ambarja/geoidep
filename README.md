# geoidep (Python)

📥 Puerto Python del paquete R [`geoidep`](https://github.com/ambarja/geoidep) — descarga datos cartográficos oficiales del Perú gestionados por la **Infraestructura de Datos Espaciales del Perú (IDEP)**.

> ⚠️ Esta versión Python no redistribuye datos: consulta los servicios públicos oficiales dinámicamente, igual que el paquete R original.

## Proveedores soportados

| Proveedor     | Funciones                                                                                   |
|---------------|---------------------------------------------------------------------------------------------|
| **INEI**      | `get_departaments`, `get_provinces`, `get_districts`                                        |
| **Geobosque** | `get_forest_loss_data`, `get_early_warning`                                                 |
| **Sernanp**   | `get_sernanp_data`, `list_sernanp_layers`                                                   |
| **Serfor**    | `get_hotspots_data`, `get_forest_fire_data`                                                 |
| **MTC**       | `get_mtc_data`, `list_mtc_layers`                                                           |
| **INAIGEM**   | `get_inaigem_data`, `list_inaigem_layers`                                                   |
| **SENAMHI**   | `senamhi_get_meteorological_table`, `senamhi_get_spatial_alerts`                            |
| **SIGRID**    | `get_hazard_data`, `list_sigrid_layers`                                                     |
| **MIDAGRI**   | `get_midagri_data`                                                                          |
| **MapBiomas Perú** | `get_mapbiomas_peru_lulc`, `get_mapbiomas_peru_alerta`, `get_mapbiomas_peru_fire` (extras opcionales) |

## Instalación

```bash
pip install geoidep                               # núcleo (todos los proveedores vectoriales)
pip install "geoidep[mapbiomas]"                  # añade rioxarray/rasterio para rásters MapBiomas
```

### Dependencia binaria de INEI

Las capas oficiales de INEI vienen empaquetadas en `.rar`. Necesitas además el binario `unrar`:

```bash
# Ubuntu / Debian
sudo apt install unrar

# macOS
brew install unrar

# Windows
# Descargar unrar.exe de https://www.rarlab.com/ y agregarlo al PATH
```

## Uso rápido

### Catálogo de fuentes

```python
import geoidep as gd

gd.get_providers()     # cuenta de capas por proveedor
gd.get_data_sources()  # tabla completa
gd.get_data_sources(query="INEI")
```

### Límites político-administrativos (INEI)

```python
dep    = gd.get_departaments()                  # los 24 departamentos + Callao
loreto = gd.get_departaments("LORETO")          # filtra por nombre (case-insensitive)
prov   = gd.get_provinces()
dist   = gd.get_districts("MIRAFLORES")
```

Devuelve un `geopandas.GeoDataFrame` en **EPSG:4326**.

### Pérdida histórica de bosque (Geobosque – MINAM)

```python
serie = gd.get_forest_loss_data(
    layer="stock_bosque_perdida_distrito",
    ubigeo="010101",          # 6 dígitos: distrito · 4: provincia · 2: departamento
)
serie.head()
```

### Alertas tempranas de deforestación

```python
amazonas = gd.get_departaments("AMAZONAS")
alertas  = gd.get_early_warning(amazonas, as_sf=True)
```

### Áreas Naturales Protegidas (SERNANP)

```python
gd.list_sernanp_layers()[:5]
anp = gd.get_sernanp_data("anp_nacional")
```

### Puntos de calor e incendios (SERFOR)

```python
calor      = gd.get_hotspots_data()
incendios  = gd.get_forest_fire_data()
```

### Transporte y comunicaciones (MTC)

```python
gd.list_mtc_layers()[:5]
aerodromos = gd.get_mtc_data("aerodromos_2023")
red_vial   = gd.get_mtc_data("red_vial_nacional_2024")
```

### Glaciares y lagunas (INAIGEM)

```python
gd.list_inaigem_layers()
glaciares = gd.get_inaigem_data("glaciares_2023")
lagunas   = gd.get_inaigem_data("lagunas_con_riesgo_desborde")
```

### Alertas meteorológicas (SENAMHI)

```python
avisos = gd.senamhi_get_meteorological_table()
avisos.head()

# Filtrar por número y descargar geometría
aviso = gd.senamhi_alert_by_number(avisos, 295)
geom  = gd.senamhi_get_spatial_alerts(data=aviso)
```

### Peligros y riesgos (SIGRID)

```python
gd.list_sigrid_layers()
inundaciones = gd.get_hazard_data("inundacion_inventario")
```

### Alertas de deforestación MapBiomas Alerta

```python
# Requiere `pip install "geoidep[mapbiomas]"`
ucayali = gd.get_departaments("UCAYALI")
alertas = gd.get_mapbiomas_peru_alerta(ucayali, from_date="2024-01-01")
alertas.head()
```

### Cobertura y uso de suelo (MapBiomas Perú LULC)

```python
# Requiere `pip install "geoidep[mapbiomas]"`
lima  = gd.get_departaments("LIMA")
lulc  = gd.get_mapbiomas_peru_lulc(year=2024, crop_to=lima)
serie = gd.get_mapbiomas_peru_lulc_series([2018, 2020, 2024], crop_to=lima)
```

Los rásters se leen de forma **perezosa** vía GDAL `/vsicurl/` — solo se descargan los bytes del extent solicitado.

### Incendios (MapBiomas Fuego Perú)

```python
gd.get_mapbiomas_peru_fire_products()
freq = gd.get_mapbiomas_peru_fire("frequency_burned", year=2024, crop_to=lima)
```

### Paletas de colores oficiales

```python
# Para visualización con matplotlib / plotly
lulc_palette = gd.mapbiomas_peru_lulc_palette("es")
fire_palette = gd.mapbiomas_peru_fire_palette("frequency_burned")
```

## Diferencias respecto al paquete R

| R (`sf` / `tibble`)                  | Python (este paquete)                       |
|--------------------------------------|---------------------------------------------|
| `sf` objects                         | `geopandas.GeoDataFrame`                    |
| `tibble`                             | `pandas.DataFrame`                          |
| `SpatRaster` (`terra`)               | `xarray.DataArray` (`rioxarray` + `rasterio`) |
| `httr::GET` / `httr::POST`           | `requests`                                  |
| `archive::archive_extract`           | `rarfile` (+ binario `unrar`)               |
| `rvest::read_html`                   | `beautifulsoup4`                            |

Los nombres de funciones se preservan para minimizar el costo de cambio entre R y Python.

## Desarrollo

```bash
git clone https://github.com/<tu-fork>/geoidep.git
cd geoidep
pip install -e ".[dev,mapbiomas]"
pytest
```

## Licencia

Apache-2.0. Trabajo derivado del paquete R `geoidep` de **Antony Barja** (ORCID: 0000-0001-5921-2858), redistribuido bajo la misma licencia.
