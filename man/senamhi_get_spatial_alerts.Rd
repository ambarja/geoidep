% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_senamhi.R
\name{senamhi_get_spatial_alerts}
\alias{senamhi_get_spatial_alerts}
\title{Download Meteorological Alerts from Senamhi}
\usage{
senamhi_get_spatial_alerts(
  data = NULL,
  nro = NULL,
  year = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE
)
}
\arguments{
\item{data}{A data frame containing information on weather warnings provided by Senamhi.}

\item{nro}{A numeric value representing the weather warning number.}

\item{year}{A numeric value indicating the year of publication of the weather warning.}

\item{dsn}{A character string specifying the output filename with the \bold{spatial format}. If missing, a temporary file will be created.}

\item{show_progress}{A logical value indicating whether to suppress the progress bar.}

\item{quiet}{A logical value indicating whether to suppress informational messages.}
}
\value{
An sf object containing the spatial geometries of the weather alerts.
}
\description{
This function downloads and loads the spatial format of the weather warnings provided by Senamhi.
These geometries represent preventive forecasts for severe events, indicating the areas that may be affected and the level of danger.
For more information, please visit the following link: \url{https://www.Senamhi.gob.pe/?&p=aviso-meteorologico}
}
\examples{
\donttest{
library(geoidep)
data <- senamhi_get_spatial_alerts(nro = 295, year = 2024, show_progress = FALSE)
head(data)
}
}
