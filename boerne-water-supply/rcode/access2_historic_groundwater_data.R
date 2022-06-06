###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON & KYLE ONDA @ THE INTERNET OF WATER
# FEBRUARY 2021
# Run anytime... change county.list if desire. 
# Updated June 2021 by Sophia Bryson for TX.  
# Modified November 2021 by Vianey Rueda for Boerne
#
###################################################################################################################################################

######################################################################################################################################################################
#
#   ACCESS GROUNDWATER DATA FROM GOOGLE SPREADSHEET: CCGCD
#
######################################################################################################################################################################

#authenticate account
gs4_auth()
1

# number of sheets to be imported
sheet.number <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                  11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                  21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
                  31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
                  41, 42) #this is the part that changes
              
# create empty storage dfs
all.well.metadata <- matrix(nrow = 0, ncol = 26) %>% as.data.frame()
colnames(all.well.metadata) <- c("...1", "...2", "...3", "...4", "...5", "...6", "...7", "...8", "...9", "...10",                  
                                    "...11", "...12", "...13", "...14", "...15", "...16", "...17", "...18", "...19", "...20",                 
                                    "...21", "...22", "...23", "...24", "Long_Va", "Lat_Va")                
                                    

all.well.data <- matrix(nrow = 0, ncol = 4) %>% as.data.frame()
colnames(all.well.data) <- c("State_Numer", "...1", "...2", "...3")

# loop through sites and pull data
for(i in 1:length(sheet.number)) {
  gw.i.metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = sheet.number[i], range = "A2:X3", col_names = FALSE)
  gw.i.data <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = sheet.number[i], range = "A6:C", col_names = FALSE)
  gw.i.metadata$Long_Va <- gw.i.metadata [2,2]
  gw.i.metadata$Lat_Va <- gw.i.metadata [2,3]
  gw.i.metadata <- gw.i.metadata[-c(2), ]
  gw.i.metadata$Long_Va <- unlist(gw.i.metadata$Long_Va)
  gw.i.metadata$Lat_Va <- unlist(gw.i.metadata$Lat_Va)
  gw.i.data$State_Number <- gw.i.metadata [1,15]
  
  # Now bind it up to save out
  all.well.metadata <- rbind(all.well.metadata, gw.i.metadata)
  all.well.data <- rbind(all.well.data, gw.i.data)
  
  # Keep an eye on the progress:
  print(paste0("Completed pull for ", sheet.number[i], ". ", round(i*100/length(sheet.number), 2), "% complete."))
}

#clean up metadata
  #rename columns
  boerne_all_well_metadata <- rename(all.well.metadata, location = "...1", dec_long_va = "...2", dec_lat_va = "...3",
                                   elevation = "...4", elevation_at_mp = "...5", total_depth = "...6", casing_diameter = "...7",
                                   casing_type = "...8", casing_depth = "...9", cemented = "...10", estimated_gpm = "...11", aquifer = "...12",
                                   strata = "...13", district_id = "...14", state_id = "...15", avg_level = "...16", median_level = "...17",
                                   low = "...18", high = "...19", range = "...20", yrs_in_service = "...21", current = "...22", month = "...23", year = "...24", long_va = "Long_Va", lat_va = "Lat_Va")

  boerne_all_well_metadata$agency <- "CCGCD" #include agency that collects data

  #colnames(boerne_all_well_metadata)

  boerne_all_well_metadata <- as.data.frame(boerne_all_well_metadata) # change from a subclass to a data frame

  #remove spaces
  boerne_all_well_metadata$long_va <- gsub('\\s+', '', boerne_all_well_metadata$long_va)
  boerne_all_well_metadata$lat_va <- gsub('\\s+', '', boerne_all_well_metadata$lat_va)

  # change from list to numeric and/or string
  str(boerne_all_well_metadata)
  boerne_all_well_metadata$long_va <- as.numeric(boerne_all_well_metadata$long_va)
  boerne_all_well_metadata$lat_va <- as.numeric(boerne_all_well_metadata$lat_va)
  boerne_all_well_metadata$dec_long_va <- as.numeric(boerne_all_well_metadata$dec_long_va)
  boerne_all_well_metadata$dec_lat_va <- as.numeric(boerne_all_well_metadata$dec_lat_va)
  boerne_all_well_metadata$elevation <- as.numeric(boerne_all_well_metadata$elevation)
  boerne_all_well_metadata$elevation_at_mp <- as.numeric(boerne_all_well_metadata$elevation_at_mp)
  boerne_all_well_metadata$total_depth <- as.numeric(boerne_all_well_metadata$total_depth)
  boerne_all_well_metadata$month <- as.numeric(boerne_all_well_metadata$month)
  boerne_all_well_metadata$year <- as.numeric(boerne_all_well_metadata$year)
  boerne_all_well_metadata$location <- unlist(boerne_all_well_metadata$location)
  boerne_all_well_metadata$current <- unlist(boerne_all_well_metadata$current)
  str(boerne_all_well_metadata)

# save out
write.csv(boerne_all_well_metadata, paste0(swd_data, "gw/well_metadata.csv"), row.names = FALSE)


