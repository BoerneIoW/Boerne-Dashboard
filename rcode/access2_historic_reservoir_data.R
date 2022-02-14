#######################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# FEBRUARY 2021
# Should not need to be run
# Updated June 2021 for TX by Sophia Bryson
#
########################################################################################################################################################


########################################################################################################################################################
#
# FILTER RESERVOIR OF INTEREST FROM LOADED CSV FILE: do not use entire script, simply load csv file and filter
#
########################################################################################################################################################

# Code below this section is used to generate the csv file that contains historical data for all reservoirs in Texas. Since that csv file has already been
# created, simply load the file and filter reservoirs of interest.

canyonlake <- read.csv(paste0(swd_data, "reservoirs/usace_usbr_dams.csv"))
canyonlake <- canyonlake %>% filter(name == "Canyon Lake")
write.csv(canyonlake, (paste0(swd_data, "reservoirs/canyonlake.csv")), row.names = FALSE)


######################################################################################################################################################################
#
#   LOAD OLD DATA PREVIOUSLY COLLECTED BY THE WATER PROGRAM
#
######################################################################################################################################################################
#This old data includes updates over time (2015 onward)
#old.data <- read.csv(paste0(swd_data, "reservoirs\\usace_dams.csv"))
# USACE dstricts in Texas:
  #SWF - Fort Worth
  #SWT - Tulsa
  #SWG - Galvenston  #From lauren: There should be 2 dams - Addicks and Barraks. I think I only have data from the Corps website and nothing else. Please add if they have anything... farthest back in the corps api is 2014 ish
  #ABQ - Albuquerque (omit - no dams in Texas) 

#record.match <- read.csv(paste0(swd_data, "reservoirs\\matchNID_LocID.csv")) #contains correponding NIDID and Loc_IDs for all sites

#These datasets are the constraint on years - only go as far back as 2015. 
#swf.data <- read.csv(paste0(swd_data, "reservoirs\\SWF_updates.csv")) #Fort Worth district data

#swt.data <- read.csv(paste0(swd_data, "reservoirs\\SWT_updates.csv")) #Tulsa district data
  #2 reservoirs separate from rest of district data. Load in and combine. 
  #swt.bb <- read_excel(paste0(swd_data, "reservoirs\\SWT_Broken_Bow.xlsx"), na = "NA", sheet = 2, col_names=TRUE) %>% rename(elev_Ft = elev_ft)
  #swt.cg <- read_excel(paste0(swd_data, "reservoirs\\SWT_Council_Grove.xlsx"), na = "NA", sheet = 2, col_names=TRUE) %>% rename(elev_Ft = elev_ft)
  #swt.data <- rbind(swt.data, swt.bb, swt.cg) #Combine all swt data 
  
#swg.data <- read.csv(paste0(swd_data, "reservoirs\\SWG_updates.csv"))  - does not exist in this format
  
#old.data <- rbind(swf.data, swt.data) %>% filter(grepl('TX', NIDID)) #combined data from all TX districts, subset for only TX sites. Use for names, but not beyond - doesn't go before 2015.
#old.data <- mutate(old.data, date = as.Date(old.data$date, format = "%m/%d/%Y")) 

# Add in Operating Targets for reservoirs: 
  # Get names into matching format
    #old.data$match.name <- str_replace_all(old.data$name, " ", "")
    #old.data$match.name <- str_replace_all(old.data$match.name, "Lake", "") %>% 
      #str_replace_all("Ld16", "LD") %>% str_replace_all("Ld18", "LD") %>% str_replace_all("Ld14", "LD") %>% 
      #str_replace_all("Ld17", "LD") %>% str_replace_all("RsKerrLd15", "RobertS.KerrLD") %>% str_replace_all("Ft.", "Fort") %>%
      #str_replace_all("O.C.Fisher", "OCFisher") %>% str_replace_all("SamRayburnReservoir", "SamRayburn")
  # Correct names where lake and dam names differ - 
  #"B.A.Steinhagen" is TownBluff || "Georgetown" is North San Gabriel|| "O'ThePines" is Ferrells Bridge  || "Texoma" is Denison
    #old.data$match.name <- str_replace_all(old.data$match.name, "B.A.Steinhagen", "TownBluff") %>%
      #str_replace_all("Georgetown", "NorthSanGabriel") %>% str_replace_all("O'ThePines", "FerrellsBridge") %>%
      #str_replace_all("Texoma", "Denison")
  #write.csv(old.data, paste0(swd_data, "reservoirs\\old.data.csv")) #doesn't need to be written 
  #base.file.names <- unique(old.data$match.name) %>% c("Addicks") #manually add Addicks (from SWG district - lacking data). Still missing Barker.
  #needed <- c(); directory <- c()
  #OT.folder <- paste0(swd_data, "reservoirs\\temp_usace_website")
  
  #Needed files
    #for(i in 1:length(base.file.names)) {
      #needed[i] <- paste0(base.file.names[i], ".csv")
      #directory[i] <- paste0(OT.folder, "\\", base.file.names[i], ".csv")       
