% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_inaigem_data.R
\name{get_inaigem_data}
\alias{get_inaigem_data}
\title{Download the available data from INAIGEM}
\usage{
get_inaigem_data(
  layer = NULL,
  dsn = NULL,
  show_progress = TRUE,
  quiet = TRUE,
  timeout = 60
)
}
\arguments{
\item{layer}{Select only one from the list of available layers, for more information please use \code{get_data_sources(provider = "INAIGEM")}. Defaults to NULL.}

\item{dsn}{Character. Output filename with the \bold{spatial format}. If missing, a temporary file is created.}

\item{show_progress}{Logical. Suppress bar progress.}

\item{quiet}{Logical. Suppress info message.}

\item{timeout}{Seconds. Number of seconds to wait for a response until giving up. Cannot be less than 1 ms. Default is 60.}
}
\value{
An sf object.
}
\description{
This function allows you to download the latest version of data available on the INAIGEM geoportal.
For more information, you can visit the following web page: \href{https://geoportal.inaigem.gob.pe/}{INAIGEM Geoportal}
}
\examples{
\donttest{
library(geoidep)
library(sf)
glaciar <- get_inaigem_data(layer = "glaciares_1989" , show_progress = FALSE)
head(glaciar)
plot(st_geometry(glaciar))
}
}
