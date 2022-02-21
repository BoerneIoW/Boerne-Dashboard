#######################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# FEBRUARY 2021
# Run after acceess1_static_map_layers.rcode
# MODIFIED MAY 2021 BY SOPHIA BRYSON FOR TEXAS
# Modified November 2021 by Vianey Rueda for Boerne
#
########################################################################################################################################################

# Use code as is but use site ID to filter out sites of interest

######################################################################################################################################################################
#
#   USGS STREAM GAUGE DATA - CREATE MAP LAYER AND PULL HISTORIC DATA
#
######################################################################################################################################################################
# set up variables to retrieve USGS data - here mean daily data
pcode = '00060'; #discharge (cfs); #Identify parameter of interest: https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
scode = "00003";  #mean;  #Identify statistic code for daily values: https://help.waterdata.usgs.gov/code/stat_cd_nm_query?stat_nm_cd=%25&fmt=html
serv <- "dv"; #pick service... daily value



#################################################################################################################################
#What sites have data available and are currently collecting data?
tx.sites <- readNWISdata(stateCd=stateAbb, parameterCd = pcode, service = "site", seriesCatalogOutput=TRUE);
  length(unique(tx.sites$site_no))
  head(tx.sites)

#convert dates from character to date
tx.sites <- tx.sites %>% mutate(begin_year = as.numeric(substr(begin_date,1,4)), end_year = as.numeric(substr(end_date,1,4)))
#filter data to only keep if currently collecting data and has at least five years of data and located within the list of HUC8's serving utilities (could substring to make it huc6 if perferred)
tx.sites2 <- filter(tx.sites, parm_cd %in% pcode) %>% filter(stat_cd %in% scode) %>% filter(end_year == end.year) %>%  mutate(period = end_year-begin_year) %>% filter(period >= 5) 
  length(unique(tx.sites2$site_no))
tx.sites2 <- tx.sites2 %>% dplyr::select(site_no, station_nm, dec_lat_va, dec_long_va, huc_cd, begin_year, end_year, period)
  colnames(tx.sites2) <- c("site", "name", "latitude", "longitude", "huc8", "startYr", "endYr", "nYears")

# filter relevant sites
cibolocreek.site <- tx.sites2 %>% filter(site == "08183900"); cibolocreek.site$ws_watershed <- "Cibolo Creek"; 
guadaluperiver.site1 <- tx.sites2 %>% filter(site == "08167500"); guadaluperiver.site1$ws_watershed <- "Guadalupe River"
guadaluperiver.site2 <- tx.sites2 %>% filter(site == "08167800"); guadaluperiver.site2$ws_watershed <- "Guadalupe River"
relevant.sites <- rbind (cibolocreek.site, guadaluperiver.site1, guadaluperiver.site2) #bind the relevant sites  

#save metadata
write.csv(relevant.sites, paste0(swd_data, "streamflow/boerne_stream_metadata.csv"), row.names=FALSE)

#calculate unique sites
unique.sites <- unique(relevant.sites$site)

#for graphs - how far back do you want to see details? Right now set for last 2 years
dataYears = 2
yearFlowStart = end.year - dataYears;

#set up data frame for stats and include year
year.flow  <- as.data.frame(matrix(nrow=0, ncol=5));    colnames(year.flow) <- c("site", "date", "julian", "flow_cfs")

#Loop through each site, pulls data, and calculate statistics
for (i in 1:length(unique.sites)){
  zt <- readNWISdv(siteNumbers = unique.sites[i], parameterCd = pcode, statCd = scode, startDate=start.date, endDate = end.date)
    zt <- renameNWISColumns(zt)
      names(zt) [names(zt) == "FROM.DCP_Flow" ] <- "Flow"#needed to fix name discrepancy for site 07344210
  zt <- zt %>% mutate(julian = as.POSIXlt(Date, format = "%Y-%m-%d")$yday); #calculates julian date
  
  zt <- zt %>% dplyr::select(site_no, Date, julian, Flow);    colnames(zt) <- c("site", "date", "julian", "flow_cfs")
  zt <- zt %>% group_by(site, date, julian) %>% summarize(flow = median(flow_cfs, na.rm=TRUE), .groups="drop")
  
  year.flow <- rbind(year.flow, zt)
    
  print(paste0(i, " with ", round(i/length(unique.sites)*100,2), "% done"))
}
summary(year.flow)

#write files
write.csv(year.flow, paste0(swd_data, "streamflow/boerne_stream_data.csv"), row.names=FALSE)

#create geojson 
boerne_points <- st_as_sf(relevant.sites, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")
mapview::mapview(boerne_points)
geojson_write(boerne_points, file =  paste0(swd_data, "streamflow/boerne_stream_gauge_sites.geojson"))


################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])


  
  
  
  
