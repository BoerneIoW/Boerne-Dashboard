###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON & KYLE ONDA @ THE INTERNET OF WATER
# FEBRUARY 2021
# Run anytime... change county.list if desire. 
# Updated June 2021 by Sophia Bryson for TX.  
# Updated November 2021 by Vianey Rueda for Boerne
###################################################################################################################################################

######################################################################################################################################################################
#
#   ACCESS GROUNDWATER DATA FROM GOOGLE SPREADSHEET
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
write.csv(boerne_all_well_metadata, paste0(swd_data, "gw/boerne_well_metadata.csv"), row.names = FALSE)


boerne_all_gw_levels <- as.data.frame(boerne_all_gw_levels) # change from a subclass to a data frame

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

#remove missing data
boerne_all_gw_levels <- na.omit(boerne_all_gw_levels)

# filter data up to 2021
boerne_all_gw_levels <- boerne_all_gw_levels %>% filter(year <= 2021)

check.last.date <- boerne_all_gw_levels %>% filter(date == max(date)) %>% dplyr::select(date)
table(check.last.date$date)

# save out
write.csv(boerne_all_gw_levels, paste0(swd_data, "gw/boerne_gw_levels.csv"), row.names = FALSE)

#data frame w/o elevation
boerne_gw_depth <- select(boerne_all_gw_levels, c(1, 2, 4, 5,7))

write.csv(boerne_gw_depth, paste0(swd_data, "gw/boerne_gw_depth.csv"), row.names=FALSE)

######################################################################################################################################################################
# mapview of the sites
zt <- st_as_sf(boerne_all_well_metadata, coords = c("dec_long_va", "dec_lat_va"), crs = 4326, agr = "constant")
mapview::mapview(zt)

#visual check - temp
print(ggplot(boerne_all_gw_levels, aes(x = as.Date(date, format = "%Y-%m-%d"), y = -1*depth_ft)) +
        geom_line(color = "steel blue") + geom_point(color = "navy blue") + ggtitle(paste0("Index number: ", i)) +
        xlab("date") + scale_x_date(date_labels = "%Y-%m") +
        ylab("depth below surface (ft)") + ylim(-1.1*max(boerne_all_gw_levels$depth_ft), 0))


rm(all.well.metadata, all.well.data, gw.i.metadata, gw.i.data, boerne_all_gw_levels, boerne_all_well_metadata, boerne_gw_depth)
######################################################################################################################################################################
#
#   RUN STATS: NOT NEEDED TO BE SAVED OUT
#
######################################################################################################################################################################
#unique sites:
#unique.sites <- unique(boerne_all_gw_levels$site) #42 unique sites.

#set up data frame for stats and include year
#stats <- as.data.frame(matrix(nrow=0,ncol=13));        colnames(stats) <- c("site", "julian", "min", "flow10", "flow25", "flow50", "flow75", "flow90", "max", "Nobs","startYr","endYr","date"); 
#year.flow  <- as.data.frame(matrix(nrow=0, ncol=6));    colnames(year.flow) <- c("site", "agency", "date", "julian", "depth_ft")

#loop through and calculate stats - takes around 20 minutes
#for (i in 1:length(unique.sites)) {
#  zt <- boerne_all_gw_levels %>% filter(site == unique.sites[i]) #one site at a time
  #if (nrow(zt) < 365) {next} #skips over sites with less than a year of data on record - these break the stats & loop. Should only remove 1 site - "304013095220101" 
  
  #summarize by julian
#  zt.stats <- zt %>% group_by(julian) %>% summarize(Nobs = n(), min=round(min(depth_ft, na.rm=TRUE),4), flow10 = round(quantile(depth_ft, 0.10, na.rm=TRUE),4), flow25 = round(quantile(depth_ft, 0.25, na.rm=TRUE),4),
#                                                    flow50 = round(quantile(depth_ft, 0.5, na.rm=TRUE),4), flow75 = round(quantile(depth_ft, 0.75, na.rm=TRUE),4), flow90 = round(quantile(depth_ft, 0.90, na.rm=TRUE),4), 
#                                                    max = round(max(depth_ft, na.rm=TRUE),4),
#                                                    .groups="keep")
#  zt.stats <- zt.stats %>% mutate(site = as.character(unique.sites[i]), startYr = min(zt$year), endYr = max(zt$year)) %>% select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs, startYr, endYr)
  
#  if(dim(zt.stats)[1] == 366) {zt.stats$date2 = julian.ref$day_month_leap} #leap year indexing
#  if(dim(zt.stats)[1] < 366) { #non-leap year indexing. Robust against irregular data dates.
#    sub.jul <- julian.ref %>% filter(julian_index %in% zt.stats$julian) %>% select(day_month, julian_index)
#    zt.stats <- merge(zt.stats, sub.jul, by.x = "julian", by.y = "julian_index", all.x = TRUE) %>%
#      rename(date2 = day_month) %>% select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs,startYr,endYr, date2)
#  }
#  zt.stats$date <- format(zt.stats$date2, format="%b-%d")
  
  #fill dataframe
#  stats <- rbind(stats, zt.stats)
#  zt <- zt %>% select(site, agency, date, julian, depth_ft);    colnames(zt) <- c("site", "agency", "date", "julian", "depth_ft")
#  zt <- zt %>% group_by(site, date, julian) %>% summarize(depth_ft = median(depth_ft, na.rm=TRUE), .groups="drop")
#  year.flow <- rbind(year.flow, zt)
  
#  print(paste0(round(100*i/length(unique.sites),2),"% complete"))
#}

#summary(stats) 
#summary(year.flow)


#year.flow <- year.flow %>% filter(year(as.Date(date, format="%Y-%m-%d")) >= year(start.date))
#write.csv(year.flow, paste0(swd_data, "gw/boerne_gw_depth2.csv"), row.names=FALSE) # file doesn't have julian


