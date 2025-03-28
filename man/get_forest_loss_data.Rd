% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_forest_loss_data.R
\name{get_forest_loss_data}
\alias{get_forest_loss_data}
\title{Download the forest and loss information from Geobosque}
\usage{
get_forest_loss_data(layer = NULL, ubigeo = NULL, show_progress = TRUE)
}
\arguments{
\item{layer}{A string.Specifies one of the following available layers; stock_bosque_perdida_distrito, stock_bosque_perdida_provincia, stock_bosque_perdida_departamento.}

\item{ubigeo}{A string Specifies the unique geographical code of interest.}

\item{show_progress}{Logical. Indicates whether to display the progress bar.}
}
\value{
A tibble object.
}
\description{
This function allows you to download the \bold{ubigeos} corresponding to the official political division
of the district, province or region boundaries of Peru with \bold{forest and loss information}.
For more information, you can visit the following website: \href{https://geobosques.minam.gob.pe}{Geobosque Platform}
}
\details{
Available layers are:
\itemize{
\item \bold{stock_bosque_perdida_distrito:} Returns data on forest stock, forest loss, rank loss for a given district.
\item \bold{stock_bosque_perdida_provincia:} Returns data on forest stock, forest loss, rank loss for a given province.
\item \bold{stock_bosque_perdida_departamento:} Returns data on forest stock, forest loss, rank loss for a given region.
}
}
\examples{
\donttest{
library(geoidep)
geobosque <- get_forest_loss_data(
    layer = "stock_bosque_perdida_distrito",
    ubigeo = "010101",
    show_progress = FALSE)
head(geobosque)
}
}
