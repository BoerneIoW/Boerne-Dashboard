#######################################################################################################################################################
#
# Updates reservoir  data based on historic data collected
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# FEBRUARY 2021
# Can update anytime
# Modified June 2021 by SOphia Bryson for TX, including USACE and USBR dam sites
#
########################################################################################################################################################

# Process: 
# load old usace, usbr, combined data
# pull new usace data. combine with old usace data.
# pull new usbr data. combine with old usbr data.
# combine usace and usbr updates and update combined data. 


######################################################################################################################################################################
#
#   LOAD Old Data - make sure parameters to update don't miss any data
#
######################################################################################################################################################################
#Now read in the website data and add the most recent files to the end of it
old.data.all <- read.csv(paste0(swd_data, "reservoirs/usace_usbr_dams.csv"))
old.data.usace <- read.csv(paste0(swd_data, "reservoirs/usace_dams.csv"))


last.update <- max(old.data.all$date); today <- as.Date(substr(Sys.time(),1,10), "%Y-%m-%d")
difftime(today, last.update, units = "weeks") #time diff check since last update
timeAmt = 2
timeUnit = "weeks"


########################################################################################################################################
####### UPDATE ARMY CORPS ##############################################################################################################
########################################################################################################################################

    ######################################################################################################################################################################
    #
    #   UPDATE USACE WITH RECENT DATA: CANYON LAKE IS IN THIS DATASET 
    #   
    ######################################################################################################################################################################
    # #set up url
    # baseURL = 'https://water.usace.army.mil/a2w/'
    # report_url = "CWMS_CRREL.cwms_data_api.get_report_json?p_location_id="
    # parameter_url <- paste0("&p_parameter_type=Stor%3AElev&p_last=", timeAmt, "&p_last_unit=", timeUnit, "&p_unit_system=EN&p_format=JSON");   
    
    #read in shapefile
    project.df <- read_sf(paste0(swd_data, "reservoirs/usace_sites.geojson"))
    ace.df <- project.df
    #add url to data
    res.url <- "http://water.usace.army.mil/a2w/f?p=100:1:0::::P1_LINK:"
    project.df <- project.df %>% mutate(url_link = paste0(res.url,Loc_ID,"-CWMS"))
    
    # Loop prep
      
      #District list
      tx.dist <- c("SWF", "SWT", "SWG", "ABQ")
      data.dist <- unique(project.df$District)
      tx.dist <- tx.dist[tx.dist %in% data.dist == TRUE] #No dams in ABQ
      
      # API URL building blocks
      baseURL = 'https://water.usace.army.mil/a2w/'
      last_number = timeAmt; #number of units to collect  
      last_unit = timeUnit; #other options are months, weeks, and days
      report_url = "CWMS_CRREL.cwms_data_api.get_report_json?p_location_id="
      parameter_url <- paste0("&p_parameter_type=Stor%3AElev&p_last=", last_number, "&p_last_unit=", last_unit, "&p_unit_system=EN&p_format=JSON")
      
      # Create final data frame
      all_district_data <- as.data.frame(matrix(nrow=0, ncol=8)); colnames(all_district_data) <- c("date", "elev_Ft", "storage_AF", "fstorage_AF", "locid", "district", "NIDID", "name")
    
    # Pull new data for all sites in all districts
    
      for(j in 1:length(tx.dist)){ #loop through districts

        district.id = tx.dist[j];
        
        district_data <- as.data.frame(matrix(nrow=0, ncol=8)); colnames(district_data) <- c("date", "elev_Ft", "storage_AF", "fstorage_AF", "locid", "district", "NIDID", "name")
        zt <- subset(project.df, District==district.id) %>% filter(str_detect(string = NIDID, pattern = "TX")) %>% filter(Loc_ID != 2165051) #Only TX, drop Truscott Brine Lake - no outward flow, no active mgmt - & different data structure breaks the loop
        
        for (i in 1:length(zt$Loc_ID)){ #loop through sites within districts

          location.id <- zt$Loc_ID[i]; location.id

          full_url <- paste0(baseURL, report_url, location.id, parameter_url)
          
          api.data <- GET(full_url, timeout(15000)) #use httr library to avoid timeout #CAN INCREASE IF TIMING OUT

          dam.data <- jsonlite::fromJSON(content(api.data, 'text'), simplifyVector = TRUE, flatten=TRUE) ##
          
          #lake level
          lake_level <- dam.data$Elev[[1]] 
          lake_level <- lake_level %>% mutate(date = as.Date(substr(lake_level$time,1,11), "%d-%b-%Y")) %>% group_by(date) %>% summarize(elev_Ft = round(median(value, na.rm=TRUE),2), .groups = "drop") ##
          plot(lake_level$date, lake_level$elev_Ft, type="l");
          
          #lake storage
          #conservation storage
          cons.stor <- purrr::map(dam.data$`Conservation Storage`, ~ purrr::compact(.)) %>% purrr::keep(~length(.) != 0) #conservation storage = storage_AF
          cons.stor <- cons.stor[[1]] 
          cons.stor <- cons.stor %>% mutate(date = as.Date(substr(cons.stor$time, 1, 11), "%d-%b-%Y")) %>% group_by(date) %>% summarize(storage_AF = round(median(value, na.rm=TRUE), 0), .groups ="drop")
          
          #flood storage
          flood.stor <- purrr::map(dam.data$`Flood Storage`, ~ purrr::compact(.)) %>% purrr::keep(~length(.) != 0)
          flood.stor <- flood.stor[[1]]
          flood.stor <- flood.stor %>% mutate(date = as.Date(substr(flood.stor$time, 1, 11), "%d-%b-%Y")) %>% group_by(date) %>% summarize(fstorage_AF = round(median(value, na.rm=TRUE), 0), .groups ="drop")
          
          #combine storage
          lake_stor <- merge(cons.stor, flood.stor, by.x = "date", by.y = "date", sort = TRUE) 
          plot(lake_stor$date, lake_stor$storage_AF, type="l"); lines(lake_stor$date, lake_stor$fstorage_AF, col="red") #igual
          
          #combine lake data
          lake_data <- merge(lake_level, lake_stor, by.x="date", by.y="date", all=TRUE)
          lake_data$locid <- as.character(location.id);     lake_data$district <- district.id;
          lake_data$NIDID <- as.character(zt$NIDID[i]);     lake_data$name <- as.character(zt$Name[i])
          
          #bind to larger dataframe

          district_data <- rbind(district_data, lake_data)
          print(paste0(location.id,": ", as.character(zt$Name[i])))
          
        } #end of site
        
        all_district_data <- rbind(all_district_data, district_data) #save data from each district loop to master df
        rm(api.data, dam.data, lake_level, cons.stor, flood.stor, lake_stor, lake_data, district_data)
        
      } #end of district
    
    summary(all_district_data)  #a few NA's in storage_AF and Elev_Ft - Addicks and Barker, as expected. 
    
    new.data.usace <- all_district_data
    
    ########################################################################################################################################################################################################################
    #
    #          ADD OLD AND NEW DATA TOGETHER
    #
    ########################################################################################################################################################################################################################
    #pull out unique reservoirs
    unique.nid <- unique(new.data.usace$NIDID); unique.nid
    
    #new data
      nx <- new.data.usace 
        dateFormat = nx$date[1]
          if(substr(dateFormat,5,5) == "-") {dateFormatFinal = "%Y-%m-%d"}
          if(substr(dateFormat,5,5) != "-") {dateFormatFinal = "%m/%d/%Y"}
        dateFormatFinal
      nx$date <- as.Date(as.character(nx$date), dateFormatFinal) 
      nx$Year <- year(nx$date)
      nx$day_month <- substr(nx$date, 6, 10)
      #set julian values
      for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
        
        if(leap_year(nx$Year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
        if(leap_year(nx$Year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
        
        print(paste(round(i/nrow(nx)*100,2),"% complete"))
      }
      
      #clean data
      nx <- nx %>% mutate(elev_Ft = ifelse(elev_Ft <= 0, NA, elev_Ft), storage_AF = ifelse(storage_AF <=0, NA, storage_AF), fstorage_AF = ifelse(fstorage_AF <=0, NA, fstorage_AF))
        maxCap <- nx %>% group_by(NIDID) %>% summarize(maxCap = 1.2*quantile(elev_Ft, 0.90, na.rm=TRUE), maxStor = 1.2*quantile(storage_AF, 0.90, na.rm=TRUE), maxfStor = 1.2*quantile(fstorage_AF, 0.90, na.rm=TRUE), .groups="drop");
      nx <- nx %>% left_join(maxCap, by="NIDID") %>% mutate(elev_Ft = ifelse(elev_Ft > maxCap, NA, elev_Ft), storage_AF = ifelse(storage_AF > maxStor, NA, storage_AF), fstorage_AF = ifelse(fstorage_AF > maxfStor, NA, fstorage_AF)) %>% 
          select(-maxCap, -maxStor, -maxfStor)
      
      #old data
      fx <- old.data.usace
      dateFormat = fx$date[1]
      if(substr(dateFormat,5,5) == "-") {dateFormatFinal = "%Y-%m-%d"}
      if(substr(dateFormat,5,5) != "-") {dateFormatFinal = "%m/%d/%Y"}
      fx$date <- as.Date(as.character(fx$date), dateFormatFinal) 
      fx$Year <- year(fx$date)
      fx$day_month <- substr(fx$date, 6, 10)
      # #set julian values - SHOULDN't BE NEEDED GOING FORWARD.
      # for(i in 1:nrow(fx)) { #computationally slow. There's almost certainly a faster way. But it works. 
      #   
      #   if(leap_year(fx$Year[i]) == TRUE) {fx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == fx$day_month[i]]}
      #   if(leap_year(fx$Year[i]) == FALSE) {fx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == fx$day_month[i]]}
      #   
      #   print(paste(round(i/nrow(fx)*100,2),"% complete"))
      # }
      
      
      #what is the most recent date?
      old.last.date <- fx %>% group_by(NIDID) %>% filter(date == max(date, na.rm=TRUE)) %>% select(NIDID, date) %>% distinct() %>% rename(lastDate = date)
      
      #remove anything new before that date
      nx2 <- nx %>% left_join(old.last.date, by="NIDID") %>% filter(date > lastDate)
      fx.2020 <- fx %>% filter(Year>=2020) %>% select(NIDID, day_month, OT_Ft, OT_AF) %>% distinct(); #2020 has complete data
      nx2 <- merge(nx, fx.2020, by.x=c("NIDID","day_month"), by.y=c("NIDID","day_month"), all.x=TRUE)  
      nx2 <- nx2 %>% mutate(percentStorage = round(storage_AF/OT_AF*100,2))
      nx2 <- nx2 %>% select(NIDID, name, date, Year, day_month, julian, elev_Ft, storage_AF, OT_Ft, OT_AF, percentStorage); colnames(nx2) <- colnames(fx)
      
      #combine
      fx <- rbind(fx, nx2)
      
      #make sure no duplicates
      fx <- fx %>% distinct()
      #arrange by NIDID and date
      fx <- fx %>% arrange(NIDID, date)
      
      #SCOTT KERR HAS HAD A NEW SEDIMENT SURVEY
      scott.ot = 36639
      fx <- fx %>% mutate(OT_AF = ifelse(NIDID == "NC00300" & Year >=2017, 36639, OT_AF))
      
      fx <- fx %>% mutate(percentStorage = round(storage_AF/OT_AF*100,2)) %>% mutate(storage_AF = ifelse(percentStorage > 300, NA, storage_AF), percentStorage = ifelse(percentStorage > 300, NA, percentStorage))
      summary(fx)
      write.csv(fx, paste0(swd_data, "reservoirs/all_usace_dams.csv"), row.names=FALSE)

      

########################################################################################################################################
#######filter out reservoir(s) of interest (DIDNT NEED USBR DATA FOR BOERNE)##############################################################################################################
########################################################################################################################################
       
   usace <- read.csv(paste0(swd_data, "reservoirs/all_usace_dams.csv"), header = TRUE) #load in
   #usbr <- read.csv(paste0(swd_data, "reservoirs/usbr_dams.csv"), header = TRUE) #load in
   
   #common format
   names(usace); #names(usbr);
   usace <- usace %>% mutate (year = Year) %>% select(NIDID, name, date, julian, day_month, year, storage_AF, elev_Ft, OT_Ft, OT_AF, percentStorage) %>% mutate(jurisdiction = "USACE") #dropping Julian, at least for now, since it's all wrong.  
   #usbr <- usbr %>% select(NIDID, name, date, julian, day_month, year, storage_AF, elev_Ft, OT_Ft, OT_AF, percentStorage) %>% mutate(jurisdiction = "USBR") #dropping Julian, at least for now, since it's all wrong.  
   tx.dams <- usace
   summary(tx.dams) 
   
   write.csv(tx.dams, paste0(swd_data, "reservoirs/all_usace_dams.csv"), row.names=FALSE) #save out, this is different from above in that it includes jurisdiction   
   
# filter out reservoir(s) of interest
   canyon.lake <- tx.dams %>% filter(name == "Canyon Lake")
   write.csv(canyon.lake, paste0(swd_data, "reservoirs/all_canyon_lake.csv"), row.names=FALSE)
    
########################################################################################################################################################################################################################
#
#          UPDATE RESERVOIR STATUS AND STATS
#
########################################################################################################################################################################################################################

#fx <- read.csv(paste0(swd_data, "reservoirs/canyon_lake"), header = TRUE) #for picking up part-way
fx <- canyon.lake %>% filter(is.na(OT_Ft) == FALSE) #drop sites without operational target
unique.sites <- unique(fx$NIDID) 

#set up data frame for stats and include year
stats <- as.data.frame(matrix(nrow=0,ncol=13));        colnames(stats) <- c("nidid", "julian", "min", "flow10", "flow25", "flow50", "flow75", "flow90", "max", "Nobs","startYr","endYr","date"); 
year.flow  <- as.data.frame(matrix(nrow=0, ncol=10));   colnames(year.flow) <- c("nidid", "name", "date", "year", "julian", "elev_ft","storage_af", "target_ft", "target_af", "percent_storage")


  for (i in 1:length(unique.sites)){
  #for (i in 17:length(unique.sites)){  #test
    zt <- fx %>% filter(NIDID == unique.sites[i]) %>% filter(year >= year(start.date))
    #summarize annual
    zt.stats <- zt %>% group_by(NIDID, julian) %>% summarize(Nobs = n(), min=round(min(percentStorage, na.rm=TRUE),4), flow10 = round(quantile(percentStorage, 0.10, na.rm=TRUE),4), flow25 = round(quantile(percentStorage, 0.25, na.rm=TRUE),4),
                                                      flow50 = round(quantile(percentStorage, 0.5, na.rm=TRUE),4), flow75 = round(quantile(percentStorage, 0.75, na.rm=TRUE),4), flow90 = round(quantile(percentStorage, 0.90, na.rm=TRUE),4), 
                                                      max = round(max(percentStorage, na.rm=TRUE),4), .groups="drop")
    zt.stats <- zt.stats %>% mutate(nidid = as.character(unique.sites[i]), startYr = min(zt$year), endYr = max(zt$year)) %>% select(nidid, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs, startYr, endYr)
    if(dim(zt.stats)[1] == 366) {zt.stats$date = julian.ref$day_month_leap}
    if(dim(zt.stats)[1] == 365) {zt.stats$date = julian.ref$day_month[c(1:365)]} 
    
    
    #fill dataframe
    stats <- rbind(stats, zt.stats)
    zt <- zt %>% filter(year>=2017) %>% select(NIDID, name, date, year, julian, elev_Ft, storage_AF, OT_Ft, OT_AF, percentStorage, jurisdiction);    
      colnames(zt) <- c("nidid", "name", "date", "year", "julian", "elev_ft","storage_af", "target_ft", "target_af", "percent_storage", "jurisdiction")
    year.flow <- rbind(year.flow, zt)
    
    print(i)
  }
  bk.up <- stats
  summary(stats)
  summary(year.flow)
  
  stats <- stats %>% mutate(date2 = as.Date(paste0(end.year, "-",date), "%Y-%b-%d")) %>% mutate(month = substr(date,0,3))
  
  
  #Now attach most recent value to stream stats for the map
  recent.flow <- year.flow %>% group_by(nidid) %>% filter(is.na(storage_af) == FALSE) %>% filter(date == max(date)); #do we want to do most recent date or most recent date with data?
  current.stat <- merge(recent.flow[,c("nidid", "julian", "date", "percent_storage")], stats, by.x=c("nidid","julian"), by.y=c("nidid", "julian"), all.x=TRUE) %>% select(-date.y, -date2) %>% rename(date = date.x)
  
  #if else for this year and last years flow
  current.stat <- current.stat %>% mutate(status = ifelse(percent_storage <= flow10, "Extremely Dry", ifelse(percent_storage > flow10 & percent_storage <= flow25, "Very Dry", ifelse(percent_storage >= flow25 & percent_storage < flow50, "Moderately Dry", 
                                                  ifelse(percent_storage >= flow50 & percent_storage < flow75, "Moderately Wet", ifelse(percent_storage >= flow75 & percent_storage < flow90, "Very Wet", ifelse(percent_storage >= flow90, "Extremely Wet", "Unknown")))))))
  current.stat$status <- ifelse(is.na(current.stat$status), "unknown", current.stat$status)
  table(current.stat$status)
  
  #merge to sites geojson 
  project.df <- read_sf(paste0(swd_data, "reservoirs/canyon_lake_site.geojson"))
  #res.loc <- project.df %>% select(NIDID, Loc_ID, District, Name, url_link, geometry) #Can't do all of this - lacking from USBR. 
  res.loc <- project.df %>% select(NIDID, Name, Jurisdiction, geometry)
  canyon.lake.site.stats <- merge(res.loc, current.stat[,c("nidid","status","percent_storage","julian","flow50")], by.x="NIDID", by.y="nidid") #why are there 4 of everything?
  geojson_write(canyon.lake.site.stats, file=paste0(swd_data, "reservoirs/all_canyon_lake_site.geojson"))
  

  #rename nidid to site so can use same code as streamflow - used to make charts
  current.year <- year.flow %>% filter(year == year(max(date)));     last.year <- year.flow %>% filter(year == (year(max(date))-1));     
  stats.flow <- merge(stats, current.year[,c("nidid","julian","percent_storage")], by.x=c("nidid","julian"), by.y=c("nidid","julian"), all.x=TRUE) %>% rename(flow = percent_storage)
  stats.past <- merge(stats, last.year[,c("nidid", "julian", "percent_storage")], by.x=c("nidid", "julian"), by.y=c("nidid", "julian"), all.x=TRUE) %>% mutate(date2 = as.Date(paste0((end.year-1),"-",date), "%Y-%b-%d"))  %>% 
    rename(flow = percent_storage) %>% as.data.frame()
  stats.flow <- rbind(stats.past, stats.flow)
  
  stats.flow <- stats.flow %>% mutate(status = ifelse(flow <= flow10, "Extremely Dry", ifelse(flow > flow10 & flow <= flow25, "Very Dry", ifelse(flow >= flow25 & flow < flow50, "Moderately Dry", 
                                               ifelse(flow >= flow50 & flow < flow75, "Moderately Wet", ifelse(flow >= flow75 & flow < flow90, "Very Wet", ifelse(flow >= flow90, "Extremely Wet", "Unknown")))))))
  stats.flow <- stats.flow %>% mutate(colorStatus = ifelse(status=="Extremely Dry", "darkred", ifelse(status=="Very Dry", "red", ifelse(status=="Moderately Dry", "orange", ifelse(status=="Moderately Wet", "cornflowerblue",
                                              ifelse(status=="Very Wet", "blue", ifelse(status=="Extremely Wet", "navy", "gray")))))))
  #attach flow of current year
  stats.flow <- stats.flow %>% rename(site = nidid)
  write.csv(stats.flow, paste0(swd_data, "reservoirs/all_canyon_reservoir_stats.csv"), row.names=FALSE)
  
################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])



