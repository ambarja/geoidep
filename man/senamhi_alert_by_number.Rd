% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_senamhi.R
\name{senamhi_alert_by_number}
\alias{senamhi_alert_by_number}
\title{Retrieve Senamhi's weather alert details using the warning number}
\usage{
senamhi_alert_by_number(nro = NULL)
}
\arguments{
\item{nro}{A numeric value. Represents the number of the weather warning issued by Senamhi.}
}
\value{
A tibble object containing the weather alert data.
}
\description{
This function obtains a table with the specified weather warning number.
For more information, please visit the following link: \url{https://www.Senamhi.gob.pe/?&p=aviso-meteorologico}
}
\examples{
\donttest{
library(geoidep)
data <- senamhi_alert_by_number(295)
head(data)
}
}