#    }
  
    
    # #Ran once, now done.
    #             #Unneeded files
    #               all.csvs <- list.files(path = OT.folder)
    #               unneeded <- all.csvs[all.csvs %in% needed == FALSE]
    #               length(unneeded) + length(needed) == length(all.csvs) # some not yet filtered out that should be
    # 
    #             #Remove unneeded files to save on space
    #               for(m in 1:length(unneeded)) {
    #                 file.remove(paste0(OT.folder,"\\", unneeded[m]))
    #               }

  # Read in needed files
#    OT.data <- lapply(directory, read.csv)
#    names(OT.data) <- paste0(base.file.names, "_OT")
#    OT.all <- c()

#    for (p in 1:length(OT.data)) {
#      OT.data[[p]] <- OT.data[[p]] %>% mutate(DAM = base.file.names[p])
      #OT.data[[p]] <- mutate(OT.data[[p]], base.file.names[p])
#      OT.all <- rbind(OT.all, OT.data[[p]])
#    }

    #dates in two formats, resulting in NAs later on. Fix that. 
#    dash.date <- OT.all %>% filter(substr(DATE, 5, 5) == "-") %>% mutate(DATE = as.Date(DATE, "%Y-%m-%d")) #%Y-%m-%d
#    slash.date <- OT.all %>% filter(substr(DATE, 5, 5) != "-")  %>% mutate(DATE = as.Date(DATE, "%m/%d/%Y")) #%m/%d/%Y
#    OT.all <- rbind(dash.date, slash.date)
    
    # #SAVE OUT
    # write.csv(OT.all, file = paste0(OT.folder, "\\", "TX_dams_OT"), row.names = FALSE)
    # 
    # #LOAD IN  
    # OT.all <- read.csv(file = paste0(OT.folder, "\\", "TX_dams_OT"), header = TRUE) %>% filter(YEAR >= year(start.date)) %>% mutate(DATE = as.Date(DATE, "%Y-%m-%d"))
#    summary(OT.all)
    
#    summary(old.data)
    
#    tx.records <- record.match %>% filter(grepl('TX', NIDID)) %>% select(District, Name, NIDID, Loc_ID) #catches SWG sites missing from old.data (no files on historic data)
    
#    matchup <- old.data %>% select(match.name, locid, district, NIDID, name) %>% unique() #shrink just to essentials for matching - otherwise, attempts to allocate 4.3 GB vector. 
    
#    matchup <- merge(tx.records, matchup, by = "NIDID", all.x = TRUE) %>% select(NIDID, District, Name, Loc_ID, match.name) %>%
    
    #manually add match.names for Addicks and Barker     
#        for (i in 1:length(matchup$Name)) { 
#          if(is.na(matchup$match.name[i])) {
#            matchup$match.name[i] = matchup$Name[i] #fill in with name
#          } #end if
#        } #end loop
     
#        matchup$match.name <- gsub(" .*", "", matchup$match.name)
    
#    fx <- merge(matchup, OT.all, by.x = c("match.name"), by.y = c("DAM"), all.y = TRUE, all.x = TRUE) %>% 
#      select(Name, Loc_ID, District, NIDID, DATE, YEAR, JULIAN, Elev_Ft, Storage_ACFT, OT_FT, OT_ACFT) %>% 
#      rename(date = DATE, year = YEAR, julian = JULIAN, OT_Ft = OT_FT, OT_AF = OT_ACFT, name = Name, locid = Loc_ID, district = District, elev_Ft = Elev_Ft, storage_AF = Storage_ACFT)
    
#    summary(fx) #NA's corresponds to Addicks and Barker Dam, lacking various forms of current data. Not in final data. Check back on USACE in case data provisioning changes. 
    
#    old.data <- fx  # old.data now only includes sites in TX and has both the identities 
                    # from the original old.data (name, NIDID, locid, district, etc) and the 
                    # full time-series (1990 to present) values for storage and OTs from the OT files. 
    
#    write.csv(old.data, (paste0(swd_data, "reservoirs\\old_data.csv")), row.names = FALSE)
  
## Load in
  
#  old.data <- read.csv(paste0(swd_data, "reservoirs\\old_data.csv"))
  
######################################################################################################################################################################
#
#   ONLY NEED THIS CODE IF THE CORPS UPDATES THEIR API - NEED TO FIND NEW URLS
#
######################################################################################################################################################################
#baseURL = 'https://water.usace.army.mil/a2w/'
# This is loads in the locations and the urls for other data accessible via web services
#projectsURL = 'https://water.usace.army.mil/a2w/CWMS_CRREL.cwms_data_api.get_a2w_webservices_json'

#read in data as json file
#project.data = jsonlite::fromJSON(projectsURL, simplifyDataFrame=FALSE)
#project.data <- readLines(projectsURL, warn=FALSE)
  #fix error
  #project.data <- gsub("},]}", "}]}", project.data)
  #project.data <- jsonlite::fromJSON(project.data, simplifyDataFrame=FALSE)
