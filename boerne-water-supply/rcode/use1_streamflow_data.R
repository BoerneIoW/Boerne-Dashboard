#######################################################################################################################################################
#
# Updates streamflow data based on historic data collected
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# FEBRUARY 2021
# Update daily if desire
# Updated by Sophia Bryson 6/1/2021 for TX
# Modified November 2021 by Vianey Rueda for Boerne
#
########################################################################################################################################################


#CALCULATE ROLLING AVERAGES MOVING FORWARD
#https://waterdata.usgs.gov/blog/moving-averages/
#owasa <- read_sf("https://geoconnex.us/ref/pws/NC0368010")

#################################################################################################################################
#       SET UP INFORMATION TO CALL API
#################################################################################################################################
#Identify parameter of interest: https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
pcode = '00060' #discharge (cfs)
#Identify statistic code for daily values: https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html
scode = "00003"  #mean
#pick service
serv <- "dv"


#################################################################################################################################
#
##############                               LOAD DATA
#
#################################################################################################################################
#Old Data
boerne.sites <- read_sf(paste0(swd_data, "streamflow/stream_gauge_sites.geojson")) %>% select(site, name, huc8, startYr, endYr, nYears, geometry,ws_watershed)
boerne.site.metadata <- read.csv(paste0(swd_data, "streamflow/stream_gauge_metadata.csv"))
boerne.data <- read.csv(paste0(swd_data, "streamflow/historic_stream_data.csv"), colClasses=c("site" = "character")) %>% mutate(date = as.Date(date, format="%Y-%m-%d"))
boerne.data <- boerne.data %>% group_by(site) %>% filter(date < max(date))

#ws.bounds <- read_sf(paste0(swd_data, "streamflow/boerne_ws_watersheds.geojson")) %>% select(geometry)
# this is NC ws watersheds 
#ws.bounds <- read_sf("/Users/VianeyRueda/Desktop/Boerne IoW/TriangleWaterSupplyDashboard-master/deploy/nc-water-supply/data/water_supply_watersheds.geojson") 
#################################################################################################################################
#
#                 IDENTIFY GAUGES WITH PWSID WATER SUPPLY WATERSHEDS 
#                 XX Not currently using supply watersheds for TX XX
#
#################################################################################################################################
##intersect together gauge location with watershed bounds
#gauges_huc <- st_intersection(boerne.sites, ws.bounds);
  
# #merge names together
# zt <- gauges_huc %>% as.data.frame() %>% select(site, STREAM_NAM) %>% distinct()
# nc.sites <- merge(nc.sites, zt, by.x="site", by.y="site", all.x=TRUE)
# table(tx.sites$STREAM_NAM, useNA="ifany")

#go through stream sites and calculate statistics
unique.sites <- unique(boerne.sites$site)
  
#set up data frame for stats and include year
year.flow  <- as.data.frame(matrix(nrow=0, ncol=4));    colnames(year.flow) <- c("site", "date", "julian", "flow")

#Loop through each site reads in new data
for (i in 1:length(unique.sites)){
  old.data <- boerne.data %>% filter(site==unique.sites[i]) %>% filter(date==max(date))

  zt <- readNWISuv(siteNumbers = unique.sites[i], parameterCd = pcode, startDate=(old.data$date[1]+1), endDate = end.date); #only read in new data
  zt <- renameNWISColumns(zt);
      names(zt) [names(zt) == "FROM.DCP_Flow" ] <- "Flow" 
  if (dim(zt)[1] > 0)  {
    zt <- zt %>% mutate(julian = as.POSIXlt(dateTime, format = "%Y-%m-%d")$yday) %>% mutate(date = as.Date(dateTime, format="%Y-%m-%d")); #calculates julian date
    #calculate mean value
    zt <- zt %>% group_by(site_no, julian, date) %>% summarize(Flow = median(Flow_Inst, na.rm=TRUE), .groups="drop")
   #In the streamflow data: The code summarizes the median 'Flow_Inst' at one point, but the data I've been pulling for TX has instantaneous flow for each total spillway releases, total reservoir discharge, and total tail race.
    
    zt <- zt %>% dplyr::select(site_no, date, julian, Flow);    colnames(zt) <- c("site", "date", "julian", "flow")
    zt <- zt %>% group_by(site, date, julian) %>% summarize(flow = median(flow, na.rm=TRUE), .groups="drop")
    
    year.flow <- rbind(year.flow, zt)
  }
    
 print(paste0(i, " is ", round(i/length(unique.sites)*100,2), "% done"))
}
summary(year.flow)

