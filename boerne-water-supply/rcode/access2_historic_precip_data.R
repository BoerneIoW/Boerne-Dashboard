#######################################################################################################################################################
#
# Updates precipitation data based on historic data collected
# also updates forecast maps
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# Can be updated daily
# FEBRUARY 2021
#
# Sample code for accessing TexMesonet API data for Boerne, TX (Kendall County)
# Created Sophia Bryson @ THE INTERNET OF WATER. 
# Updated by Vianey Rueda
# February 2022
#
########################################################################################################################################################

##################################################################################################################################################################
#
#   Import Synoptic Data 
#
#################################################################################################################################################################
# Synoptic TexMesonet API definitions can be found here: 
# https://developers.synopticdata.com/mesonet/v2/stations/precipitation/

# Base URL & station ID list for API calls: 
   base.pcp.url <- "https://api.synopticdata.com/v2/stations/precip?stid=" #this is same for all sites
   site.ids <- c("cict2", "twb03", "gubt2", "gbft2", "gbkt2", "gbjt2", 
                 "gbrt2", "gbtt2", "gbvt2", "gbmt2", "gbst2", "gbdt2", "gbqt2",
                 "gupt2", "smct2", "ea004", "ea006", "ea035") #this is the part that changes
   
   start_date = "200301011200" # this is the format needed for the listed website above; the date is the earliest record
   end_date = "202112311200" #set a cut off for historic
   url_time_start = paste0("&start=",start_date)
   url_time_end = paste0("&end=",end_date)
   
   addl.pars.url <- "&pmode=intervals&interval=day&units=english" #this is same for all sites
   
   texmesonet.token <- "2517050a33774d43a7ff0557daf50271"
   url_token = paste0("&token=", texmesonet.token)

# Pull the data   
   # create empty storage dfs
      synoptic.all.station.metadata <- matrix(nrow = 0, ncol = 14) %>% as.data.frame()
      colnames(synoptic.all.station.metadata) <- c("STATUS", "MNET_ID", "ELEVATION", "NAME",                  
                                          "STID", "ELEV_DEM", "LONGITUDE", "STATE",                 
                                          "RESTRICTED", "LATITUDE", "TIMEZONE", "ID",                    
                                          "PERIOD_OF_RECORD.start", "PERIOD_OF_RECORD.end")
      
      synoptic.all.station.data <- matrix(nrow = 0, ncol = 8) %>% as.data.frame()
      colnames(synoptic.all.station.data) <- c("count", "first_report", "interval", "report_type", "last_report",
                                      "total", "station", "agency")
      
      # create a list of assigned stations to their agencies
      HADS <- c("CICT2", "GUBT2", "SMCT2")
      TWDB <- c("TWB03")
      EAA <- c("EA004", "EA006", "EA035")
      GBRA <- c("GBFT2", "GBKT2", "GBJT2", "GBRT2", "GBTT2", "GBVT2", "GBMT2", "GBST2", "GBDT2", "GBQT2")
      RAWS <- c("GUPT2")
                                
   # loop through sites and pull data
   for(i in 1:length(site.ids)) {
      api.url <- paste0(base.pcp.url, site.ids[i], url_time_start, url_time_end, addl.pars.url, url_token)
      api.return <- fromJSON(api.url, flatten = TRUE)
      api.station <- api.return$STATION
      api.station.metadata <- subset(api.station, select=-c(OBSERVATIONS.precipitation))
      api.station.data <- api.station$OBSERVATIONS.precipitation
      api.station.data <- do.call(rbind.data.frame, api.station.data)
      api.station.data$station <- api.station.metadata[1,5]
      api.station.data$agency <- case_when(
         api.station.data$station %in% HADS ~ "HADS",
         api.station.data$station %in% TWDB ~ "TWDB",
         api.station.data$station %in% EAA ~ "EAA", 
         api.station.data$station %in% GBRA ~ "GBRA",
         api.station.data$station %in% RAWS ~ "RAWS"
      )
      api.station.metadata$agency <- case_when(
         api.station.metadata$STID %in% HADS ~ "HADS",
         api.station.metadata$STID %in% TWDB ~ "TWDB",
         api.station.metadata$STID %in% EAA ~ "EAA", 
         api.station.metadata$STID %in% GBRA ~ "GBRA",
         api.station.metadata$STID %in% RAWS ~ "RAWS"
      )
      # Now bind it up to save out
      synoptic.all.station.metadata <- rbind(synoptic.all.station.metadata, api.station.metadata)
      synoptic.all.station.data <- rbind(synoptic.all.station.data, api.station.data)
      
      # Keep an eye on the progress:
      print(paste0("Completed pull for ", site.ids[i], ". ", round(i*100/length(site.ids), 2), "% complete."))
   }

      