#  str(project.data, max.level=1)
  #length of lists
#  nprojects <- length(project.data$projects)
  
  #to see levels
#  project.data$projects[[1]]
  
#To pull out individual data frames and find data URL for individual reservoirs
#project.df = as.data.frame(matrix(nrow=nprojects, ncol=10));   
#  colnames(project.df) <- c("District", "Lat_Y", "Long_X", "Loc_ID", "Name", "DataURL", "DamSummaryURL","WQReportURL","LocSummaryURL","AnnualVarURL")
#  for (i in 1:nprojects){
#    project.df$District[i] = project.data$projects[[i]]$office_id
#    project.df$Lat_Y[i] = as.numeric(project.data$projects[[i]]$lat)
#    project.df$Long_X[i] = as.numeric(project.data$projects[[i]]$lon)
#    project.df$Loc_ID[i] = project.data$projects[[i]]$loc_id
#    project.df$Name[i] = project.data$projects[[i]]$description
#    project.df$DataURL[i] = paste0(baseURL, project.data$projects[[i]]$reportURL)
#    project.df$DamSummaryURL[i] = paste0(baseURL, project.data$projects[[i]]$damSummaryURL)
#    project.df$WQReportURL[i] = paste0(baseURL, project.data$projects[[i]]$wqReportURL)
#    project.df$LocSummaryURL[i] = paste0(baseURL, project.data$projects[[i]]$locSummaryURL)
#    project.df$AnnualVarURL[i] = paste0(baseURL, project.data$projects[[i]]$annualVariabilityURL)
#  }
#project.df[1:5,]
#table(project.df$District)

  #map of USACE dams
#    regional.dams <- st_as_sf(project.df, coords = c("Long_X", "Lat_Y"), crs = 4326, agr = "constant") %>% 
#      mutate(texas = Loc_ID %in% as.character(unique(old.data$locid))) #only those in TX
#    ace.dams <- regional.dams %>% filter(texas == TRUE)
#    mapview::mapview(ace.dams)
    
  #map of USBR dams   
    # locations from https://www.usbr.gov/gp/hydromet/location.csv (ADD TO MAP)
#    usbr.dam.loc.all <- read.csv("https://www.usbr.gov/gp/hydromet/location.csv")
#    usbr.dam.loc <- usbr.dam.loc.all %>% filter(State == stateAbb) %>% filter(Type == "RES")
#    br.dams <- st_as_sf(usbr.dam.loc, coords = c("Longitude", "Latitude"), crs = 4326, agr = "constant") 
#    mapview::mapview(br.dams)
    

##########################################################################################################################################################################  
#The data collected by Duke uses NIDID while the Corps uses Loc_ID - so we had to create a match file
#project.df <- read.csv(paste0(swd_data, "reservoirs\\matchNID_LocID.csv"))

#API documentation on USACE CWMS here: https://water.usace.army.mil/dist/docs/
      
# Loop prep
      
  #District list
#    tx.dist <- as.data.frame("SWF", "SWT", "SWG", "ABQ")
#    data.dist <- unique(project.df$District)
#    tx.dist <- tx.dist[tx.dist %in% data.dist == TRUE] #No dams in ABQ
    
  # API URL building blocks
#    baseURL = 'https://water.usace.army.mil/a2w/'
#    last_number = 1; #number of units to collect  
#    last_unit = "years"; #other options are months, weeks, and days
#    report_url = "CWMS_CRREL.cwms_data_api.get_report_json?p_location_id="
#    parameter_url <- paste0("&p_parameter_type=Stor%3AElev&p_last=", last_number, "&p_last_unit=", last_unit, "&p_unit_system=EN&p_format=JSON")
    
  # Create final data frame
#    all_district_data <- as.data.frame(matrix(nrow=0, ncol=8)); colnames(all_district_data) <- c("date", "elev_Ft", "storage_AF", "fstorage_AF", "locid", "district", "NIDID", "name")

# Pull new data for all sites in all districts
    
#  for(j in 1:length(tx.dist)){ #loop through districts
    #for(j in 2) { #testing
#    district.id = tx.dist[j];
    
#    district_data <- as.data.frame(matrix(nrow=0, ncol=8)); colnames(district_data) <- c("date", "elev_Ft", "storage_AF", "fstorage_AF", "locid", "district", "NIDID", "name")
#    zt <- subset(project.df, District==district.id) %>% filter(str_detect(string = NIDID, pattern = "TX")) %>% filter(Loc_ID != 2165051) #Only TX, drop Truscott Brine Lake - no outward flow, no active mgmt - & different data structure breaks the loop
    
#    for (i in 1:length(zt$Loc_ID)){ #loop through sites within districts
      #for (i in 1) { #testing
#      location.id <- zt$Loc_ID[i]; location.id
      #2165051 lacks conservation storage? (i=33)
      
