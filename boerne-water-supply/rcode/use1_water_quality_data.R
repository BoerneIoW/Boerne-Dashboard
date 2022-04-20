###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY VIANEY RUEDA 
# MARCH 2022
#
###################################################################################################################################################

######################################################################################################################################################################
#
#   Load old data
#
######################################################################################################################################################################
old.data <- read.csv(paste0(swd_data, "quality/boerne_water_quality.csv"))
boerne_quality_sites <- read_sf(paste0(swd_data, "quality/water_quality_sites.geojson"))

######################################################################################################################################################################
#
#   READ IN QUALITY SITES AND DATA: Texas Stream Team Water Quality Data
#
######################################################################################################################################################################

#verify a google account to use the read_sheet function
gs4_auth()
1

all_quality_data <- read_sheet("https://docs.google.com/spreadsheets/d/1JAQLzSpbU2nMVb4Pe1XUA2lxU3a1XcY4oUYS8UhIaiA/edit#gid=826381059", col_types = "ccccnnnDTnnncnnnnnnnnn")

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
boerne_data <- as.data.frame(boerne_data)
boerne_data <- boerne_data %>% arrange(site_id, date)

# limit data to 2022
boerne_data <- boerne_data %>% mutate(year = year(date))
new_boerne_data <- boerne_data %>% filter(year >= 2022)

#combine new and old data
all_boerne_data <- rbind(old.data, new_boerne_data)

#save out
write.csv(all_boerne_data, paste0(swd_data, "quality/all_boerne_water_quality.csv"), row.names=FALSE)

################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])
