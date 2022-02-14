###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON & KYLE ONDA @ THE INTERNET OF WATER
# FEBRUARY 2021
# Run anytime... change county.list if desire. 
# Updated July 2021 by Sophia Bryson for TX. 
#
###################################################################################################################################################


######################################################################################################################################################################
#
#   READ IN GROUNDWATER SITES AND GROUNDWATER DATA
#
######################################################################################################################################################################
#tx.sites <- read.csv(paste0(swd_data, "gw\\gw_sites.csv")); #all NAD83
#all.data <- read.csv(paste0(swd_data, "gw\\all_gw_levels.csv")) %>% mutate(date = as.Date(date, format="%Y-%m-%d"))

boerne.sites <- read.csv(paste0(swd_data, "gw/boerne_well_metadata.csv"))
old.data <- read.csv(paste0(swd_data, "gw/boerne_gw_depth.csv")) %>% mutate(date = as.Date(date, format="%Y-%m-%d"))
######################################################################################################################################################################
#
# PULL IN GW LEVEL DATA DYNAMICALLY
#
#####################################################################################################################################################################
startDate <- max(old.data$date) + 1
endDate <- as.Date(today)

#authenticate account
gs4_auth()

# load in metadata for each well and merge into one 
well_1_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 1, range = "A2:X3", col_names = FALSE)  
well_2_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 2, range = "A2:X3", col_names = FALSE)
well_3_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 3, range = "A2:X3", col_names = FALSE)
well_4_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 4, range = "A2:X3", col_names = FALSE)
well_5_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 5, range = "A2:X3", col_names = FALSE)
well_6_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 6, range = "A2:X3", col_names = FALSE)
well_7_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 7, range = "A2:X3", col_names = FALSE)
well_8_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 8, range = "A2:X3", col_names = FALSE)
well_9_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 9, range = "A2:X3", col_names = FALSE)
well_10_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 10, range = "A2:X3", col_names = FALSE)
well_11_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 11, range = "A2:X3", col_names = FALSE)
well_12_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 12, range = "A2:X3", col_names = FALSE)
well_13_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 13, range = "A2:X3", col_names = FALSE)
well_14_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 14, range = "A2:X3", col_names = FALSE)
well_15_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 15, range = "A2:X3", col_names = FALSE)
well_16_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 16, range = "A2:X3", col_names = FALSE)
well_17_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 17, range = "A2:X3", col_names = FALSE)
well_18_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 18, range = "A2:X3", col_names = FALSE)
well_19_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 19, range = "A2:X3", col_names = FALSE)
well_20_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 20, range = "A2:X3", col_names = FALSE)
well_21_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 21, range = "A2:X3", col_names = FALSE)
well_22_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 22, range = "A2:X3", col_names = FALSE)
well_23_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 23, range = "A2:X3", col_names = FALSE)
well_24_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 24, range = "A2:X3", col_names = FALSE)
well_25_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 25, range = "A2:X3", col_names = FALSE)
well_26_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 26, range = "A2:X3", col_names = FALSE)
well_27_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 27, range = "A2:X3", col_names = FALSE)
well_28_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 28, range = "A2:X3", col_names = FALSE)
well_29_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 29, range = "A2:X3", col_names = FALSE)
well_30_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 30, range = "A2:X3", col_names = FALSE)
well_31_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 31, range = "A2:X3", col_names = FALSE)
well_32_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 32, range = "A2:X3", col_names = FALSE)
well_33_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 33, range = "A2:X3", col_names = FALSE)
well_34_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 34, range = "A2:X3", col_names = FALSE)
well_35_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 35, range = "A2:X3", col_names = FALSE)
well_36_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 36, range = "A2:X3", col_names = FALSE)
well_37_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 37, range = "A2:X3", col_names = FALSE)
well_38_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 38, range = "A2:X3", col_names = FALSE)
well_39_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 39, range = "A2:X3", col_names = FALSE)
well_40_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 40, range = "A2:X3", col_names = FALSE)
well_41_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 41, range = "A2:X3", col_names = FALSE)
well_42_metadata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 42, range = "A2:X3", col_names = FALSE)