# clean metadata
   synoptic.all.station.metadata2 <- select(synoptic.all.station.metadata, c(3, 4, 5, 7, 8, 10, 13, 14, 15))      
   synoptic.all.station.metadata2 <- rename(synoptic.all.station.metadata2, id = "STID", name = "NAME", latitude = "LATITUDE", longitude = "LONGITUDE",
                                state = "STATE", elevation = "ELEVATION", first_year = "PERIOD_OF_RECORD.start", last_year = "PERIOD_OF_RECORD.end")      

   #format start and end years to be only the year
   synoptic.all.station.metadata2$first_year <- year(synoptic.all.station.metadata2$first_year)
   synoptic.all.station.metadata2$last_year <- year(synoptic.all.station.metadata2$last_year)

   #convert station sites into an sf file
   synoptic.sites <- st_as_sf(synoptic.all.station.metadata2, coords = c("longitude", "latitude"), crs = 4326); 
   mapview::mapview(synoptic.sites)
            
# clean data
   synoptic.all.station.data2 <- select(synoptic.all.station.data, c(2, 5, 6, 7))

   # make sure there are no duplicates
   synoptic.all.station.data2 <- unique(synoptic.all.station.data2[c("station", "first_report", "last_report", "total")])

   # choose last report as the date and rename columns
   synoptic.all.station.data2 <- select(synoptic.all.station.data2, c(1, 3, 4))
   synoptic.all.station.data2 <- rename(synoptic.all.station.data2, id = "station", date = "last_report", pcp_in = "total")

   #format dates
   synoptic.all.station.data2$year <- year(synoptic.all.station.data2$date)
   synoptic.all.station.data2$month <- month(synoptic.all.station.data2$date)
   synoptic.all.station.data2$day <- day(synoptic.all.station.data2$date)
   synoptic.all.station.data2 <- synoptic.all.station.data2 %>% mutate(date = as.POSIXct(date, format = "%Y-%m-%d"))

   #check the last date
   check.last.date <- synoptic.all.station.data2 %>% filter(date == max(date)) %>% dplyr::select(date)
   table(check.last.date$date)
      
##################################################################################################################################################################
#
#   Import NOAA data  
#
#################################################################################################################################################################
# token for National Climatic Data Center (NCDC) API (now NCEI - National Center for Environmental Information). 
# Obtain unique token from: https://www.ncdc.noaa.gov/cdo-web/token
   ncdc_token <- 'xazWKRdECnwWdDDQVelRomkFPJctIhRy'
   state_fips = paste0("FIPS:", stateFips)
   
#lets find stations in TX
   noaa.stations <- ghcnd_stations()
   #takes a long time to run... save out file for later
   #write.csv(noaa.stations, paste0(swd_data,"pcp/noaa_stations.csv"), row.names = FALSE)
   #noaa.stations <- read.csv(paste0(swd_data,"pcp/noaa_stations.csv"))
   bkup <- noaa.stations;
   