#      full_url <- paste0(baseURL, report_url, location.id, parameter_url)
      
#      api.data <- GET(full_url, timeout(15000)) #use httr library to avoid timeout #CAN INCREASE IF TIMING OUT
      #dam.data <- content(api.data, "parse")
#      dam.data <- jsonlite::fromJSON(content(api.data, 'text'), simplifyVector = TRUE, flatten=TRUE) ##
      
      #lake level
#      lake_level <- dam.data$Elev[[1]] ##
#      lake_level <- lake_level %>% mutate(date = as.Date(substr(lake_level$time,1,11), "%d-%b-%Y")) %>% group_by(date) %>% summarize(elev_Ft = round(median(value, na.rm=TRUE),2), .groups = "drop") ##
#      plot(lake_level$date, lake_level$elev_Ft, type="l"); #abline(h=251.5, col="blue")
      
      #lake storage
      #conservation storage
#      cons.stor <- purrr::map(dam.data$`Conservation Storage`, ~ purrr::compact(.)) %>% purrr::keep(~length(.) != 0) #conservation storage = storage_AF
#      cons.stor <- cons.stor[[1]] 
#      cons.stor <- cons.stor %>% mutate(date = as.Date(substr(cons.stor$time, 1, 11), "%d-%b-%Y")) %>% group_by(date) %>% summarize(storage_AF = round(median(value, na.rm=TRUE), 0), .groups ="drop")
      
      #flood storage
#      flood.stor <- purrr::map(dam.data$`Flood Storage`, ~ purrr::compact(.)) %>% purrr::keep(~length(.) != 0)
#      flood.stor <- flood.stor[[1]]
#      flood.stor <- flood.stor %>% mutate(date = as.Date(substr(flood.stor$time, 1, 11), "%d-%b-%Y")) %>% group_by(date) %>% summarize(fstorage_AF = round(median(value, na.rm=TRUE), 0), .groups ="drop")
      
      #combine storage
#      lake_stor <- merge(cons.stor, flood.stor, by.x = "date", by.y = "date", sort = TRUE) 
#      plot(lake_stor$date, lake_stor$storage_AF, type="l"); lines(lake_stor$date, lake_stor$fstorage_AF, col="red") #igual
      
      #combine lake data
#      lake_data <- merge(lake_level, lake_stor, by.x="date", by.y="date", all=TRUE)
#      lake_data$locid <- as.character(location.id);     lake_data$district <- district.id;
#      lake_data$NIDID <- as.character(zt$NIDID[i]);     lake_data$name <- as.character(zt$Name[i])
      
      #bind to larger dataframe
      #if no data
#      district_data <- rbind(district_data, lake_data)
#      print(paste0(location.id,": ", as.character(zt$Name[i])))
      
#   } #end of site
    
#    all_district_data <- rbind(all_district_data, district_data) #save data from each district loop to master df
#    rm(api.data, dam.data, lake_level, cons.stor, flood.stor, lake_stor, lake_data, district_data)
    
#  } #end of district

#  summary(all_district_data)  #a few NA's in storage_AF and Elev_Ft
    
# Save out
#  write.csv(all_district_data, file = paste0(swd_data, "reservoirs\\all_district_data.csv"), row.names = FALSE)
    
# Load in  
#  district_data <- read.csv(file = paste0(swd_data, "reservoirs\\all_district_data.csv"), header = TRUE)


#Now read in the website data and add the most recent files to the end of it
#  new.data <- district_data
#  zt <- subset(project.df, grepl("TX", NIDID)) %>% filter(Loc_ID != 2165051) #select TX locations, drop Truscott Brine Lake - no outward flow, no active mgmt - & different data structure breaks the loop
#  res <- zt %>% select(District, Name, NIDID, Lat_Y, Long_X, Loc_ID)

#pull out unique reservoirs
#  unique.nid <- unique(new.data$NIDID); unique.nid
  
  
############################################################################################################
  
#No OT data for Lds and Truscott Brine Lake due to operational differences  
  
  
#new data
#  nx <- new.data 
#    dateFormat = nx$date[1]
#      if(substr(dateFormat,5,5) == "-") {dateFormatFinal = "%Y-%m-%d"}
#      if(substr(dateFormat,5,5) != "-") {dateFormatFinal = "%m/%d/%Y"}
#    dateFormatFinal
#  nx$date <- as.Date(as.character(nx$date), dateFormatFinal) 
#  nx$Year <- year(nx$date)
#  nx$day_month <- substr(nx$date, 6, 10)
  #set julian values
#  for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
    
#    if(leap_year(nx$Year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
#    if(leap_year(nx$Year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
    
#    print(paste(round(i/nrow(qp)*100,2),"% complete"))
#  }
  
  
  #clean data