# load in spreadsheets
well_1_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1522547605", sheet = 1, range = "A6:C", col_names = FALSE) 
well_2_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1934422136", sheet = 2, range = "A6:C", col_names = FALSE)
well_3_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=719259520", sheet = 3, range = "A6:C", col_names = FALSE)
well_4_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=389389412", sheet = 4, range = "A6:C", col_names = FALSE)
well_5_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1257980991", sheet = 5, range = "A6:C", col_names = FALSE)
well_6_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1781615124", sheet = 6, range = "A6:C", col_names = FALSE)
well_7_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=307186165", sheet = 7, range = "A6:C", col_names = FALSE)
well_8_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1523558813", sheet = 8, range = "A6:C", col_names = FALSE)
well_9_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1378483658", sheet = 9, range = "A6:C", col_names = FALSE)
well_10_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1373586307", sheet = 10, range = "A6:C", col_names = FALSE)
well_11_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=893626626", sheet = 11, range = "A6:C", col_names = FALSE)
well_12_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1968867564", sheet = 12, range = "A6:C", col_names = FALSE)
well_13_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1548907863", sheet = 13, range = "A6:C", col_names = FALSE)
well_14_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1391281368", sheet = 14, range = "A6:C", col_names = FALSE)
well_15_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=402575728", sheet = 15, range = "A6:C", col_names = FALSE)
well_16_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1642169354", sheet = 16, range = "A6:C", col_names = FALSE)
well_17_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1926897702", sheet = 17, range = "A6:C", col_names = FALSE)
well_18_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=954344662", sheet = 18, range = "A6:C", col_names = FALSE)
well_19_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=41825159", sheet = 19, range = "A6:C", col_names = FALSE)
well_20_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=393370924", sheet = 20, range = "A6:C", col_names = FALSE)
well_21_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=195179919", sheet = 21, range = "A6:C", col_names = FALSE)
well_22_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1482469128", sheet = 22, range = "A6:C", col_names = FALSE)
well_23_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=165265936", sheet = 23, range = "A6:C", col_names = FALSE)
well_24_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1993398161", sheet = 24, range = "A6:C", col_names = FALSE)
well_25_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=587010398", sheet = 25, range = "A6:C", col_names = FALSE)
well_26_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=579825398", sheet = 26, range = "A6:C", col_names = FALSE)
well_27_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=2080716832", sheet = 27, range = "A6:C", col_names = FALSE)
well_28_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1635452908", sheet = 28, range = "A6:C", col_names = FALSE)
well_29_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1872076189", sheet = 29, range = "A6:C", col_names = FALSE)
well_30_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1364313175", sheet = 30, range = "A6:C", col_names = FALSE)
well_31_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=899409940", sheet = 31, range = "A6:C", col_names = FALSE)
well_32_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=944729185", sheet = 32, range = "A6:C", col_names = FALSE)
well_33_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1770112423", sheet = 33, range = "A6:C", col_names = FALSE)
well_34_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1579630502", sheet = 34, range = "A6:C", col_names = FALSE)
well_35_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1434456171", sheet = 35, range = "A6:C", col_names = FALSE)
well_36_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=753128445", sheet = 36, range = "A6:C", col_names = FALSE)
well_37_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1782992355", sheet = 37, range = "A6:C", col_names = FALSE)
well_38_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1891789214", sheet = 38, range = "A6:C", col_names = FALSE)
well_39_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1345744535", sheet = 39, range = "A6:C", col_names = FALSE)
well_40_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1322851868", sheet = 40, range = "A6:C", col_names = FALSE)
well_41_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=1798574912", sheet = 41, range = "A6:C", col_names = FALSE)
well_42_gwdata <- read_sheet("https://docs.google.com/spreadsheets/d/1QoaOhrpz6vrSMBc0yc5-i7nhwj2lmsBHZFYOBJc0KVU/edit#gid=503911552", sheet = 42, range = "A6:C", col_names = FALSE)

