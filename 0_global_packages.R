#'------------------------------------------------------------------------------
# READ ME                                                                   
# The following script is a proposed workflow example to process the ICES
# VMS data call request. It is not an exact template to be applied to data from
# every member state and needs to be adjusted according to the data availability
# and needs of every national data set.
#'------------------------------------------------------------------------------

#'------------------------------------------------------------------------------
# 0.1 Preparations                                                          ----
#'------------------------------------------------------------------------------

# Clear the workspace
rm(list=ls())


## Download and install required packages which are not available via CRAN

# Install devtools from CRAN
install.packages("devtools")

## Download and install the library required to interact with the ICES SharePoint site
library(devtools)

# Install ICES packages from ICES R-universe
# Force reinstallation to ensure we get the latest versions
install.packages(c("sfdSAR", "icesVocab", "icesConnect", "icesVMS"), 
                 repos = "https://ices-tools-prod.r-universe.dev",
                 force = TRUE)



# Download the VMStools .tar.gz file from GitHub
url <- "https://github.com/nielshintzen/vmstools/releases/download/0.77/vmstools_0.77.tar.gz"
download.file(url, destfile = "vmstools_0.77.tar.gz", mode = "wb")

# Install the library from the downloaded .tar.gz file
install.packages("vmstools_0.77.tar.gz", repos = NULL, type = "source")

# Clean up by removing the downloaded file
unlink("vmstools_0.77.tar.gz")


# Install required packages using pacman
if (!require("pacman")) install.packages("pacman")
pacman::p_load(vmstools, sf, data.table, raster, terra, mapview, Matrix, dplyr, 
               doBy, mixtools, tidyr, glue, gt, progressr, geosphere, purrr, 
               ggplot2, sfdSAR, icesVocab, generics, icesConnect, icesVMS,
               tidyverse, units, tcltk, lubridate, here)

