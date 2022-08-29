###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON & KYLE ONDA @ THE INTERNET OF WATER
# FEBRUARY 2021
# Run anytime... change county.list if desire. 
# Updated July 2021 by Sophia Bryson for TX. 
# Modified November 2021 by Vianey Rueda for Boerne
#
###################################################################################################################################################


######################################################################################################################################################################
#
#   READ IN GROUNDWATER SITES AND GROUNDWATER DATA
#
######################################################################################################################################################################
boerne.sites <- read.csv(paste0(swd_data, "gw/well_metadata.csv"))
old.data <- read.csv(paste0(swd_data, "gw/historic_gw_depth.csv")) %>% mutate(date = as.Date(date, format="%Y-%m-%d"))

#double-check that each column is the desired type (numeric, character, etc.) and make necessary changes
str(old.data) # site = chr; date = Date, format; julian = int; depth_ft = num
old.data$site <- as.character(old.data$site)
str(old.data)

######################################################################################################################################################################
#
# PULL IN GW LEVEL DATA DYNAMICALLY
#
#####################################################################################################################################################################
startDate <- max(old.data$date) + 1
endDate <- as.Date(today)

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


#clean up data
  #rename columns
  boerne_all_gw_levels <- rename(all.well.data, site = State_Number, date = "...1", depth_ft = "...2", elevation_at_waterlevel = "...3")
  colnames(boerne_all_gw_levels)
  
  #double-check that each column is the desired type (numeric, character, etc.) and make necessary changes
  str(boerne_all_gw_levels)
  boerne_all_gw_levels$site <- unlist(boerne_all_gw_levels$site)
  boerne_all_gw_levels$site <- as.character(boerne_all_gw_levels$site)
  boerne_all_gw_levels$date <- format(as.Date(boerne_all_gw_levels$date), "%Y-%m-%d")
  boerne_all_gw_levels <- as.data.frame(boerne_all_gw_levels)
  
  #remove na's
  boerne_all_gw_levels <- na.omit(boerne_all_gw_levels)
  boerne_all_gw_levels$depth_ft <- unlist(boerne_all_gw_levels$depth_ft)
  boerne_all_gw_levels <- na.omit(boerne_all_gw_levels)
  
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

  # filter data starting in 2022
  new_boerne_gw_levels <- boerne_all_gw_levels %>% filter(year >= 2022)
  new_boerne_gw_depth <- select(new_boerne_gw_levels, c(1, 2, 4, 7))

  check.last.date <- new_boerne_gw_depth %>% filter(date == max(date)) %>% dplyr::select(date)
  table(check.last.date$date)

  
#combine old and new
all_boerne_gw_depth <- rbind(old.data, new_boerne_gw_depth) %>% arrange(site, date)

#double-check that each column is the desired type (numeric, character, etc.) and make necessary changes
str(all_boerne_gw_depth) # site = chr; date = Date, format; julian = int; depth_ft = num
all_boerne_gw_depth$julian <- as.integer(all_boerne_gw_depth$julian)

write.csv(all_boerne_gw_depth, paste0(swd_data, "gw/all_gw_depth.csv"), row.names=FALSE)

#####################################################################################################################################################################

