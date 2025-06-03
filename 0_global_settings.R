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


# Set paths
path <- paste0(getwd(), "/") # Working directory
codePath  <- paste0(path, "Scripts/")   # Location to store R scripts
dataPath  <- paste0(path, "Data/")      # Location to store tacsat (VMS) and eflalo (logbook) data
outPath   <- paste0(path, "Results/")   # Location to store the results
plotPath  <- paste0(path, "Plots/") 

# Create directories if they don't exist
dir.create(codePath, showWarnings = T)
dir.create(dataPath, showWarnings = T)
dir.create(outPath, showWarnings = T)
dir.create(plotPath, showWarnings = T)

#'------------------------------------------------------------------------------
# 0.2 Settings for analysis                                                 ----
#'------------------------------------------------------------------------------

# Setting thresholds
spThres       <- 20   # Maximum speed threshold in analyses in knots
intThres      <- 5    # Minimum difference in time interval in minutes to prevent pseudo duplicates
intvThres     <- 240  # Maximum difference in time interval in minutes to prevent unrealistic intervals
lanThres      <- 1.5  # Maximum difference in log10-transformed sorted weights

# Set the years to submit
yearsToSubmit <- c(2009:2023)

# Set the gear names for which automatic fishing activity is wanted
autoDetectionGears <- c("TBB","OTB","OTT", "OTM","SSC","SDN","DRB","PTB","HMD", "MIS")

# Decide if you want to visually analyze speed-histograms to identify fishing activity peaks
visualInspection <- TRUE

# Specify how landings should be distributed over the VMS pings
linkEflaloTacsat <- c("trip")

# Extract valid level 6 metiers 
valid_metiers <- data.table::fread("https://raw.githubusercontent.com/ices-eg/RCGs/master/Metiers/Reference_lists/RDB_ISSG_Metier_list.csv")$Metier_level6

