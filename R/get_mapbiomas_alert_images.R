#' #' Download before/after deforestation images from MapBiomas Alerta Peru
#' #'
#' #' @description
#' #' This function downloads satellite imagery (before/after deforestation) for specific MapBiomas Alerta alerts
#' #' from public Google Cloud Storage buckets.
#' #'
#' #' @param alert_ids Character vector or numeric vector. Alert IDs to download images for.
#' #' @param download_dir Character. Directory path where images will be saved.
#' #'   If NULL, creates a temporary directory.
#' #' @param image_type Character. Which images to download: "both" (default), "before", or "after".
#' #' @param show_progress Logical. If TRUE, shows progress bar during download.
#' #' @param overwrite Logical. If TRUE, overwrites existing files (default FALSE).
#' #'
#' #' @returns A data frame (tibble) with columns:
#' #'   - alert_id: The alert ID
#' #'   - image_type: "before" or "after"
#' #'   - url: Download URL
#' #'   - local_path: Path to downloaded file
#' #'   - status: "success" or "failed"
#' #'   - error_message: Error message if download failed
#' #'
#' #' @details
#' #' Images are downloaded from public Google Cloud Storage URLs. File names follow the pattern:
#' #' `alert_{id}_before_deforestation.png` and `alert_{id}_after_deforestation.png`
#' #'
#' #' The function uses HTTP GET requests with a 120-second timeout per image.
#' #'
#' #' @examples
#' #' \donttest{
#' #' library(geoidep)
#' #'
#' #' # Download images for specific alerts
#' #' # First get some alerts
#' #' aoi <- get_departaments(show_progress = FALSE) |>
#' #'   subset(nombdep == "UCAYALI")
#' #'
#' #' alerts <- get_mapbiomas_peru_alerta(region = aoi, show_progress = FALSE)
#' #'
#' #' # Get alert IDs
#' #' alert_ids <- alerts$id[1:5]  # First 5 alerts
#' #'
#' #' # Get images to a directory
#' #' download_dir <- file.path(tempdir(), "mapbiomas_images")
#' #' results <- get_mapbiomas_alert_images(
#' #'   alert_ids = alert_ids,
#' #'   download_dir = download_dir,
#' #'   show_progress = TRUE
#' #' )
#' #'
#' #' head(results)
#' #' }
#' #'
#' #' @export
#' get_mapbiomas_alert_images <- \(alert_ids, download_dir = NULL,
#'                                   image_type = "both", show_progress = TRUE,
#'                                   overwrite = FALSE) {
#'
#'   # Validate inputs
#'   if (is.null(alert_ids) || length(alert_ids) == 0) {
#'     cli::cli_abort("Parameter {.strong alert_ids} cannot be empty.")
#'   }
#'
#'   # Convert to character
#'   alert_ids <- as.character(alert_ids)
#'
#'   # Create download directory if needed
#'   if (is.null(download_dir)) {
#'     download_dir <- file.path(tempdir(), "mapbiomas_alerts_images")
#'   }
#'
#'   if (!dir.exists(download_dir)) {
#'     dir.create(download_dir, recursive = TRUE, showWarnings = FALSE)
#'   }
#'
#'   # Validate image_type
#'   if (!image_type %in% c("both", "before", "after")) {
#'     cli::cli_abort("Parameter {.strong image_type} must be 'both', 'before', or 'after'.")
#'   }
#'
#'   # Define image types to download
#'   if (image_type == "both") {
#'     types <- c("before", "after")
#'   } else {
#'     types <- image_type
#'   }
#'
#'   # Create download tasks
#'   download_tasks <- expand.grid(
#'     alert_id = alert_ids,
#'     image_type = types,
#'     stringsAsFactors = FALSE
#'   )
#'
#'   # Initialize results
#'   results <- list()
#'
#'   # Setup progress bar
#'   if (isTRUE(show_progress)) {
#'     pb <- progress::progress_bar$new(
#'       format = " Downloading images [:bar] :current/:total (:percent) ETA: :eta",
#'       total = nrow(download_tasks),
#'       clear = FALSE,
#'       width = 60
#'     )
#'   }
#'
#'   # Download each image
#'   for (i in seq_len(nrow(download_tasks))) {
#'     alert_id <- download_tasks$alert_id[i]
#'     img_type <- download_tasks$image_type[i]
#'
#'     # Construct URLs
#'     if (img_type == "before") {
#'       url <- glue::glue("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{alert_id}/before_deforestation.png")
#'       filename <- glue::glue("alert_{alert_id}_before_deforestation.png")
#'     } else {
#'       url <- glue::glue("https://storage.googleapis.com/alerta-public/IMAGES/initiatives/peru/{alert_id}/after_deforestation.png")
#'       filename <- glue::glue("alert_{alert_id}_after_deforestation.png")
#'     }
#'
#'     local_path <- file.path(download_dir, filename)
#'
#'     # Check if file exists
#'     if (file.exists(local_path) && !isTRUE(overwrite)) {
#'       status <- "skipped"
#'       error_msg <- "File already exists"
#'     } else {
#'       # Download
#'       tryCatch({
#'         download <- httr::GET(
#'           url,
#'           config = c(
#'             httr::config(ssl_verifypeer = FALSE),
#'             httr::timeout(seconds = 120)
#'           ),
#'           httr::write_disk(local_path, overwrite = TRUE)
#'         )
#'
#'         if (httr::http_error(download)) {
#'           status <- "failed"
#'           error_msg <- paste("HTTP", httr::status_code(download))
#'         } else {
#'           status <- "success"
#'           error_msg <- NA_character_
#'         }
#'       }, error = function(e) {
#'         status <<- "failed"
#'         error_msg <<- conditionMessage(e)
#'       })
#'     }
#'
#'     # Store result
#'     results[[i]] <- data.frame(
#'       alert_id = alert_id,
#'       image_type = img_type,
#'       url = url,
#'       local_path = local_path,
#'       status = status,
#'       error_message = error_msg,
#'       stringsAsFactors = FALSE
#'     )
#'
#'     # Update progress
#'     if (isTRUE(show_progress)) {
#'       pb$tick()
#'     }
#'   }
#'
#'   # Combine results
#'   results_df <- do.call(rbind, results) |>
#'     dplyr::as_tibble() |>
#'     dplyr::mutate(
#'       error_message = ifelse(is.na(error_message), "", error_message)
#'     )
#'
#'   # Print summary
#'   if (isTRUE(show_progress)) {
#'     cat("\n")
#'   }
#'   success_count <- sum(results_df$status == "success")
#'   failed_count <- sum(results_df$status == "failed")
#'   skipped_count <- sum(results_df$status == "skipped")
#'
#'   cli::cli_inform(c(
#'     "Download summary:",
#'     "✓" = "{success_count} images downloaded successfully",
#'     if (failed_count > 0) "✗" = "{failed_count} downloads failed",
#'     if (skipped_count > 0) "⊝" = "{skipped_count} images skipped (already exist)"
#'   ))
#'
#'   return(results_df)
#' }