# filter sites of relevance
   noaa.boerne.stations <- noaa.stations %>% filter(id=="USC00410902" | id=="USC00411429" | id=="USC00411433" | id=="USC00411434" | id=="USC00411920") #filter the specific site(s) of interest
   noaa.boerne.sites <- noaa.boerne.stations %>% filter(element == "PRCP")
   noaa.boerne.sites <- noaa.boerne.sites %>% filter(first_year <= 2015)
   noaa.boerne.sites <- noaa.boerne.sites %>% filter(last_year == current.year-1) 
   
#Or if we want daily summaries
   # Fetch more information about location id FIPS:48
   daily.stations <- ncdc_locs(datasetid = 'GHCND', locationcategoryid = "ST", token = ncdc_token) #Global Historical Climatological Network Daily
   # Fetch available locations for the GHCND (Daily Summaries) dataset
   ## change ST in locationcategoryid
   
# #Other datasets:
   # ncdc_locs(datasetid='GHCND', token = ncdc_token)
   # ncdc_locs(datasetid=c('GHCND', 'ANNUAL'), token = ncdc_token)
   # ncdc_locs(datasetid=c('GSOY', 'ANNUAL'), token = ncdc_token)
   # ncdc_locs(datasetid=c('GHCND', 'GSOM'), token = ncdc_token)
   
sites <- noaa.boerne.sites

#Pull and save out historic precip data. 
   #metadata: https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt
   #mflag is the measurement flag. 
   #qflag is the quality flag. 
   #sflag is the source flag. 
   
#parameters
   unique.stations <- unique(sites$id)
   
#create data frame
   noaa.all.station.data <- as.data.frame(matrix(nrow=0, ncol=9)); colnames(noaa.all.station.data) <- c("id","year","month","day","precip","mflag","qflag","sflag","date")
   values <- paste0("VALUE", seq(1,31,1));  mflag <- paste0("MFLAG", seq(1,31,1));  qflag <- paste0("QFLAG", seq(1,31,1));  sflag <- paste0("SFLAG", seq(1,31,1))
   
   
# Modify this to fit the number of unique sites you need to loop through 
   length(unique.stations) # Split up calls according to the number of unique stations
   dat.a <- ghcnd(stationid = unique.stations[1:5], token = ncdc_token)
   #dat.b <- ghcnd(stationid = unique.stations[100:199], token = ncdc_token)
   #dat.c <- ghcnd(stationid = unique.stations[200:299], token = ncdc_token)
   #dat.d <- ghcnd(stationid = unique.stations[300:399], token = ncdc_token)
   #dat.e <- ghcnd(stationid = unique.stations[400:length(unique.stations)], token = ncdc_token)
   #dat.f <- ghcnd(stationid = unique.stations[500:599], token = ncdc_token)
   #dat.g <- ghcnd(stationid = unique.stations[600:699], token = ncdc_token)
   #dat.h <- ghcnd(stationid = unique.stations[700:799], token = ncdc_token)
   #dat.i <- ghcnd(stationid = unique.stations[800:899], token = ncdc_token) # literally running for 8 hours...
   #dat.j <- ghcnd(stationid = unique.stations[900:999], token = ncdc_token)
   #dat.k <- ghcnd(stationid = unique.stations[1000:length(unique.stations)], token = ncdc_token) #catch all. Will be slower
   
#check and bind
   dat.all <- dat.a
   #dat.all <- rbind(dat.a, dat.b, dat.c, dat.d, dat.e, dat.f, dat.g, dat.h, dat.i, dat.j, dat.k); write.csv(dat.all, paste0(swd_data, "ghcnd_backup_full.csv"), row.names = FALSE)
   #rm(dat.a, dat.b, dat.c, dat.d, dat.e, dat.f, dat.g, dat.h, dat.i, dat.j, dat.k) #clear out
   
   
