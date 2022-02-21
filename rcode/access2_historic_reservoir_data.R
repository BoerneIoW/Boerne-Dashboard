#######################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON @ THE INTERNET OF WATER
# FEBRUARY 2021
# Should not need to be run
# Updated June 2021 for TX by Sophia Bryson
# Updated November 2021 by Vianey Rueda for Boerne
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


################################################################################################################################################################
# remove all except for global environment 
rm(list= ls()[!(ls() %in% c('julian.ref','update.date', 'current.month', 'current.year', 'end.date', 'end.year', 
                            'mymonths', 'source_path', 'start.date', 'state_fips', 'stateAbb', 'stateFips', 'swd_data', 'today', 
                            '%notin%', 'ma'))])

    