#clean up data
  #rename columns
  boerne_all_gw_levels <- rename(all.well.data, site = State_Number, date = "...1", depth_ft = "...2", elevation_at_waterlevel = "...3")
  #colnames(boerne_all_gw_levels)

  #double-check that each column is the desired type (numeric, character, etc.) and make necessary changes
  str(boerne_all_gw_levels)
  boerne_all_gw_levels$site <- unlist(boerne_all_gw_levels$site)
  boerne_all_gw_levels$date <- format(as.Date(boerne_all_gw_levels$date), "%Y-%m-%d")
  boerne_all_gw_levels <- as.data.frame(boerne_all_gw_levels)
  str(boerne_all_gw_levels)

  #add julian indexing
  nx <- boerne_all_gw_levels %>% mutate(year = year(date), day_month = substr(date, 6, 10))

  for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
    if(leap_year(nx$year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
    if(leap_year(nx$year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
  
    print(paste(round(i/nrow(nx)*100,2),"% complete"))
  }

  boerne_all_gw_levels <- nx

  boerne_all_gw_levels$agency <- "CCGCD" #include agency that collects data

  #limit data to 2000 and onward (earlier data is too sparse)
  boerne_all_gw_levels <- boerne_all_gw_levels %>% filter(year >= 2000)
  
  #remove missing data
  boerne_all_gw_levels <- na.omit(boerne_all_gw_levels)

  # filter data up to 2021
  boerne_all_gw_levels <- boerne_all_gw_levels %>% filter(year <= 2021)

  check.last.date <- boerne_all_gw_levels %>% filter(date == max(date)) %>% dplyr::select(date)
  table(check.last.date$date)

# save out
write.csv(boerne_all_gw_levels, paste0(swd_data, "gw/historic_gw_levels.csv"), row.names = FALSE)

#data frame w/o elevation
boerne_gw_depth <- select(boerne_all_gw_levels, c(1, 2, 4, 7))

write.csv(boerne_gw_depth, paste0(swd_data, "gw/historic_gw_depth.csv"), row.names=FALSE)

######################################################################################################################################################################
#
#   ACCESS GROUNDWATER DATA FROM GOOGLE SPREADSHEET: CITY DATA
#
######################################################################################################################################################################
#city_well_data <- read_sheet("https://docs.google.com/spreadsheets/d/1Mne3oTY8OUe_h_sXmBalG1CdWhFzsd7qje6SfwdcFLg/edit#gid=0", sheet = 1, range = "A3:J", col_names = FALSE)

#rename columns
#city_well_data <- rename(city_well_data, date = "...1", well_1 = "...2", well_2 = "...3",
#                         well_4 = "...4", well_6 = "...5", well_9 = "...6", well_10 = "...7",
#                         well_11 = "...8", well_13 = "...9", well_14 = "...10")
#reformat
well_1 <- select(city_well_data, c(1, 2)); well_1$well_num <- "well 1"; well_1 <- rename(well_1, depth_ft = "well_1")
well_2 <- select(city_well_data, c(1, 3)); well_2$well_num <- "well 2"; well_2 <- rename(well_2, depth_ft = "well_2")
well_4 <- select(city_well_data, c(1, 4)); well_4$well_num <- "well 4"; well_4 <- rename(well_4, depth_ft = "well_4")
well_6 <- select(city_well_data, c(1, 5)); well_6$well_num <- "well 6"; well_6 <- rename(well_6, depth_ft = "well_6")
well_9 <- select(city_well_data, c(1, 6)); well_9$well_num <- "well 9"; well_9 <- rename(well_9, depth_ft = "well_9")
well_10 <- select(city_well_data, c(1, 7)); well_10$well_num <- "well 10"; well_10 <- rename(well_10, depth_ft = "well_10")
well_11 <- select(city_well_data, c(1, 8)); well_11$well_num <- "well 11"; well_11 <- rename(well_11, depth_ft = "well_11")
well_13 <- select(city_well_data, c(1, 9)); well_13$well_num <- "well 13"; well_13 <- rename(well_13, depth_ft = "well_13")
well_14 <- select(city_well_data, c(1, 10)); well_14$well_num <- "well 14"; well_14 <- rename(well_14, depth_ft = "well_14")

city_well_data <- rbind (well_1, well_2, well_4, well_6, well_9, well_10, well_11, well_13, well_14)

#remove missing data
city_well_data <- na.omit(city_well_data) # went from 85482 obs to 7849 (the majority were NA since every day is listed)

#add julian indexing
nx <- city_well_data %>% mutate(year = year(date), day_month = substr(date, 6, 10))

for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
  if(leap_year(nx$year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
  if(leap_year(nx$year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
  
  print(paste(round(i/nrow(nx)*100,2),"% complete"))
}

city_well_data <- nx

#limit data to 2000 and onward (earlier data is too sparse)
city_well_data <- city_well_data %>% filter(year >= 2000)

# filter data up to 2021
city_well_data <- city_well_data %>% filter(year <= 2021)

check.last.date <- city_well_data %>% filter(date == max(date)) %>% dplyr::select(date)
table(check.last.date$date)

################################################################################################################################################################
# combine CCGCD and City data

both_datasets <- rbind(city_well_data, boerne_gw_depth)

write.csv(both_datasets, paste0(swd_data, "gw/boerne_gw_depth.csv"), row.names=FALSE)
################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])