#filter and format data 
   dat1 <- dat.all
   dat <- dat1 %>% filter(year >= 1990) %>%  filter(element == "PRCP")
   
   dat2 <- dat %>% select(id, year, month, values) %>% gather(key = "day", value = "precip", -id, -year, -month)
   dat3 <- dat %>% select(id, year, month, all_of(mflag)) %>% gather(key = "day", value = "mflag", -id, -year, -month)
   dat4 <- dat %>% select(id, year, month, all_of(qflag)) %>% gather(key = "day", value = "qflag", -id, -year, -month)
   dat5 <- dat %>% select(id, year, month, all_of(sflag)) %>% gather(key = "day", value = "sflag", -id, -year, -month)
   
   dat <- cbind(dat2,dat3$mflag,dat4$qflag, dat5$sflag);  colnames(dat) <- c("id", "year", "month","day", "precip", "mflag", "qflag", "sflag")
   table(dat$mflag); #t means trace precip
   table(dat$qflag);
   table(dat$sflag); #N means COCORAHS; G means Offical systems, 0 or 7 means US COOP...
   
   dat <- dat %>% mutate(day = substr(day,6,7), date = as.Date(paste0(year,"-",month,"-",day), "%Y-%m-%d"))
#remove those dates that do not exist
   dat <- dat %>% filter(is.na(date)==FALSE)
   
noaa.all.station.data <- dat
   
summary(noaa.all.station.data)

#slim down data
   zt <- noaa.all.station.data %>% select(id, sflag) %>% distinct() 
   zt <- zt %>% filter(sflag != " "); length(unique(zt$id))
   zt <- zt %>% filter(sflag != "D") %>% filter(sflag != "Z"); length(unique(zt$id))
   zt <- zt %>% filter(sflag != "N"); length(unique(zt$id)) #206 sites that are not cocorhas
   
#filter data to those that are not cocorahs (CoCoRHaS - N - community collaboraitve rain, hail, snow. Z - Datzilla.)
   noaa.boerne.sites <- noaa.boerne.sites %>% filter(id %in% zt$id)
   noaa.all.station.data <- noaa.all.station.data %>% filter(id %in% noaa.boerne.sites$id)
   table(noaa.all.station.data$qflag);
   table(noaa.all.station.data$mflag)
   
#Assume NA is zero
   noaa.all.station.data[is.na(noaa.all.station.data)] <- 0
   
boerne.data <- noaa.all.station.data 

# clean metadata
   noaa.all.station.metadata <- noaa.boerne.sites
   noaa.all.station.metadata$agency <- "NOAA"
   noaa.all.station.metadata2 <- subset(noaa.all.station.metadata, select=-c(7, 8, 9))
   
#rename columns and minimize
   noaa.all.station.data <- boerne.data %>% select(id, date, precip) %>% mutate(precip = as.numeric(precip))
   colnames(noaa.all.station.data) <- c("id", "date", "pcp_in")
   
#convert date into year, month, day
   noaa.all.station.data <- noaa.all.station.data %>% mutate(date = as.Date(date, format="%Y-%m-%d"), year = year(date), month = month(date), day = day(date))
   noaa.all.station.data <- noaa.all.station.data %>% arrange(id, date) %>% distinct()
   table(noaa.all.station.data$id, noaa.all.station.data$year)

# make sure there are no duplicates
   noaa.all.station.data <- unique(noaa.all.station.data[c("date", "pcp_in", "id", "year", "month", "day")])

# filter data up until 2021
noaa.all.station.data2 <- noaa.all.station.data %>% filter(year <= 2021)
check.last.date <- noaa.all.station.data2 %>% group_by(id) %>% filter(is.na(pcp_in) == FALSE) %>% filter(date == max(date)) %>% dplyr::select(id, date, month)
table(substr(check.last.date$date,0,10))
   
#from tenths of a mm, to mm, to inches
   noaa.all.station.data2$pcp_mm <- noaa.all.station.data2$pcp_in/10
   noaa.all.station.data2$pcp_in <- noaa.all.station.data2$pcp_mm*0.0393701
   #truncate the number of decimals
      noaa.all.station.data2$pcp_in <- trunc(noaa.all.station.data2$pcp_in*100)/100
   #remove pcp_mm
      noaa.all.station.data2 <- subset(noaa.all.station.data2, select=-c(pcp_mm))
   