#  nx <- nx %>% mutate(elev_Ft = ifelse(elev_Ft <= 0, NA, elev_Ft), storage_AF = ifelse(storage_AF <=0, NA, storage_AF), fstorage_AF = ifelse(fstorage_AF <=0, NA, fstorage_AF))
#    maxCap <- nx %>% group_by(NIDID) %>% summarize(maxCap = 1.2*quantile(elev_Ft, 0.90, na.rm=TRUE), maxStor = 1.2*quantile(storage_AF, 0.90, na.rm=TRUE), maxfStor = 1.2*quantile(fstorage_AF, 0.90, na.rm=TRUE), .groups="drop");
#  nx <- nx %>% left_join(maxCap, by="NIDID") %>% mutate(elev_Ft = ifelse(elev_Ft > maxCap, NA, elev_Ft), storage_AF = ifelse(storage_AF > maxStor, NA, storage_AF), fstorage_AF = ifelse(fstorage_AF > maxfStor, NA, fstorage_AF)) %>% 
#      select(-maxCap, -maxStor, -maxfStor)
    
  #old data
#  fx <- old.data
#  fx$date <- as.Date(fx$date, "%Y-%m-%d")
#  fx$Year <- year(fx$date)
#  fx$day_month <- substr(fx$date, 6, 10)
  #set julian values
#  for(i in 1:nrow(fx)) { #computationally slow. There's almost certainly a faster way. But it works. 
    
#    if(leap_year(fx$Year[i]) == TRUE) {fx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == fx$day_month[i]]}
#    if(leap_year(fx$Year[i]) == FALSE) {fx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == fx$day_month[i]]}
    
#    print(paste(round(i/nrow(qp)*100,2),"% complete"))
#  }
  
#  fx <- fx %>% select(NIDID, name, date, Year, day_month, julian, elev_Ft, storage_AF, OT_Ft, OT_AF)
  
  # Check-up - Various things are na: 
#    summary(fx)
#    na.OT <- fx %>% filter(is.na(fx$OT_AF)); unique(na.OT$name) #Addicks and Barker (swg) and Truscott (no drainage) lack OT data. - DROP
#    na.elev <- fx %>% filter(is.na(fx$elev_Ft)) #some gaps in elevation data at various reservoirs. 
#    na.stor <- fx %>% filter(is.na(fx$storage_AF)) #some gaps in storage data at various reservoirs
    
#    fx <- fx %>% filter(name %notin% unique(na.OT$name)) #prune out Addicks, Barker, and Truscott
    
    
  #what is the most recent date?
#  old.last.date <- fx %>% group_by(NIDID) %>% filter(date == max(date, na.rm=TRUE)) %>% select(NIDID, date) %>% distinct() %>% rename(lastDate = date)

  
  #remove anything new before that date
#  nx2 <- nx %>% left_join(old.last.date, by="NIDID") %>% filter(date > lastDate)
#  fx.2020 <- fx %>% filter(Year>=2020) %>% select(NIDID, julian, OT_Ft, OT_AF); 
#  nx2 <- merge(nx, fx.2020, by.x=c("NIDID","julian"), by.y=c("NIDID","julian"), all.x=TRUE)  
  
#  nx2 <- nx2 %>% select(NIDID, name, date, Year, day_month, julian, elev_Ft, storage_AF, OT_Ft, OT_AF); colnames(nx2) <- colnames(fx)
  
  #combine
#  fx <- rbind(fx, nx2) %>% filter(name %notin% unique(na.OT$name)) #prune out Addicks, Barker, and Truscott
  
  #make sure no duplicates
#  fx <- fx %>% distinct()
  #arrange by NIDID and date
#  fx <- fx %>% arrange(NIDID, date)
  
#  summary(fx)
  
  
#  na.OT2 <- fx %>% filter(is.na(fx$OT_AF)) #Aquilla and BA Steinhagen missing OTs for some dates. Fix:
#    fx <- fx %>% arrange(name, Year, julian)

#    for (i in 1:length(fx$OT_AF)) {
#      if (is.na(fx$OT_AF[i])) {
#        fx$OT_AF[i] = fx$OT_AF[i-1]
#      }
#      if (is.na(fx$OT_Ft[i])) {
#        fx$OT_Ft[i] = fx$OT_Ft[i-1]
#      }
#    }
    
#    summary(fx) 
    
    #Fragile fix. Extends OT values when missing by selecting the first preceding non-NA value in the appropriate column. 
    # Assumes (i) that the first value found will belong to the appropriate site 
    #           (which should be a safe bet. na's only occurred in 2020/2021 where present, and df is sorted by site name and year. Should run backward and hit a value in 2019 at the latest, then stop.)
    #          (ii) that the OTs have not changed since the last recorded date and the present. 
    
#  fx <- fx %>% mutate(percentStorage = round(storage_AF/OT_AF*100,2)) %>% mutate(storage_AF = ifelse(percentStorage > 300, NA, storage_AF), percentStorage = ifelse(percentStorage > 300, NA, percentStorage))
#  summary(fx)
#  write.csv(fx, paste0(swd_data, "reservoirs\\usace_dams.csv"), row.names=FALSE) #save out

  #save shapefile 
