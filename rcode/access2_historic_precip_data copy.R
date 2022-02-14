#######################################################################################################################################################
#
# Creates initial pull of precipitation data from NCDC (now NCEI)
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# FEBRUARY 2021
# Modified by Sophia Bryson from noaa_webservice_inital_pull.R for TX, June 2021 
#
########################################################################################################################################################

# use script as is and use IDs to filter sites of interest

###################################################################################################################################
#
#          Initial setup - API token
#
###################################################################################################################################
  
  # token for National Climatic Data Center (NCDC) API (now NCEI - National Center for Environmental Information). 
  # Obtain unique token from: https://www.ncdc.noaa.gov/cdo-web/token
    ncdc_token <- 'xazWKRdECnwWdDDQVelRomkFPJctIhRy'
    start_date = start.date
    end_date = today()
    state_fips = paste0("FIPS:", stateFips)

###################################################################################################################################
#
#          FIND NOAA STATIONS IN TX
#
###################################################################################################################################
    tex.mesonet.url <- ("https://www.texmesonet.org/#")
    raw_result <- httr::GET(tex.mesonet.url)
    str(raw_result)
    str(raw_result$content)
    
    content <- httr::content(raw_result, as = "text")
    content <- jsonlite::fromJSON(content)
    dplyr::glimpse(content_from_json)
  
  
  
  
    
  #lets find stations in TX
    noaa.stations <- ghcnd_stations()
  #takes a long time to run... save out file for later
    write.csv(noaa.stations, paste0(swd_data,"pcp/noaa_stations.csv"))
    noaa.stations <- read.csv(paste0(swd_data,"pcp/noaa_stations.csv"))
    noaa.stations <- subset(noaa.stations, select = -c(X)) # extra column created when importing
    bkup <- noaa.stations;
    
    
    boerne.stations <- noaa.stations %>% filter(id=="USC00410902" | id=="USC00411429" | id=="USC00411433" | id=="USC00411434" | id=="USC00411920") #filter the specific site(s) of interest
    boerne.sites <- boerne.stations %>% filter(element == "PRCP")
    boerne.sites <- boerne.sites %>% filter(first_year <= 2015)
    boerne.sites <- boerne.sites %>% filter(last_year == current.year-1) # without the -1 it returns 0 observations
    
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
      

  sites <- boerne.sites

###################################################################################################################################
#
#          GHCND Initial pull - LOOP THROUGH STATIONS TO PULL HISTORIC
#
###################################################################################################################################
  #Pull and save out historic precip data. 
  #metadata: https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt
      #mflag is the measurement flag. 
      #qflag is the quality flag. 
      #sflag is the source flag. 
  
  #parameters
  start.year <- year(start.date)
  start.month <- month(start.date)
  unique.stations <- unique(sites$id)
  
  #create data frame
  pcp.data <- as.data.frame(matrix(nrow=0, ncol=9)); colnames(pcp.data) <- c("id","year","month","day","precip","mflag","qflag","sflag","date")
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
    
    pcp.data <- dat
    
    summary(pcp.data)
    
  #clean up
    pcp.data <- pcp.data %>% mutate(date = as.Date(date, "%Y-%m-%d"))
    
    #slim down data
    zt <- pcp.data %>% select(id, sflag) %>% distinct() 
    zt <- zt %>% filter(sflag != " "); length(unique(zt$id))
    zt <- zt %>% filter(sflag != "D") %>% filter(sflag != "Z"); length(unique(zt$id))
    zt <- zt %>% filter(sflag != "N"); length(unique(zt$id)) #206 sites that are not cocorhas
    
    #filter data to those that are not cocorahs (CoCoRHaS - N - community collaboraitve rain, hail, snow. Z - Datzilla.)
    boerne.sites <- boerne.sites %>% filter(id %in% zt$id)
    pcp.data <- pcp.data %>% filter(id %in% boerne.sites$id)
    table(pcp.data$qflag);
    table(pcp.data$mflag)
    
    #Assume NA is zero
    pcp.data[is.na(pcp.data)] <- 0

  boerne.data <- pcp.data 
  boerne.loc <- boerne.sites
  
  #rename columns and minimize
  pcp.data <- boerne.data %>% select(id, date, precip) %>% mutate(precip = as.numeric(precip))
  colnames(pcp.data) <- c("id", "date", "pcp_in")
  
  #convert date into year, month, day
  pcp.data <- pcp.data %>% mutate(date = as.Date(date, format="%Y-%m-%d"), year = year(date), month = month(date), day = day(date))
  pcp.data <- pcp.data %>% arrange(id, date) %>% distinct()
  table(pcp.data$id, pcp.data$year)
  
  check.last.date <- pcp.data %>% group_by(id) %>% filter(is.na(pcp_in) == FALSE) %>% filter(date == max(date)) %>% dplyr::select(id, date, month)
  table(substr(check.last.date$date,0,10))
  
  #write out historic precip data
  write.csv(pcp.data, paste0(swd_data, "pcp/boerne_pcp_data.csv"), row.names = FALSE)
  
  #convert station sites into an sf file
  sites <- st_as_sf(boerne.loc, coords = c("longitude", "latitude"), crs = 4326); 
  mapview::mapview(sites)

  #Write out locations
  write.csv(boerne.loc, paste0(swd_data, "pcp/boerne_pcp_locations.csv"), row.names = FALSE)

#################################################################################
#
#   Create drought maps 
#
################################################################################

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