#given sparse daily data, aggregate to monthly and get average
year.flow <- all_boerne_gw_depth
year.flow$date2 <- floor_date(year.flow$date, "month")
year.flow2 <- year.flow %>% group_by(site, date2) %>% summarize(mean_depth_ft = mean(depth_ft))
year.flow2 <- year.flow2 %>% mutate(month = substr(date2, 6, 7))
year.flow <- year.flow2
year.flow$date2 <- as.character(year.flow$date2)
year.flow <- rename(year.flow, date = date2)

  #re-add julian indexing
    nx <- year.flow %>% mutate(year = year(date), day_month = substr(date, 6, 10))

    for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
     if(leap_year(nx$year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
      if(leap_year(nx$year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
  
     print(paste(round(i/nrow(nx)*100,2),"% complete"))
    }

    year.flow <- nx

#fix variable type to save out monthly averages
year.flow$month <- as.numeric(year.flow$month)
all_boerne_monthly_avg <- select(year.flow, c(1, 2, 3, 4, 5, 7))   
write.csv(all_boerne_monthly_avg, paste0(swd_data, "gw/all_monthly_avg.csv"), row.names=FALSE)


#stats calculations of daily data:
year.flow <- all_boerne_gw_depth  

#account for any duplicates
#  year.flow <- year.flow %>% group_by(site, date, julian) %>% summarize(depth_ft = median(depth_ft, na.rm=TRUE), .groups="drop")

stats <- as.data.frame(matrix(nrow=0,ncol=13));        colnames(stats) <- c("site", "julian", "min", "flow10", "flow25", "flow50", "flow75", "flow90", "max", "Nobs","startYr","endYr","date"); 

#Calculate stats for all data... this takes a long while to do in tidyverse... like to see it making progress in loop
unique.sites <- unique(year.flow$site)
for (i in 1:length(unique.sites)){
  zt <- year.flow %>% filter(site==unique.sites[i]) %>% mutate(year = year(date)) %>% filter(is.na(depth_ft)==FALSE)
  zt.stats <- zt %>% group_by(site, julian) %>% summarize(Nobs = n(), min=round(min(depth_ft, na.rm=TRUE),4), flow10 = round(quantile(depth_ft, 0.10, na.rm=TRUE),4), flow25 = round(quantile(depth_ft, 0.25, na.rm=TRUE),4),
                                                          flow50 = round(quantile(depth_ft, 0.5, na.rm=TRUE),4), flow75 = round(quantile(depth_ft, 0.75, na.rm=TRUE),4), flow90 = round(quantile(depth_ft, 0.90, na.rm=TRUE),4), 
                                                          max = round(max(depth_ft, na.rm=TRUE),4), .groups="drop")
  
  zt.stats <- zt.stats %>%  mutate(startYr = min(zt$year), endYr = max(zt$year)) %>% dplyr::select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs, startYr, endYr)
  zt.stats$date2 <- as.Date(zt.stats$julian, origin=paste0(current.year,"-01-01"))
  zt.stats$date <- format(zt.stats$date2, format="%b-%d")
  #if(dim(zt.stats)[1] == 366) {zt.stats$date = julian$month.day366}
  #if(dim(zt.stats)[1] < 366) { 
  #    zt.stats <- merge(zt.stats, julian[,c("julian", "month.day365")], by.x="julian", by.y="julian", all.x=TRUE)   
  #    zt.stats <- zt.stats %>% rename(date = month.day365)
  #} #assumes 365 days... could be wrong
  stats <- rbind(stats, zt.stats)
  print(paste(i, "is ", round(i/length(unique.sites)*100,2), "percent done"))
}
bk.up <- stats;

is.na(stats) <- sapply(stats, is.infinite)
summary(stats)
#stats <- stats %>% mutate(date2 = as.Date(paste0(current.year,"-",date), format="%Y-%b-%d")) %>% as.data.frame()

head(stats) %>% as.data.frame()

#remove sites that have not had new data in last year
if(month(today)>1){
  remove.site <- stats %>% filter(endYr < (current.year-1))  %>% select(site) %>% distinct()
}
######################################################################################################################################################################
#
# CREATE FILES FOR WEBSITE
#
#####################################################################################################################################################################
#Now attach most recent value to stream stats
recent.flow <- year.flow %>% group_by(site) %>% filter(is.na(depth_ft) == FALSE) %>% filter(date == max(date)) 
#skip the following line if in first month
if(month(today)>1){
  recent.flow <- recent.flow %>% filter(julian <= as.POSIXlt(today(), format = "%Y-%m-%d")$yday) %>% filter(site %notin% remove.site$site) #%>% rename(flow = depth_below_surface_ft)
}
current.stat <- merge(recent.flow[,c("site", "julian", "depth_ft")], stats, by.x=c("site","julian"), by.y=c("site","julian"), all.x=TRUE) 

#if else for this year and last years flow... I think flip this for gw
current.stat <- current.stat %>% mutate(status = ifelse(depth_ft <= flow10, "Extremely Wet", ifelse(depth_ft > flow10 & depth_ft <= flow25, "Very Wet", ifelse(depth_ft >= flow25 & depth_ft < flow50, "Moderately Wet", 
                                                                                                                                                               ifelse(depth_ft >= flow50 & depth_ft < flow75, "Moderately Dry", ifelse(depth_ft >= flow75 & depth_ft < flow90, "Very Dry", ifelse(depth_ft >= flow90, "Extremely Dry", "Unknown")))))))
current.stat$status <- ifelse(is.na(current.stat$status), "unknown", current.stat$status)
table(current.stat$status)

#set those that are not collecting data to unknown
max.julian <- current.stat %>% filter(endYr == current.year) %>% summarize(maxJ = max(julian, na.rm=TRUE))
current.stat <- current.stat %>% mutate(status = ifelse(endYr < current.year & julian < 300, "unknown", ifelse(endYr < (current.year-1), "unknown", 
                                                                                                               ifelse(endYr==current.year & julian < (max.julian$maxJ-60), "unknown", status))))
table(current.stat$status, useNA="ifany")

#merge to sites geojson
boerne.sites  <- boerne.sites %>% rename(site = state_id)
boerne.sites2 <- merge(boerne.sites, current.stat[,c("site","status","depth_ft","julian","date","flow50")], by.x="site", by.y="site") %>% distinct()
#convert to sf
boerne.sites2 <- st_as_sf(boerne.sites2, coords = c("dec_long_va", "dec_lat_va"), crs = 4326);
boerne.sites2 <- merge(boerne.sites2 %>% dplyr::select(-date), recent.flow[,c("site","date")], by.x="site", by.y="site", all.x=TRUE)
#Save out
boerne.sites2 <- boerne.sites2 %>% dplyr::select(agency, site, location, elevation, total_depth, aquifer, status, depth_ft, julian, flow50, date, geometry)
boerne.sites2 <- rename(boerne.sites2, AgencyCd = agency, SiteName = location, WellDepth = total_depth, LocalAquiferName = aquifer)
geojson_write(boerne.sites2, file=paste0(swd_data, "gw/all_gw_sites.geojson"))
#mapview::mapview(boerne.sites2)

#plot for fun
boerne.sites2 <- boerne.sites2 %>% mutate(colorStatus = ifelse(status=="Extremely Dry", "darkred", 
                                                               ifelse(status=="Very Dry", "red", 
                                                                      ifelse(status=="Moderately Dry", "orange", 
                                                                             ifelse(status=="Moderately Wet", "cornflowerblue",
                                                                                    ifelse(status=="Very Wet", "blue", 
                                                                                           ifelse(status=="Extremely Wet", "navy", "gray")))))))
leaflet() %>%  addProviderTiles("Stamen.TonerLite") %>% 
  addCircleMarkers(data = boerne.sites2, radius=4, fillOpacity= 0.8, fillColor = boerne.sites2$colorStatus, color="black", weight=0) 


#Now clip time series data to past two years and assign a depth based on stats
year.flow2 <- year.flow %>% filter(date >= as.Date(paste0((current.year-2),"-01-01"), "%Y-%m-%d"))#limits data to be only for past two years
stats2 <- merge(year.flow2[,c("site", "julian", "date", "depth_ft")], stats %>% dplyr::select(-date), by.x=c("site","julian"), by.y=c("site", "julian"), all.x=TRUE) %>% arrange(site, date)

stats2 <- stats2 %>% mutate(status = ifelse(depth_ft <= flow10, "Extremely Wet", ifelse(depth_ft > flow10 & depth_ft <= flow25, "Very Wet", ifelse(depth_ft >= flow25 & depth_ft < flow50, "Moderately Wet", 
                                                                                                                                                   ifelse(depth_ft >= flow50 & depth_ft < flow75, "Moderately Dry", ifelse(depth_ft >= flow75 & depth_ft < flow90, "Very Dry", ifelse(depth_ft >= flow90, "Extremely Dry", "Unknown")))))))
stats2$status <- ifelse(is.na(stats2$status), "unknown", stats2$status)
table(stats2$status, useNA="ifany")
stats2 <- stats2 %>% mutate(colorStatus = ifelse(status=="Extremely Dry", "darkred", ifelse(status=="Very Dry", "red", ifelse(status=="Moderately Dry", "orange", ifelse(status=="Moderately Wet", "cornflowerblue",
                                                                                                                                                                         ifelse(status=="Very Wet", "blue", ifelse(status=="Extremely Wet", "navy", "gray")))))))
stats2 <- stats2 %>% dplyr::select(site, julian, date, depth_ft, status, colorStatus) %>% filter(site %in% boerne.sites$site)
write.csv(stats2, paste0(swd_data, "gw/all_gw_status.csv"), row.names=FALSE)


#set up month names and save out stats file
my.month.name <- Vectorize(function(n) c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct","Nov", "Dec")[n])
recent.flow <- year.flow %>% group_by(site) %>% filter(date >= max(as.Date(paste0(current.year, "-01-01"), '%Y-%m-%d'))) 
stats.merge <- stats %>% mutate(date3 = date2, date2 = date) %>% dplyr::select(-date) %>% filter(site %in% boerne.sites$site)
current.stat2 <- merge(recent.flow, stats.merge, by.x=c("site","julian"), by.y=c("site","julian"), all.y=TRUE)%>% filter(site %in% boerne.sites2$site)

current.stat2 <- current.stat2 %>% mutate(month = my.month.name(as.numeric(substr(date,6,7)))) %>% mutate(date = date2, date2 = date3) %>% dplyr::select(-date3);  #okay to have NA for date because want chart to end there
write.csv(current.stat2, paste0(swd_data, "gw/all_gw_stats.csv"), row.names=FALSE)


#let's do annual trends
gw.annual <- year.flow %>% mutate(year = year(date)) %>% group_by(site, year) %>% summarize(medianDepth = median(depth_ft, na.rm=TRUE), nobsv = n(), .groups="drop") %>% 
  filter(site %in% boerne.sites2$site)
write.csv(gw.annual, paste0(swd_data, "gw/all_gw_annual.csv"), row.names=FALSE)

  
################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])
