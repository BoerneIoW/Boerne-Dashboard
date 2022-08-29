#######################################################################################################################################################
#
# DOWNLOADS AND CREATES GEOJSON FILES FOR MAP LAYERS IN THE WATER SUPPLY DASHBOARD
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER. 
# FEBRUARY 2021
# MODIFIED MAY 2021 BY SOPHIA BRYSON FOR TEXAS
#
########################################################################################################################################################

######################################################################################################################################################################
#
#   LOAD LIBRARIES
#
######################################################################################################################################################################
## First specify the packages of interest
packages = c("rstudioapi", "readxl", 
             "sf", "rgdal", "spData", "raster", "leaflet", "rmapshaper","geojsonio",
             "tidycensus", "jsonlite", "rvest", "purrr", "httr",
             "tidyverse", "lubridate", "plotly", "stringr", "rnoaa", "nhdplusTools",
             "googlesheets4", "magrittr", "dplyr", "ckanr")

## Now load or install&load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

#usgs packages
install.packages("dataRetrieval", repos=c("http://owi.usgs.gov/R", getOption("repos")))
library(dataRetrieval);  library(EGRET); #usgs links

######################################################################################################################################################################


######################################################################################################################################################################
#
#   SET GLOBAL VARIABLES
#
######################################################################################################################################################################
options(scipen=999) #changes scientific notation to numeric
rm(list=ls()) #removes anything stored in memory

#set working directory

# if working on a Windows use this to set working directory...
#source_path = rstudioapi::getActiveDocumentContext()$path 
#setwd(dirname(source_path))
#swd_data <- paste0("..\\data\\")

# if working on a Mac use this to set working directory...
source_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(source_path))
swd_data <- paste0("../data/")


#state info
stateAbb <- "TX"
stateFips <- 48


#variables used to update data
today = substr(Sys.time(),1,10); today;
current.year <- year(today);

start.date = "1990-01-01"; #set for the start of the period that we want to assess
end.date = paste0(year(today), "-12-31")
end.year = year(Sys.time())

mymonths <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"); #used below to convert numbers to abbrev

#save out update date for dashboard
update.date <- paste0(mymonths[month(today)]," ", day(today), ", ", end.year) %>% as.data.frame()
colnames(update.date) <- "today_date"
write.csv(update.date, paste0(swd_data, "update_date.csv"), row.names=FALSE)

#calculate moving average function
ma <- function(x,n=7){stats::filter(x,rep(1/n,n), sides=1)}

#useful functions
  `%notin%` = function(x,y) !(x %in% y); #function to get what is not in the list

  #standardized reference for setting julian values (drops leap days)
    jan1 <- as.Date("2021-01-01")
    dec31 <- as.Date("2021-12-31")
    julian_index <- c(seq(jan1:dec31), "NA")
    all.dates <- seq(as.Date(jan1), as.Date(dec31), by = "days")
    day_month <- c(substr(all.dates,6,10), "NA")
    day_month_leap <- c(day_month[1:59], "02-29", day_month[60:365])
    julian_index_leap <- (1:366)
    
    julian <- as.data.frame(matrix(nrow=366))
    julian$day_month <- day_month; julian$julian_index <- julian_index
    julian$day_month_leap <- day_month_leap; julian$julian_index_leap <- julian_index_leap
    julian.ref <- julian %>% select(!V1)
    rm(jan1, dec31, julian_index, all.dates, day_month,day_month_leap, julian_index_leap, julian)

    