#  zt <- zt %>% select(District, Name, NIDID, Lat_Y, Long_X, Loc_ID)
#  res.loc <- st_as_sf(zt, coords = c("Long_X", "Lat_Y"), crs = 4326) %>% filter(str_detect(string = NIDID, pattern = "TX"));
#  geojson_write(res.loc, file=paste0(swd_data, "reservoirs//usace_sites.geojson"))
  
  
########################################################################################################################################################################################
#Add in Bureau of Reclamation sites - SEE AUTOMATED RETRIEVAL DOC here: https://www.usbr.gov/gp/hydromet/automated_retrieval.pdf
# 3 dams: https://www.usbr.gov/projects/facilities.php?state=Texas
#   + Choke Canyon - https://www.usbr.gov/projects/index.php?id=65 - https://www.usbr.gov/gp-bin/arcweb_ccdt.pl
#       https://waterdata.usgs.gov/nwis/inventory/?site_no=08206900&agency_cd=USGS
#       code : CCDT
#   + Lake Meredtih (Sanford Dam) - https://www.usbr.gov/projects/index.php?id=270 - https://www.usbr.gov/gp-bin/arcweb_sanford.pl
#       https://waterdata.usgs.gov/nwis/inventory/?site_no=08131200&agency_cd=USGS  
#       code : SANFORD
#   + Twin Buttes Reservoir (Twin Buttes Dam) - https://www.usbr.gov/projects/index.php?id=307 - https://www.usbr.gov/gp-bin/arcweb_trgt.pl
#       https://www.swt-wc.usace.army.mil/MERE.lakepage.html
#       code: TRGT
#   + NASTY 
# 
#  
# ALLOCATIONS: https://www.usbr.gov/gp/aop/resaloc/otao_summary_reservoir_allocation_tables.pdf 
# Use bottom of flood control as top of reservoir allocation
#
# CCDT - 2205 ft
# NASTY - lacking data
# SANFORD - 2936.5 ft
# TRGT - 1940.4 ft
# look for historical allocation data!  
#  
   ###########################################################################################################################
  
  # locations from https://www.usbr.gov/gp/hydromet/location.csv (ADD TO MAP)
#  usbr.dam.loc.all <- read.csv("https://www.usbr.gov/gp/hydromet/location.csv")
#  usbr.dam.loc <- usbr.dam.loc.all %>% filter(State == stateAbb) %>% filter(Type == "RES")
#  br.dams <- st_as_sf(usbr.dam.loc, coords = c("Longitude", "Latitude"), crs = 4326, agr = "constant") 
#  mapview::mapview(br.dams)
  
#  br.codes <- unique(usbr.dam.loc$Station) 
#  br.codes <- br.codes[br.codes != "NASTY"] #NASTY site does not have publicly available data
  
  
  #Hydromet (USBR) data request - see doumentation: https://www.usbr.gov/gp/hydromet/automated_retrieval.pdf
  #https://www.usbr.gov/gp-bin/arccsv.pl?BOZM,ET,2017JUN01,DAT,30
  #The editable portion of this URL is in the following format: ?SITE,PAR,DATE,PROCESS,NDAYS
#  base.url <- "https://www.usbr.gov/gp-bin/arccsv.pl?"
  
  #GET parameter codes:
#  site.pars <- matrix(nrow = length(br.codes), ncol = 2) 
#  site.pars <- as.data.frame(matrix(nrow = length(br.codes), ncol = 2));  colnames(site.pars) <- c("site", "avail_par_codes")

#  for (i in 1:length(br.codes)) {
#    site.pars[i,1] <- br.codes[i]
#    par.url <- paste0(base.url, br.codes[i], ",", "+") #"+" in place of parameter code returns all possible parameters
#    pars <- GET(par.url)
#    site.pars[i,2] <- content(pars, "text") %>% str_remove_all("\n")
#  }
  
#  site.pars #check to make sure that all sites have necessary (FB and AF) parameters
#  par.calls <- c("FB", "AF")
  #  Parameters of interest: (see https://www.usbr.gov/gp/hydromet/dbparameters.html)
  #   + FB : reservoir forebay elevation (feet)
  #   + AF : REservoir sotrage content (acre feet)
  #   present for some sites, but unneeded: FB_M is forebay elevation in m, PP is total precip (in/day), PU is total water year precip (in)
  
  #table may allow for more data at once than csv (up to 14 combinations at once)
#  base.url <- "https://www.usbr.gov/gp-bin/webarccsv.pl?parameter=" #THEN station name
  
#  par.pairs <- crossing(br.codes, par.calls)  #should be 6 total - each site * each parameter
#  full <- c() #storage vector for full parameter list
  
#      for (n in 1:nrow(par.pairs)) {
#        nxt <- paste0(par.pairs[n,1], "%20", par.pairs[n,2], ",")
#        full <- c(full, nxt)
#      }

#  full <- full %>% paste0(collapse = "    ") %>% str_remove_all("    ")
#  par <- full

