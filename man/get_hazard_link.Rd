% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{get_hazard_link}
\alias{get_hazard_link}
\title{Retrieve the links of the SIGRID for information on Disaster Risk Management.}
\usage{
get_hazard_link(type = NULL)
}
\arguments{
\item{type}{A string. Select only one from the list of available layers, for more information please use \code{get_data_sources(provider = "INAIGEM")}. Defaults to NULL.}
}
\value{
A string containing the URL of the requested file.
}
\description{
Retrieve the links of the SIGRID for information on Disaster Risk Management.
}
\keyword{internal}