# add agency and id's to each site (state number) 
well_1_gwdata$State_Number <- well_1_metadata [1,15]
well_2_gwdata$State_Number <- well_2_metadata [1,15]
well_3_gwdata$State_Number <- well_3_metadata [1,15]
well_4_gwdata$State_Number <- well_4_metadata [1,15]
well_5_gwdata$State_Number <- well_5_metadata [1,15]
well_6_gwdata$State_Number <- well_6_metadata [1,15]
well_7_gwdata$State_Number <- well_7_metadata [1,15]
well_8_gwdata$State_Number <- well_8_metadata [1,15]
well_9_gwdata$State_Number <- well_9_metadata [1,15]
well_10_gwdata$State_Number <- well_10_metadata [1,15]
well_11_gwdata$State_Number <- well_11_metadata [1,15]
well_12_gwdata$State_Number <- well_12_metadata [1,15]
well_13_gwdata$State_Number <- well_13_metadata [1,15]
well_14_gwdata$State_Number <- well_14_metadata [1,15]
well_15_gwdata$State_Number <- well_15_metadata [1,15]
well_16_gwdata$State_Number <- well_16_metadata [1,15]
well_17_gwdata$State_Number <- well_17_metadata [1,15]
well_18_gwdata$State_Number <- well_18_metadata [1,15]
well_19_gwdata$State_Number <- well_19_metadata [1,15]
well_20_gwdata$State_Number <- well_20_metadata [1,15]
well_21_gwdata$State_Number <- well_21_metadata [1,15]
well_22_gwdata$State_Number <- well_22_metadata [1,15]
well_23_gwdata$State_Number <- well_23_metadata [1,15]
well_24_gwdata$State_Number <- well_24_metadata [1,15]
well_25_gwdata$State_Number <- well_25_metadata [1,15]
well_26_gwdata$State_Number <- well_26_metadata [1,15]
well_27_gwdata$State_Number <- well_27_metadata [1,15]
well_28_gwdata$State_Number <- well_28_metadata [1,15]
well_29_gwdata$State_Number <- well_29_metadata [1,15]
well_30_gwdata$State_Number <- well_30_metadata [1,15]
well_31_gwdata$State_Number <- well_31_metadata [1,15]
well_32_gwdata$State_Number <- well_32_metadata [1,15]
well_33_gwdata$State_Number <- well_33_metadata [1,15]
well_34_gwdata$State_Number <- well_34_metadata [1,15]
well_35_gwdata$State_Number <- well_35_metadata [1,15]
well_36_gwdata$State_Number <- well_36_metadata [1,15]
well_37_gwdata$State_Number <- well_37_metadata [1,15]
well_38_gwdata$State_Number <- well_38_metadata [1,15]
well_39_gwdata$State_Number <- well_39_metadata [1,15]
well_40_gwdata$State_Number <- well_40_metadata [1,15]
well_41_gwdata$State_Number <- well_41_metadata [1,15]
well_42_gwdata$State_Number <- well_42_metadata [1,15]

boerne_all_gw_levels <- rbind(well_42_gwdata, well_24_gwdata, well_31_gwdata, well_21_gwdata, well_35_gwdata, well_20_gwdata, well_22_gwdata,
                              well_23_gwdata, well_32_gwdata, well_39_gwdata, well_25_gwdata, well_13_gwdata, well_26_gwdata, well_27_gwdata,
                              well_7_gwdata, well_33_gwdata, well_8_gwdata, well_14_gwdata, well_38_gwdata, well_9_gwdata, well_36_gwdata, well_10_gwdata,
                              well_37_gwdata, well_19_gwdata, well_41_gwdata, well_18_gwdata, well_29_gwdata, well_16_gwdata, well_17_gwdata,
                              well_40_gwdata, well_34_gwdata, well_12_gwdata, well_30_gwdata, well_28_gwdata, well_15_gwdata, well_3_gwdata,
                              well_1_gwdata, well_2_gwdata, well_11_gwdata, well_4_gwdata, well_5_gwdata, well_6_gwdata)

boerne_all_gw_levels <- as.data.frame(boerne_all_gw_levels) # change from a subclass to a data frame

#rename columns
boerne_all_gw_levels <- rename(boerne_all_gw_levels, site = State_Number, date = "...1", depth_ft = "...2", elevation_at_waterlevel = "...3")
colnames(boerne_all_gw_levels)

#double-check that each column is the desired type (numeric, character, etc.) and make necessary changes
str(boerne_all_gw_levels)
boerne_all_gw_levels$site <- unlist(boerne_all_gw_levels$site)
boerne_all_gw_levels$date <- format(as.Date(boerne_all_gw_levels$date), "%Y-%m-%d")
str(boerne_all_gw_levels)

#add julian indexing
nx <- boerne_all_gw_levels %>% mutate(year = year(date), day_month = substr(date, 6, 10))