#  syer <- year(start.date) #start year
#  smnth <- month(start.date)
#  sdy <- day(start.date)
#  eyer <- year(end.date)
#  emnth <- month(end.date)
#  edy <- day(end.date)
#  format <- 2 #corresponds to comma delimited
  
  #Pull data. Eventually replace with RISE api call, if possible? 
#  full.url <- paste0(base.url, par, "&syer=", syer, "&smnth=", smnth, "&sdy=", sdy, 
#                    "&eyer=", eyer, "&emnth=", emnth, "&edy=", edy, "&format=", 2)
#  usbr.pull <- readLines(full.url); head(usbr.pull, n=50); tail(usbr.pull, n=10);#data begins on with header on line 20 and data on line 21. 2 line tail. 
#  usbr.data <- usbr.pull[20:(length(usbr.pull)-2)] %>% read_csv() #isolate data
  
  #Reformat data before merge with old data
  
    #storage volume column
#      af <- usbr.data %>% pivot_longer(cols = c(`CCDT AF`, `SANFORD AF`, `TRGT AF`), names_to = "site", values_to = "storage_AF") %>% select(DATE, site, storage_AF)
      #fix names
#      af$site <- af$site %>% str_replace_all("CCDT AF", "Choke Canyon") %>%
#        str_replace_all("SANFORD AF", "Lake Meredith") %>%
#        str_replace_all("TRGT AF", "Twin Buttes")
    
    #elevation column
#      fb <- usbr.data %>% pivot_longer(cols = c(`CCDT FB`, `SANFORD FB`, `TRGT FB`), names_to = "site2", values_to = "elev_Ft") %>% select(DATE, site2, elev_Ft)
      #fix names
#      fb$site2 <- fb$site2 %>% str_replace_all("CCDT FB", "Choke Canyon") %>%
#        str_replace_all("SANFORD FB", "Lake Meredith") %>%
#        str_replace_all("TRGT FB", "Twin Buttes")
      
    #merge volume and elevation
#      fy <- merge(af,fb, by.x = c("DATE", "site"), by.y = c("DATE", "site2")) %>% rename(date = DATE, name = site)
      
    #date management - reformat date, add julian and year columns 
#      fy <- fy %>% mutate(date = as.Date(date, "%m/%d/%Y")) %>% mutate(year = year(date)) %>% arrange(name, year, date)
#      fy$day_month <- substr(fy$date, 6, 10)
#      fy$julian <- as.integer(julian(fy$date))%%365L-4L #Adjusted, but not sure what to do with leap years.... Some negative numbers... 

      
    #add in operational targets - manually. If conservation allocation is ever changed, update here. 
      #Top of Conservation - Elev > OT_Ft.
      #Top of Conservation - Storate > OT_AF
      #Assumes same OTs since beginning of data timeseries, which may be incorrect. (numbers cited were published 2013 and remain in effect in 2021).
        #FACT CHECK: 
          #Choke Canyon, 1993 report has same OT values. Assume applicable for 3 preceding years, also (https://www.twdb.texas.gov/surfacewater/surveys/completed/files/chokecanyon/1993-03/ChokeCanyon1993_FinalReport.pdf)
          #Lake Meredith, 1995 report has same OT values. Assume applicability for 5 preceding years, also (file:///C:/Users/lenovo/Desktop/Duke/Summer%202021/TX%20Water%20Supply/Meredith1995_FinalReport.pdf)
          #Twin Butte shows steady conservation pool designation back to 1963 (https://www.waterdatafortexas.org/reservoirs/individual/twin-buttes)
      
      
      #dataframe with OT values by dam
#      br.OT.match <- as.data.frame(matrix(nrow=3, ncol=4))
#      names(br.OT.match) <- c("name", "NIDID", "OT_Ft", "OT_AF")

      #OT Values taken from https://www.usbr.gov/gp/aop/resaloc/otao_summary_reservoir_allocation_tables.pdf.
      #NIDIDs from https://www.usbr.gov/projects/index.php?id=65, https://www.usbr.gov/projects/index.php?id=270, https://www.usbr.gov/projects/index.php?id=307
#      br.OT.match$name <- c(unique(fy$name))
#      br.OT.match$NIDID <- c("Choke Canyon" = "TX04415", "Lake Meredith" = "TX00023", "Twin Buttes" = "TX00022") #no locid - corps exclusive?
#      br.OT.match$OT_Ft <- c("Choke Canyon" = 220.5, "Lake Meredith" = 2936.5, "Twin Buttes" = 1940.2)
#      br.OT.match$OT_AF <- c("Choke Canyon" = 695271, "Lake Meredith" = 815318, "Twin Buttes" = 185210)
      