#convert station sites into an sf file
   noaa.sites <- st_as_sf(noaa.all.station.metadata, coords = c("longitude", "latitude"), crs = 4326); 
   mapview::mapview(noaa.sites)

##################################################################################################################################################################
#
#  Combine Synoptic and NOAA data 
#
#################################################################################################################################################################
#metadata
   all.station.metadata <- rbind(synoptic.all.station.metadata2, noaa.all.station.metadata2)
   all.sites <- st_as_sf(all.station.metadata, coords = c("longitude", "latitude"), crs = 4326); 
   mapview::mapview(all.sites)

write.csv(all.station.metadata, paste0(swd_data, "pcp/pcp_locations_metadata.csv"), row.names = FALSE)     
   
#data
   all.station.data <- rbind(synoptic.all.station.data2, noaa.all.station.data2)
   all.station.data <- all.station.data %>% mutate(date = as.Date(date)) # precaution to make sure all are in the same date format
   check.last.date <- all.station.data %>% filter(date == max(date)) %>% dplyr::select(date)
   table(check.last.date$date)

write.csv(all.station.data, paste0(swd_data, "pcp/historic_pcp_data.csv"), row.names = FALSE)

##################################################################################################################################################################
#
#   Create drought maps 
#
#################################################################################################################################################################

#load in hucs of interest
huc8 <- read_sf(paste0(swd_data, "huc8.geojson"))
huc.list <- huc8$huc8

end.date <- paste0("12/31/", current.year)

#create dataframe and pull new data
drought.time <- as.data.frame(matrix(nrow=0, ncol=9)); colnames(drought.time) <- c("huc8","name","date","none","d0","d1","d2","d3","d4")
for (m in 1:length(huc.list)){
   full_url <-paste0("https://usdmdataservices.unl.edu/api/HUCStatistics/GetDroughtSeverityStatisticsByAreaPercent?aoi=",huc.list[m],"&startdate=01/01/2000&enddate=", end.date, "&statisticsType=1")
   api.data <- GET(full_url, timeout(15000)) #use httr library to avoid timeout
   df <- content(api.data, "parse")
   for (i in 1:length(df)){
      zt.name <- as.character(subset(huc8, huc8==huc.list[m])$name)
      zt = tibble(
         huc8 = as.character(huc.list[m]),
         name = zt.name,
         date = df[[i]]$ValidStart,
         none = df[[i]]$None,
         d0 = df[[i]]$D0,
         d1 = df[[i]]$D1,
         d2 = df[[i]]$D2,
         d3 = df[[i]]$D3,
         d4 = df[[i]]$D4
      )
      drought.time <- rbind(drought.time, zt)
   }
   #print(zt.name)
   print(paste0(zt.name, ", ", round(m*100/length(huc.list), 2), "% complete"))
}
table(drought.time$huc8)
write.csv(drought.time, paste0(swd_data, "drought/drought_time.csv"), row.names = FALSE) #save out because it took 7 hours to run

#TAKES 25 SECONDS TO RUN FOR FULL YEAR... IN FUTURE WILL NEED TO SHORTEN
drought2 <- drought.time %>% mutate(date = as.Date(date, "%Y-%m-%d"), none = as.numeric(none), d0 = as.numeric(d0), d1 = as.numeric(d1), d2 = as.numeric(d2), d3=as.numeric(d3), d4=as.numeric(d4)) %>% arrange(huc8, date)
#it seems that drought is cumulative
drought2 <- drought2 %>% mutate(d4x = d4, d3x = d3 - d4, d2x = d2-d3, d1x = d1-d2, d0x = d0-d1)
#slim and save file
drought2 <- drought2 %>% select(huc8, name, date, none, d0x, d1x, d2x, d3x, d4x)
drought2 <- drought2 %>% arrange(huc8, date) %>% distinct()

write.csv(drought2, paste0(swd_data, "drought/percentAreaHUC.csv"), row.names = FALSE)

################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])
