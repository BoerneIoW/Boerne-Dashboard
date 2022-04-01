###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY VIANEY RUEDA @
# MARCH 2022
#
###################################################################################################################################################
######################################################################################################################################################################
#
#   READ IN QUALITY SITES AND DATA
#
######################################################################################################################################################################
all_quality_data <- read_sheet("https://docs.google.com/spreadsheets/d/1JAQLzSpbU2nMVb4Pe1XUA2lxU3a1XcY4oUYS8UhIaiA/edit#gid=826381059")

#filter for relevant sites
boerne_data <- all_quality_data %>% filter(Name %in% c("12600", "15126", "20823", "80186", "80230", "80904", "80966", "81596", "81641", "81671", "81672"))
#rename columns
boerne_data <- rename(boerne_data, site_id = Name, name = Description, basin = Basin, county = County, latitude = Latitude, longitude = Longitude, 
                      stream_segment = `Stream Segment`, date = `Sample Date`, sample_depth = `Sample Depth (m)`, flow_severity = `Flow Severity`, 
                      conductivity = `Conductivity (µs/cm)`, dissolved_oxygen = `Dissolved Oxygent (mg/L)`, air_temp = `Air Temperature (°C)`, 
                      water_temp = `Water Temperature (°C)`, ecoli_avg = `E. Coli Average`, secchi_disk_transparency = `Secchi Disk Transparency (m)`,
                      nitrate_nitrogen = `Nitrate-Nitrogen (mg/L or ppm)`)
#filter for relevant data
boerne_data <- boerne_data[-c(9,11:12,21)]

#clean up
boerne_data$stream_segment <- unlist(boerne_data$stream_segment)
boerne_data$conductivity <- unlist(boerne_data$conductivity)
boerne_data$secchi_disk_transparency <- unlist(boerne_data$secchi_disk_transparency)
boerne_data <- as.data.frame(boerne_data)
boerne_data <- boerne_data %>% arrange(site_id)

# create metadata to generate geojson file
boerne_sites <- boerne_data %>% slice(1,37,221,313,494,590,639,717,736,737,742) #choose one observation per site to extract metadata from
boerne_sites <- boerne_sites[-c(7:18)]
zt <- st_as_sf(boerne_sites, coords = c("longitude", "latitude"), crs = 4326, agr = "constant")
mapview::mapview(zt)


################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])