#bind old and new data
boerne.data <- rbind(boerne.data, year.flow) %>% arrange(site, date)
write.csv(boerne.data, paste0(swd_data, "streamflow/all_stream_data.csv"), row.names=FALSE)
#do rolling average etc next

#calculate 7 day rolling average (function is in global api)
#Check for missing days, if so, add NA rows: #https://waterdata.usgs.gov/blog/moving-averages/
year.flow  <- as.data.frame(matrix(nrow=0, ncol=4));    colnames(year.flow) <- c("site", "date", "julian", "flow")
stats <- as.data.frame(matrix(nrow=0,ncol=13));        colnames(stats) <- c("Site", "julian", "min", "flow10", "flow25", "flow50", "flow75", "flow90", "max", "Nobs","startYr","endYr","date"); 
for (i in 1:length(unique.sites)){
  zt <- boerne.data %>% filter(site==unique.sites[i])
  
  if(as.numeric(diff(range(zt$date))) != (nrow(zt)+1)){
    fullDates <- seq(from=min(zt$date), to = max(zt$date), by="1 day")
    fullDates <- data.frame(date = fullDates, stringsAsFactors = FALSE)
    zt <- full_join(zt, fullDates,by=c("date")) %>% arrange(date) %>% mutate(site=unique.sites[i], julian = as.POSIXlt(date, format = "%Y-%m-%d")$yday)
  }
  zt <- zt %>% mutate(rollMean=round(as.numeric(ma(flow)),4)) %>% mutate(year = year(date))
  
  #summarize annual
  zt.stats <- zt %>% group_by(site, julian) %>% summarize(Nobs = n(), min=round(min(rollMean, na.rm=TRUE),2), flow10 = round(quantile(rollMean, 0.10, na.rm=TRUE),2), flow25 = round(quantile(rollMean, 0.25, na.rm=TRUE),2),
                                                    flow50 = round(quantile(rollMean, 0.5, na.rm=TRUE),2), flow75 = round(quantile(rollMean, 0.75, na.rm=TRUE),2), flow90 = round(quantile(rollMean, 0.90, na.rm=TRUE),2), 
                                                    max = round(max(rollMean, na.rm=TRUE),2),  .groups="drop")
  
  zt.stats <- zt.stats %>% mutate(startYr = min(zt$year), endYr = max(zt$year)) %>% select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs, startYr, endYr)
  zt.stats$date2 <- as.Date(zt.stats$julian, origin=paste0(current.year,"-01-01"))
  zt.stats$date <- format(zt.stats$date2, format="%b-%d")
  
 # if(dim(zt.stats)[1] == 366) {zt.stats$date = julian$month.day366; }
#  if(dim(zt.stats)[1] == 365) {zt.stats$date = subset(julian, julian <= 364)$month.day365; }
  
  zt <- zt %>% filter(year>=(current.year-2)) %>% dplyr::select(site, date, julian, rollMean);    colnames(zt) <- c("site", "date", "julian", "flow")

#fill dataframe
  stats <- rbind(stats, zt.stats)
  year.flow <- rbind(year.flow, zt)
  print(paste0(i, " with ", round(i/length(unique.sites)*100,2), "% done"))
}
summary(stats)
summary(year.flow)

#for current stats - find out status of streamflow for sites and for flow points
  #set up date
  stats <- stats %>% mutate(date2 = as.Date(paste0(current.year,"-",date), "%Y-%b-%d")) %>% as.data.frame()

#Now attach most recent value to stream stats
recent.flow <- year.flow %>% group_by(site) %>% filter(is.na(flow)==FALSE) %>% filter(date == max(date))
current.stat <- merge(recent.flow[,c("site", "julian", "flow")], stats, by.x=c("site","julian"), by.y=c("site", "julian"))
current.stat <- current.stat %>% mutate(flow = round(flow, 2))

#if else
current.stat <- current.stat %>% mutate(status = ifelse(flow <= flow10, "Extremely Dry", ifelse(flow > flow10 & flow <= flow25, "Very Dry", ifelse(flow >= flow25 & flow < flow50, "Moderately Dry", 
                                                 ifelse(flow >= flow50 & flow < flow75, "Moderately Wet", ifelse(flow >= flow75 & flow < flow90, "Very Wet", ifelse(flow >= flow90, "Extremely Wet", "Unknown")))))))
current.stat$status <- ifelse(is.na(current.stat$status), "unknown", current.stat$status)
table(current.stat$status, useNA="ifany")
#set those that are not collecting data to unknown
current.stat <- current.stat %>% mutate(status = ifelse(endYr < current.year & julian > 30, "unknown", ifelse(endYr < (current.year-1), "unknown", status)))
table(current.stat$status)

