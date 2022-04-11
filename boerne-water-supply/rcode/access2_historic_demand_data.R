###################################################################################################################################################
#
# CODE TO READ IN SENSOR OF THINGS DATA FOR NC WATER SUPPLY DASHBOARD
# CREATED BY LAUREN PATTERSON & KYLE ONDA @ THE INTERNET OF WATER
# FEBRUARY 2021
# RUN AFTER global0_set_apis_libraries
# Modified November 2021 by Vianey Rueda for Boerne
#
###################################################################################################################################################


######################################################################################################################################################################
#
#   LOAD Data
#
######################################################################################################################################################################
#load in geojson for utilities
utilities <- read_sf(paste0(swd_data, "boerne_utility.geojson"))
pwsid.list <- unique(utilities$pwsid) #Boerne is the utility of interest
mymonths <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"); #used below to convert numbers to abbrev
#mapview::mapview(utilities)

#calculate moving average function
ma <- function(x,n=7){stats::filter(x,rep(1/n,n), sides=1)}

######################################################################################################################################################################
#
# Read in water demand data from Google spreadsheet
#
#####################################################################################################################################################################
gs4_auth()
1

demand_data <- read_sheet("https://docs.google.com/spreadsheets/d/1BKb9Q6UFEBNsGrLZhjdq2kKX5t1GqPFCWF553afUKUg/edit#gid=2030520898", sheet = 1, range = "A229:H", col_names = FALSE, col_types = "Dnnnnnnn")
demand_by_source <- demand_data[, c("...1", "...2", "...3", "...6", "...7", "...8")]

#rename columns
demand_by_mgd <- rename(demand_by_source, date = "...1", groundwater = "...2", boerne_lake = "...3", GBRA = "...6", reclaimed = "...7", total = "...8")

#replace na's with 0s
demand_by_mgd <- as.data.frame(demand_by_mgd)
demand_by_mgd[is.na(demand_by_mgd)] <- 0

demand_by_mgd <- as.data.frame(demand_by_mgd)

#change units to MGD
demand_by_mgd$groundwater <- demand_by_mgd$groundwater/1000; demand_by_mgd$boerne_lake <- demand_by_mgd$boerne_lake/1000; demand_by_mgd$GBRA <- demand_by_mgd$GBRA/1000; demand_by_mgd$reclaimed <- demand_by_mgd$reclaimed/1000; demand_by_mgd$total <- demand_by_mgd$total/1000; 

#include PWSId
demand_by_mgd$pwsid <- utilities$pwsid

#add julian indexing
#nx <- demand_by_mgd %>% mutate(year = year(date), month = month(date), day = day(date))
nx <- demand_by_mgd %>% mutate(year = year(date), day_month = substr(date, 6, 10))

for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
  if(leap_year(nx$year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
  if(leap_year(nx$year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
  
  print(paste(round(i/nrow(nx)*100,2),"% complete"))
}

demand_by_mgd <- nx

#split date by month and day
demand_by_mgd = demand_by_mgd %>% 
  mutate(date = ymd(date)) %>% 
  mutate_at(vars(date), funs(year, month, day))

demand_by_mgd$day <- as.numeric(demand_by_mgd$day)

str(demand_by_mgd)

demand_by_mgd <- demand_by_mgd %>% filter(year <= 2021)

check.last.date <- demand_by_mgd %>% filter(date == max(date)) %>% dplyr::select(date, month)
table(check.last.date$date)

#write.csv
write.csv(demand_by_mgd, paste0(swd_data, "demand/boerne_demand_by_source.csv"), row.names=FALSE)


#calculate monthly peak
demand2 <- demand_by_mgd[, c("total", "month", "year", "pwsid")] 
demand2 <- demand2 %>% group_by(pwsid, month, year) %>% mutate(peak_demand = round(quantile(total, 0.98),1)); #took the 98% to omit outliers

#provide julian date
demand2$julian <- demand_by_mgd$julian

#write.csv
write.csv(demand2, paste0(swd_data, "demand/boerne_total_demand.csv"), row.names=FALSE)

######################################################################################################################################################################
#
# Reclaimed water data
#
#####################################################################################################################################################################
reclaimed <- subset(demand_by_mgd, select = -c(total,groundwater,boerne_lake,GBRA))

write.csv(reclaimed, paste0(swd_data, "demand/boerne_reclaimed_water.csv"), row.names=FALSE)

######################################################################################################################################################################
#
# Read in population data from Google spreadsheet
#
#####################################################################################################################################################################
all_city_data <- read_sheet("https://docs.google.com/spreadsheets/d/1BKb9Q6UFEBNsGrLZhjdq2kKX5t1GqPFCWF553afUKUg/edit#gid=2030520898", sheet = 1, range = "A4245:K", col_names = FALSE)

#filter for pop data only
all_pop_data <- all_city_data[,c("...1", "...10", "...11")]

#rename columns
pop_data <- rename(all_pop_data, date = "...1", clb_pop = "...10", wsb_pop = "...11")
pop_data <- as.data.frame(pop_data)

#remove na's
pop_data <- na.omit(pop_data)

#add julian indexing
nxx <- pop_data %>% mutate(year = year(date), day_month = substr(date, 6, 10))

for(i in 1:nrow(nxx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
  if(leap_year(nxx$year[i]) == TRUE) {nxx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nxx$day_month[i]]}
  if(leap_year(nxx$year[i]) == FALSE) {nxx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nxx$day_month[i]]}
  
  print(paste(round(i/nrow(nxx)*100,2),"% complete"))
}

pop_data <- nxx

#split date by month and day
pop_data = pop_data %>% 
  mutate(date = ymd(date)) %>% 
  mutate_at(vars(date), funs(year, month, day))

#include pwsid
pop_data$pwsid <- "TX300001"

pop_data <- pop_data %>% filter(year <= 2021)

#write.csv
write.csv(pop_data, paste0(swd_data, "demand/boerne_pop.csv"), row.names=FALSE)

################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])