for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
  if(leap_year(nx$year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
  if(leap_year(nx$year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
  
  print(paste(round(i/nrow(nx)*100,2),"% complete"))
}

boerne_all_gw_levels <- nx

boerne_all_gw_levels$agency <- "CCGCD" #include agency that collects data

#remove missing data
boerne_all_gw_levels <- na.omit(boerne_all_gw_levels)

# filter data starting in 2022
new_boerne_gw_levels <- boerne_all_gw_levels %>% filter(year >= 2022)
new_boerne_gw_depth <- select(new_boerne_gw_levels, c(1, 2, 4, 5, 7))

check.last.date <- new_boerne_gw_depth %>% filter(date == max(date)) %>% dplyr::select(date)
table(check.last.date$date)

#combine old and new
str(old.data)
str(new_boerne_gw_depth)
old.data$julian <- as.numeric(old.data$julian)
new_boerne_gw_depth$julian <- as.numeric(new_boerne_gw_depth$julian)
old.data$date <- as.Date(old.data$date)
new_boerne_gw_depth$date <- as.Date(new_boerne_gw_depth$date)
old.data$site <- as.numeric(old.data$site)
old.data$year <- as.numeric(old.data$year)
str(old.data)
str(new_boerne_gw_depth)

all_boerne_gw_depth <- rbind(old.data, new_boerne_gw_depth) %>% arrange(site, date)

write.csv(all_boerne_gw_depth, paste0(swd_data, "gw/all_boerne_gw_depth.csv"), row.names=FALSE)

#####################################################################################################################################################################
#stats calculations:

#unique sites:
nx <- all_boerne_gw_depth  
unique.sites <- unique(nx$site) 

#set up data frame for stats and include year
year.flow  <- as.data.frame(matrix(nrow=0, ncol=4));    colnames(year.flow) <- c("site", "date", "flow_cms")

#loop through and calculate stats
for (i in 1:length(unique.sites)) {
  
  zt <- nx %>% filter(site == unique.sites[i]) #one site at a time
  
  #fill in dataframe
  zt <- zt %>% select(site, date, depth_ft);    colnames(zt) <- c("site", "date", "depth_ft")
  year.flow <- rbind(year.flow, zt)
  
  print(paste0(round(100*i/length(unique.sites),2),"% complete"))
}

#add julian indexing
nx <- year.flow %>% mutate(year = year(date), day_month = substr(date, 6, 10))

for(i in 1:nrow(nx)) { #computationally slow. There's almost certainly a faster way. But it works. 
  
  if(leap_year(nx$year[i]) == TRUE) {nx$julian[i] <- julian.ref$julian_index_leap[julian.ref$day_month_leap == nx$day_month[i]]}
  if(leap_year(nx$year[i]) == FALSE) {nx$julian[i] <- julian.ref$julian_index[julian.ref$day_month == nx$day_month[i]]}
  
  print(paste(round(i/nrow(nx)*100,2),"% complete"))
}

year.flow <- nx
summary(year.flow)

#account for any duplicates
#  year.flow <- year.flow %>% group_by(site, date, julian) %>% summarize(depth_ft = median(depth_ft, na.rm=TRUE), .groups="drop")

#Calculate states for all data... this takes a long while to do in tidyverse... like to see it making progress in loop
unique.sites <- unique(year.flow$site)
stats <- as.data.frame(matrix(nrow=0,ncol=14));        colnames(stats) <- c("site", "julian", "min", "flow10", "flow25", "flow50", "flow75", "flow90", "max", "Nobs","startYr","endYr","date", "date2"); 

for (i in 1:length(unique.sites)){
  zt <- year.flow %>% filter(site==unique.sites[i]) %>% mutate(year = year(date))
  zt.stats <- zt %>% group_by(site, julian) %>% summarize(Nobs = n(), min=round(min(depth_ft, na.rm=TRUE),4), flow10 = round(quantile(depth_ft, 0.10, na.rm=TRUE),4), flow25 = round(quantile(depth_ft, 0.25, na.rm=TRUE),4),
                                                          flow50 = round(quantile(depth_ft, 0.5, na.rm=TRUE),4), flow75 = round(quantile(depth_ft, 0.75, na.rm=TRUE),4), flow90 = round(quantile(depth_ft, 0.90, na.rm=TRUE),4), 
                                                          max = round(max(depth_ft, na.rm=TRUE),4), .groups="drop")
  
  zt.stats <- zt.stats %>% mutate(startYr = min(zt$year), endYr = max(zt$year)) %>% dplyr::select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs, startYr, endYr)
  
  #rematch julian values with dates. Bottom chunk includes leap year consideration.
  
  # zt.stats$date2 <- as.Date(zt.stats$julian, origin=paste0(current.year,"-01-01"))
  # zt.stats$date <- format(zt.stats$date2, format="%b-%d")
  
  if(dim(zt.stats)[1] == 366) {zt.stats$date2 = julian.ref$day_month_leap} #leap year indexing
  if(dim(zt.stats)[1] < 366) { #non-leap year indexing. Robust against irregular data dates.
    sub.jul <- julian.ref %>% filter(julian_index %in% zt.stats$julian) %>% select(day_month, julian_index)
    zt.stats <- merge(zt.stats, sub.jul, by.x = "julian", by.y = "julian_index", all.x = TRUE) %>%
      rename(date2 = day_month) %>% select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs,startYr,endYr, date2)
  }
  zt.stats$date <- format(zt.stats$date2, format = "%B-%d") #this isn't doing what it's supposed to.... 
  
  stats <- rbind(stats, zt.stats)
  print(paste(i, "is ", round(i/length(unique.sites)*100,2), "percent done"))
}
bk.up <- stats;

is.na(stats) <- sapply(stats, is.infinite)
summary(stats)

head(stats)

max(stats$endYr) 
######################################################################################################################################################################
#
# CREATE FILES FOR WEBSITE
#
#####################################################################################################################################################################
#Now attach MOST recent value to stream stats
recent.flow <- all_boerne_gw_depth %>% group_by(site) %>% filter(date == max(date)) #%>% rename(flow = depth_below_surface_ft)
current.stat <- merge(recent.flow[,c("site", "julian", "depth_ft")], stats, by.x=c("site","julian"), by.y=c("site","julian"), all.x=TRUE) 

#Now attach most recent value to stream stats
current.stat <- merge(all_boerne_gw_depth[,c("site", "julian", "depth_ft")], stats, by.x=c("site","julian"), by.y=c("site","julian"), all.x=TRUE) 

#if else for this year and last years flow... I think flip this for gw
current.stat <- current.stat %>% mutate(status = ifelse(depth_ft <= flow10, "Extremely Wet", 
                                                        ifelse(depth_ft > flow10 & depth_ft <= flow25, "Very Wet", 
                                                               ifelse(depth_ft >= flow25 & depth_ft < flow50, "Moderately Wet", 
                                                                      ifelse(depth_ft >= flow50 & depth_ft < flow75, "Moderately Dry", 
                                                                             ifelse(depth_ft >= flow75 & depth_ft < flow90, "Very Dry", 
                                                                                    ifelse(depth_ft >= flow90, "Extremely Dry", "Unknown")))))))
current.stat$status <- ifelse(is.na(current.stat$status), "unknown", current.stat$status)
table(current.stat$status)

#set those that are not collecting data to unknown
max.julian <- current.stat %>% filter(endYr == current.year) %>% summarize(maxJ = max(julian, na.rm=TRUE))
current.stat <- current.stat %>% mutate(status = ifelse(endYr < current.year & julian > 30, "unknown", 
                                                        ifelse(endYr < (current.year-1), "unknown", 
                                                               ifelse(endYr==current.year & julian < (max.julian$maxJ-30), "unknown", status))))
table(current.stat$status, useNA="ifany") # A lot of 'unknown' due to infrequency of data. 


#merge to sites geojson
boerne.sites  <- boerne.sites %>% rename(site = state_id) 
boerne.sites2 <- merge(boerne.sites, current.stat[,c("site","status","depth_ft","julian","date","flow50")], by.x="site", by.y="site")
#convert to sf
boerne.sites2 <- st_as_sf(boerne.sites2, coords = c("dec_long_va", "dec_lat_va"), crs = 4326);
boerne.sites2 <- merge(boerne.sites2 %>% dplyr::select(-date), recent.flow[,c("site","date")], by.x="site", by.y="site", all.x=TRUE)
#Save out
boerne.sites2 <- boerne.sites2 %>% dplyr::select(agency, site, location, elevation, total_depth, aquifer, status, depth_ft, julian, flow50, date, geometry)
geojson_write(boerne.sites2, file=paste0(swd_data, "gw/all_boerne_gw_sites.geojson"))

#plot for fun
boerne.sites2 <- boerne.sites2 %>% mutate(colorStatus = ifelse(status=="Extremely Dry", "darkred", 
                                                               ifelse(status=="Very Dry", "red", 
                                                                      ifelse(status=="Moderately Dry", "orange", 
                                                                             ifelse(status=="Moderately Wet", "cornflowerblue",
                                                                                    ifelse(status=="Very Wet", "blue", 
                                                                                           ifelse(status=="Extremely Wet", "navy", "gray")))))))
leaflet() %>%  addProviderTiles("Stamen.TonerLite") %>% 
  addCircleMarkers(data = boerne.sites2, radius=4, fillOpacity= 0.8, fillColor = boerne.sites2$colorStatus, color="black", weight=0) 


#Now clip time series data to past two years and assign a depth based on stats
year.flow2 <- year.flow %>% filter(date >= as.Date(paste0((current.year-2),"-01-01"), "%Y-%m-%d"))
stats2 <- merge(year.flow2[,c("site", "julian", "date", "depth_ft")], stats %>% dplyr::select(-date), by.x=c("site","julian"), by.y=c("site", "julian"), all.x=TRUE) %>% arrange(site, date)

stats2 <- stats2 %>% mutate(status = ifelse(depth_ft <= flow10, "Extremely Wet", 
                                            ifelse(depth_ft > flow10 & depth_ft <= flow25, "Very Wet", 
                                                   ifelse(depth_ft >= flow25 & depth_ft < flow50, "Moderately Wet", 
                                                          ifelse(depth_ft >= flow50 & depth_ft < flow75, "Moderately Dry", 
                                                                 ifelse(depth_ft >= flow75 & depth_ft < flow90, "Very Dry", 
                                                                        ifelse(depth_ft >= flow90, "Extremely Dry", "Unknown")))))))
stats2$status <- ifelse(is.na(stats2$status), "unknown", stats2$status)
table(stats2$status, useNA="ifany")
stats2 <- stats2 %>% mutate(colorStatus = ifelse(status=="Extremely Dry", "darkred", 
                                                 ifelse(status=="Very Dry", "red", 
                                                        ifelse(status=="Moderately Dry", "orange", 
                                                               ifelse(status=="Moderately Wet", "cornflowerblue",
                                                                      ifelse(status=="Very Wet", "blue", 
                                                                             ifelse(status=="Extremely Wet", "navy", "gray")))))))
stats2 <- stats2 %>% dplyr::select(site, julian, date, depth_ft, status, colorStatus)
stats2 <- stats2[with(stats2, order(site, date)),]
write.csv(stats2, paste0(swd_data, "gw/all_boerne_gw_status.csv"), row.names=FALSE)


#set up month names and save out stats file - check that this is doing what it's supposed to. date formatting above is being odd. 
my.month.name <- Vectorize(function(n) c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct","Nov", "Dec")[n])
recent.flow <- year.flow %>% group_by(site) %>% filter(date >= max(as.Date(paste0(current.year, "-01-01"), '%Y-%m-%d'))) 
stats.merge <- stats %>% mutate(date3 = date2, date2 = date) %>% dplyr::select(-date)
current.stat2 <- merge(recent.flow, stats.merge, by.x=c("site","julian"), by.y=c("site","julian"), all.y=TRUE);

current.stat2 <- current.stat2 %>% mutate(month = my.month.name(as.numeric(substr(date,6,7)))) %>% mutate(date = date2, date2 = date3) %>% dplyr::select(-date3);  #okay to have NA for date because want chart to end there
current.stat2 <- current.stat2[with(current.stat2, order(site, date)),]
write.csv(current.stat2, paste0(swd_data, "gw/all_boerne_gw_stats.csv"), row.names=FALSE)


#let's do annual trends
gw.annual <- year.flow %>% mutate(year = year(date)) %>% group_by(site, year) %>% summarize(medianDepth = median(depth_ft, na.rm=TRUE), nobsv = n(), .groups="drop")
write.csv(gw.annual, paste0(swd_data, "gw/all_boerne_gw_annual.csv"), row.names=FALSE)

  
#remove files
#  rm(zt, gw.annual, recent.flow, current.stat, current.stat2, tx.sites2, tx.sites, usgs.sites, stats, year.flow, usgs.sites, dwr.sites, stats2, test, url.sites, year.flow2, zt.stats)
  
  
  
















