#merge to geojson file with current status for map display
boerne.sites2 <- merge(boerne.sites, current.stat[,c("site","status","flow","julian","date","flow50")], by.x="site", by.y="site")
geojson_write(boerne.sites2, file=paste0(swd_data, "streamflow/all_stream_gauge_sites.geojson"))


#to create stats diagram with past and current year - need to make separate for dates and then rbind
year.flow2 <- year.flow %>% mutate(flow = round(flow, 2)) %>% filter(date >= as.Date(paste0(current.year, "-01-01"), "%Y-%m-%d"))
year.past <- year.flow %>% mutate(flow = round(flow, 2)) %>% filter(date >= as.Date(paste0((current.year-1),"-01-01"), "%Y-%m-%d") & date <= as.Date(paste0((current.year-1),"-12-31"), "%Y-%m-%d"))

stats2 <- merge(stats, year.flow2[,c("site", "julian", "flow")], by.x=c("site", "julian"), by.y=c("site", "julian"), all.x=TRUE)
stats.past <- merge(stats, year.past[,c("site", "julian", "flow")], by.x=c("site", "julian"), by.y=c("site", "julian"), all.x=TRUE) %>% mutate(date2 = as.Date(paste0((current.year-1),"-",date), "%Y-%b-%d")) %>% as.data.frame()
stats2 <- rbind(stats.past, stats2)

#stats2 <- stats2 %>% mutate(perFlow = round(flow/flow50*100,2)); summary(stats2)
stats2 <- stats2 %>% mutate(status = ifelse(flow <= flow10, "Extremely Dry", ifelse(flow > flow10 & flow <= flow25, "Very Dry", ifelse(flow >= flow25 & flow < flow50, "Moderately Dry", 
                                            ifelse(flow >= flow50 & flow < flow75, "Moderately Wet", ifelse(flow >= flow75 & flow < flow90, "Very Wet", ifelse(flow >= flow90, "Extremely Wet", "Unknown")))))))
#stats2 <- stats2 %>% mutate(month = substr(date,0,3))
stats2 <- stats2 %>% mutate(colorStatus = ifelse(status=="Extremely Dry", "darkred", ifelse(status=="Very Dry", "red", ifelse(status=="Moderately Dry", "orange", ifelse(status=="Moderately Wet", "cornflowerblue",
                                          ifelse(status=="Very Wet", "blue", ifelse(status=="Extremely Wet", "navy", "gray"))))))) %>% mutate(colorStatus = ifelse(is.na(colorStatus), "gray", colorStatus))
stats2 <- stats2 %>% arrange(site, date2)
table(stats2$status, useNA="ifany")
table(stats2$colorStatus, useNA="ifany")

#write out the csv to draw daily flow based on stream status
write.csv(stats2, paste0(swd_data, "streamflow/all_stream_stats.csv"), row.names=FALSE)


# #write out the current status for water supply watershed 
current.stat2 <- current.stat %>% select(site, julian, date, status) %>% mutate(month = substr(date,0,3))
site.huc <- cbind(boerne.sites2$site, boerne.sites2$huc8, boerne.sites2$ws_watershed) %>% as.data.frame(); colnames(site.huc) <- c("site", "huc8", "ws_watershed")
current.stat2 <- merge(current.stat2, site.huc, by.x="site", by.y="site", all.x=TRUE)
write.csv(current.stat2, paste0(swd_data, "streamflow/current_sites_status.csv"), row.names=FALSE)


# #copy over to triangle - NOT DONE FOR TX AS NO SPECIFIED AREA OF INTEREST BUT RETAINED IN CASE ADDED LATER
# t.sites <- read.csv("..//data//streamflow//sites_status.csv", colClasses = c("site" = "character"))
# t.sites2 <- nc.sites2 %>% filter(site %in% t.sites$site)
# geojson_write(t.sites2, file="../data/streamflow/stream_gauge_sites.geojson")
# 
# t.all <- all.data %>% filter(site %in% t.sites$site)
# write.csv(t.all, "..//data//streamflow//all_stream_data.csv", row.names=FALSE)
# 
# t.stats2 <- stats2 %>% filter(site %in% t.sites$site)
# write.csv(t.stats2, "..//data//streamflow//stream_stats.csv", row.names=FALSE)
# 
# t.current <- current.stat2 %>% filter(site %in% t.sites$site)
# write.csv(t.current, "..//data//streamflow//sites_status.csv", row.names=FALSE)


################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])



