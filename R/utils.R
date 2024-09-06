#' Retrieve INEI Links of the Basic Cartographic Information
#' @param type String. One of 'districts', 'provinces', or 'departments'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_inei_link <- function(type = NULL) {
  inei_links <- c(
    districts = "https://ide.inei.gob.pe/files/Distrito.rar",
    provinces = "https://ide.inei.gob.pe/files/Provincia.rar",
    departments = "https://ide.inei.gob.pe/files/Departamento.rar"
  )

  if (!type %in% names(inei_links) || is.null(type)) {
    stop("Invalid type. Please choose from 'districts', 'provinces', or 'departments'.")
  }

  return(inei_links[[type]])
}

#' Reading a csv containing IDEP resources
#' @importFrom utils read.csv
#' @keywords internal
get_data <- function(){
  read.csv("https://raw.githubusercontent.com/ambarja/geoidep/main/inst/sources-idep/sources_geoidep.csv")
}


#' MIDAGRI links for obtaining cartographic information
#' @param type String. Select  'vegetation cover'. Defaults to NULL.
#' @return A string containing the URL of the requested file.
#' @keywords internal

get_midagri_link <- function(type = NULL){
  midagri_link <- c(
    "vegetation cover" = "https://archivos.midagri.gob.pe/index.php/s/deZQjkzmbodFyG6/download"
  )
  if (!type %in% names(midagri_link) || is.null(type)) {
    stop("Invalid type. Please choose from 'vegetation cover'")
  }
  return(midagri_link[[type]])
}
