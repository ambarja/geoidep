% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_midagri_data.R
\name{get_midagri_data}
\alias{get_midagri_data}
\title{Download Geographic Information from MIDAGRI}
\usage{
get_midagri_data(layer = NULL, dsn = NULL, show_progress = TRUE, quiet = TRUE)
}
\arguments{
\item{layer}{A string. Specifies the layer to download. Available layers are detailed in the 'Details' section.}

\item{dsn}{Character. The output filename in \bold{.shp or .gpkg} format. If not provided, a temporary file will be created.}

\item{show_progress}{Logical. If TRUE, displays a progress bar during the download.}

\item{quiet}{Logical. If TRUE, suppresses informational messages.}
}
\value{
An `sf` object containing the downloaded geographic data.
}
\description{
This function allows you to download the latest version of MIDAGRI geographic data.
For more information you can visit the following page  \href{https://siea.midagri.gob.pe/}{Midagri Platform}.
}
\details{
Available layers are:
\itemize{
  \item \bold{agriculture_sector:} Polygons representing the new national register of agricultural statistical sectors for the year 2024.
  \item \bold{oil_palm_areas:} Polygons representing areas cultivated with oil palm in Peru for the period 2016 to 2020.
}
}
\examples{
\donttest{
library(geoidep)
library(sf)
# Disable the use of S2 geometry for accurate spatial operations
sf_use_s2(use_s2 = FALSE)

# Retrieve the polygon for Coronel Portillo province
coronel_portillo <- get_provinces(show_progress = FALSE)
names(coronel_portillo)

roi <- coronel_portillo |>
 subset(nombprov == "CORONEL PORTILLO") |>
 st_transform(crs = 32718)

oil_palm_areas <- get_midagri_data(layer = "oil_palm_areas", show_progress = FALSE) |>
 st_intersection(roi)

head(oil_palm_areas)
plot(st_geometry(oil_palm_areas))
}
}