#      fy1 <- merge(fy, br.OT.match, by = "name", all.x = TRUE) #Match OTs to dam data
#      fy1.comp <- fy1 %>% filter(storage_AF != "MISSING") %>% filter(elev_Ft != "MISSING") %>% mutate(storage_AF = as.numeric(storage_AF), elev_Ft = as.numeric(elev_Ft)) #1061 missing records dropped.
#      fy2 <- fy1.comp %>% mutate(percentStorage = round(storage_AF/OT_AF*100,2)) %>% mutate(storage_AF = ifelse(percentStorage > 300, NA, storage_AF), percentStorage = ifelse(percentStorage > 300, NA, percentStorage))
#      summary(fy2) #julian still wacky. 
      
        # Check levels
#        cc <- filter(fy2, name == "Choke Canyon"); plot(cc$date, cc$elev_Ft, type = "l"); plot(cc$date[cc$year < 1995], cc$elev_Ft[cc$year < 1995], type = "l")
        #according to TWDB, considered complete by May 11, 1982. So that beginning drop is legitimate part of the record.
#        lm <- filter(fy2, name == "Lake Meredith"); plot(lm$date, lm$elev_Ft, type = "l"); plot(lm$date[lm$year < 1995], lm$elev_Ft[lm$year < 1995], type = "l")
        #completed Aug. 21 1965 
#        tb <- filter(fy2, name == "Twin Buttes"); plot(tb$date, tb$elev_Ft, type = "l"); plot(tb$date[tb$year < 1995], tb$elev_Ft[tb$year < 1995], type = "l")
        #completed Feb. 13 1963
      
#    write.csv(fy2, paste0(swd_data, "reservoirs\\usbr_dams.csv"), row.names=FALSE) #save out
    
#    usbr.dam.loc.all <- read.csv("https://www.usbr.gov/gp/hydromet/location.csv")
#    usbr.dam.loc <- usbr.dam.loc.all %>% filter(State == stateAbb) %>% filter(Type == "RES") %>% filter(Station != "NASTY") #Lake Nasworth does not have publicly available data
#    station.nidid.match <- as.data.frame(matrix(c("CCDT", "SANFORD", "TRGT", "Choke Canyon Reservoir", "Sanford Dam (Lake Meredith)", "Twin Buttes Dam", "TX04415", "TX00023", "TX00022"), nrow = 3, ncol = 3)) %>% rename(Station = V1, Name = V2, NIDID = V3)
#    brd <- merge(usbr.dam.loc, station.nidid.match, by.x = "Station", by.y = "Station", all.x = TRUE)
#    br.dams <- st_as_sf(brd, coords = c("Longitude", "Latitude"), crs = 4326, agr = "constant") 
#    mapview::mapview(br.dams)
#    geojson_write(br.dams, file=paste0(swd_data, "reservoirs//usbr_sites.geojson")) #done
    

    
########################## COMBINE USACE and USBR DATE #######################################################   
    
#    usace <- read.csv(paste0(swd_data, "reservoirs\\usace_dams.csv"), header = TRUE) #load in
#    usbr <- read.csv(paste0(swd_data, "reservoirs\\usbr_dams.csv"), header = TRUE) #load in
    
    #common format
#    names(usace); names(usbr);
#    usace <- usace %>% mutate (year = Year) %>% select(NIDID, name, date, day_month, year, storage_AF, elev_Ft, OT_Ft, OT_AF, percentStorage) %>% mutate(jurisdiction = "USACE") #dropping Julian, at least for now, since it's all wrong.  
#    usbr <- usbr %>% select(NIDID, name, date, day_month, year, storage_AF, elev_Ft, OT_Ft, OT_AF, percentStorage) %>% mutate(jurisdiction = "USBR") #dropping Julian, at least for now, since it's all wrong.  
#    tx.dams <- rbind(usace, usbr)
#    summary(tx.dams) 
    #A few sites with missing stoarge data, that weren't removed. Can filter out if needed
     #na.stor <- tx.dams %>% filter(is.na(tx.dams$storage_AF)) #some gaps in storage data at various reservoirs
      
#    write.csv(tx.dams, paste0(swd_data, "reservoirs\\usace_usbr_dams.csv"), row.names=FALSE) #save out data
    
# Merged GEOJSON.
    
#    names(ace.dams)
#    names(br.dams)
    
    # Merge USACE and USBR dam location data - CURRENTLY hyper-simplified (6/23) - figure out how to merge while retaining different sets of data? 
#    ace.simp <- ace.dams %>% select(Name, NIDID, geometry) %>% mutate (Jurisdiction = "USACE"); ace.df <- as.data.frame(ace.simp)
#    br.simp <- br.dams %>% select(Name, NIDID, geometry) %>% mutate (Jurisdiction = "USBR"); br.df <- as.data.frame(br.simp) 
#    ace.br.df <- rbind(ace.df, br.df)
#    ace.br.dams <- st_as_sf(ace.br.df, crs = 4326, agr = "constant"); mapview::mapview (ace.br.dams) #locations, IDs, and names only
#    mapview::mapview(ace.br.dams)  
#    geojson_write(ace.br.dams, file=paste0(swd_data, "reservoirs//usace_usbr_sites.geojson")) #done

    
