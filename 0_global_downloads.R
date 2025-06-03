#'------------------------------------------------------------------------------
# READ ME                                                                   
# The following script is a proposed workflow example to process the ICES
# VMS data call request. It is not an exact template to be applied to data from
# every member state and needs to be adjusted according to the data availability
# and needs of every national data set.
#
#'------------------------------------------------------------------------------

#'------------------------------------------------------------------------------
# Download the bathymetry and habitat files                                 ----
#'------------------------------------------------------------------------------
#'
#'To access the files needed for the habitat and bathymetry part of the workflow you need to download a zip file
#'containing both as sf objects in .rds formats. The script below should download and unzip the files into the
#'correct directory. If you have problems downloading the files, contact neil.campbell@ices.dk 

library(sf)

# Set paths
path <- paste0(getwd(), "/") # Working directory
#codePath  <- paste0(path, "Scripts/")   # Location to store R scripts
dataPath  <- paste0(path, "Data/")      # Location to store tacsat (VMS) and eflalo (logbook) data
#outPath   <- paste0(path, "Results/")   # Location to store the results
#plotPath  <- paste0(path, "Plots/") 

# Create directories if they don't exist
#dir.create(codePath, showWarnings = T)
dir.create(dataPath, showWarnings = T)
#dir.create(outPath, showWarnings = T)
#ir.create(plotPath, showWarnings = T)



#'------------------------------------------------------------------------------
# Download the bathymetry and habitat files                                 ----
#'------------------------------------------------------------------------------
#'
#'To access the files needed for the habitat and bathymetry part of the workflow you need to download a zip file
#'containing both as sf objects in .rds formats. The script below should download and unzip the files into the
#'correct directory. If you have problems downloading the files, contact neil.campbell@ices.dk 

if(!file.exists(paste0(dataPath, "hab_and_bathy_layers.zip"))) {
 
  shared_link <- "https://icesit.sharepoint.com/:u:/g/Efh5rtBiIhFPsnFcWXH-khYBKRBEHkEDjLHh4OFrMX68Vw?e=cubybi&download=1"
  local_path <- "Data/hab_and_bathy_layers.zip"
  


  download_large_file <- function(url, dest_file, file_size) {
    # Create a simple text-based progress bar using Base R
    progress_bar <- function(current, total, width = 60) {
      percent <- current / total
      filled <- round(width * percent)
      bar <- paste0(
        "[", 
        paste0(rep("=", filled), collapse = ""),
        paste0(rep(" ", width - filled), collapse = ""),
        "]"
      )
      
      # Calculate ETA
      elapsed_time <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
      eta <- if (percent > 0) {
        round((elapsed_time / percent) - elapsed_time)
      } else {
        NA
      }
      
      # Format ETA for display
      eta_str <- if (is.na(eta)) {
        "calculating..."
      } else if (eta < 60) {
        paste0(eta, "s")
      } else if (eta < 3600) {
        paste0(round(eta / 60), "m ", eta %% 60, "s")
      } else {
        paste0(round(eta / 3600), "h ", round((eta %% 3600) / 60), "m")
      }
      
      # Create the full progress string
      prog_str <- sprintf("  downloading %s %3d%% eta: %s", bar, round(percent * 100), eta_str)
      
      # Clear the line and write the progress
      cat("\r", prog_str, sep = "")
      if (current >= total) cat("\n")
      utils::flush.console()
    }
    
    # Store original timeout setting
    original_timeout <- getOption("timeout")
    
    # Temporarily increase timeout just for this function's scope
    options(timeout = 600)  
    # This gives a 10-minute timeout - if you have a slow internet connection you might need to increase this
    
    # Use on.exit to ensure the original timeout value is restored even if the function errors
    on.exit(options(timeout = original_timeout))
    
    # Record start time for ETA calculation
    start_time <- Sys.time()
    
    # Open connections
    con <- url(url, "rb")
    output <- file(dest_file, "wb")
    
    # Read and write in chunks with progress
    chunk_size <- 1024 * 1024  # 1MB chunks
    total_read <- 0
    
    tryCatch({
      repeat {
        data <- readBin(con, "raw", n = chunk_size)
        if (length(data) == 0) break
        writeBin(data, output)
        total_read <- total_read + length(data)
        
        # Update progress bar
        progress_bar(total_read, file_size)
      }
      
      message("Download complete!")
    }, 
    finally = {
      # Always close connections, even on error
      close(con)
      close(output)
    })
    
    return(invisible(dest_file))
  }
  
  
  download_large_file(shared_link, local_path, 1227481372)
  
}

unzip(zipfile = paste0(dataPath, "hab_and_bathy_layers.zip"), overwrite = TRUE, exdir = dataPath)


