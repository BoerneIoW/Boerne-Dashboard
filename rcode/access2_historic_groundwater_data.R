###################################################################################################################################################
#
# Creates initial map layers and downloads historic data for the dashboard
# CREATED BY LAUREN PATTERSON & KYLE ONDA @ THE INTERNET OF WATER
# FEBRUARY 2021
# Run anytime... change county.list if desire. 
# Updated June 2021 by Sophia Bryson for TX.  
#
###################################################################################################################################################

######################################################################################################################################################################
#
#   ACCESS GROUNDWATER DATA FROM GOOGLE SPREADSHEET
#
######################################################################################################################################################################

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

# clean it up
well_1_metadata$Long_Va <- well_1_metadata [2,2]; well_1_metadata$Lat_Va <- well_1_metadata [2,3]; well_1_metadata <- well_1_metadata[-c(2), ]; well_1_metadata$Lat_Va <- unlist(well_1_metadata$Lat_Va); well_1_metadata$Long_Va <- unlist(well_1_metadata$Long_Va)
well_2_metadata$Long_Va <- well_2_metadata [2,2]; well_2_metadata$Lat_Va <- well_2_metadata [2,3]; well_2_metadata <- well_2_metadata[-c(2), ]; well_2_metadata$Lat_Va <- unlist(well_2_metadata$Lat_Va); well_2_metadata$Long_Va <- unlist(well_2_metadata$Long_Va)
well_3_metadata$Long_Va <- well_3_metadata [2,2]; well_3_metadata$Lat_Va <- well_3_metadata [2,3]; well_3_metadata <- well_3_metadata[-c(2), ]; well_3_metadata$Lat_Va <- unlist(well_3_metadata$Lat_Va); well_3_metadata$Long_Va <- unlist(well_3_metadata$Long_Va)
well_4_metadata$Long_Va <- well_4_metadata [2,2]; well_4_metadata$Lat_Va <- well_4_metadata [2,3]; well_4_metadata <- well_4_metadata[-c(2), ]; well_4_metadata$Lat_Va <- unlist(well_4_metadata$Lat_Va); well_4_metadata$Long_Va <- unlist(well_4_metadata$Long_Va)
well_5_metadata$Long_Va <- well_5_metadata [2,2]; well_5_metadata$Lat_Va <- well_5_metadata [2,3]; well_5_metadata <- well_5_metadata[-c(2), ]; well_5_metadata$Lat_Va <- unlist(well_5_metadata$Lat_Va); well_5_metadata$Long_Va <- unlist(well_5_metadata$Long_Va)
well_6_metadata$Long_Va <- well_6_metadata [2,2]; well_6_metadata$Lat_Va <- well_6_metadata [2,3]; well_6_metadata <- well_6_metadata[-c(2), ]; well_6_metadata$Lat_Va <- unlist(well_6_metadata$Lat_Va); well_6_metadata$Long_Va <- unlist(well_6_metadata$Long_Va)
well_7_metadata$Long_Va <- well_7_metadata [2,2]; well_7_metadata$Lat_Va <- well_7_metadata [2,3]; well_7_metadata <- well_7_metadata[-c(2), ]; well_7_metadata$Lat_Va <- unlist(well_7_metadata$Lat_Va); well_7_metadata$Long_Va <- unlist(well_7_metadata$Long_Va)
well_8_metadata$Long_Va <- well_8_metadata [2,2]; well_8_metadata$Lat_Va <- well_8_metadata [2,3]; well_8_metadata <- well_8_metadata[-c(2), ]; well_8_metadata$Lat_Va <- unlist(well_8_metadata$Lat_Va); well_8_metadata$Long_Va <- unlist(well_8_metadata$Long_Va)
well_9_metadata$Long_Va <- well_9_metadata [2,2]; well_9_metadata$Lat_Va <- well_9_metadata [2,3]; well_9_metadata <- well_9_metadata[-c(2), ]; well_9_metadata$Lat_Va <- unlist(well_9_metadata$Lat_Va); well_9_metadata$Long_Va <- unlist(well_9_metadata$Long_Va)
well_10_metadata$Long_Va <- well_10_metadata [2,2]; well_10_metadata$Lat_Va <- well_10_metadata [2,3]; well_10_metadata <- well_10_metadata[-c(2), ]; well_10_metadata$Lat_Va <- unlist(well_10_metadata$Lat_Va); well_10_metadata$Long_Va <- unlist(well_10_metadata$Long_Va)
well_11_metadata$Long_Va <- well_11_metadata [2,2]; well_11_metadata$Lat_Va <- well_11_metadata [2,3]; well_11_metadata <- well_11_metadata[-c(2), ]; well_11_metadata$Lat_Va <- unlist(well_11_metadata$Lat_Va); well_11_metadata$Long_Va <- unlist(well_11_metadata$Long_Va)
well_12_metadata$Long_Va <- well_12_metadata [2,2]; well_12_metadata$Lat_Va <- well_12_metadata [2,3]; well_12_metadata <- well_12_metadata[-c(2), ]; well_12_metadata$Lat_Va <- unlist(well_12_metadata$Lat_Va); well_12_metadata$Long_Va <- unlist(well_12_metadata$Long_Va)
well_13_metadata$Long_Va <- well_13_metadata [2,2]; well_13_metadata$Lat_Va <- well_13_metadata [2,3]; well_13_metadata <- well_13_metadata[-c(2), ]; well_13_metadata$Lat_Va <- unlist(well_13_metadata$Lat_Va); well_13_metadata$Long_Va <- unlist(well_13_metadata$Long_Va)
well_14_metadata$Long_Va <- well_14_metadata [2,2]; well_14_metadata$Lat_Va <- well_14_metadata [2,3]; well_14_metadata <- well_14_metadata[-c(2), ]; well_14_metadata$Lat_Va <- unlist(well_14_metadata$Lat_Va); well_14_metadata$Long_Va <- unlist(well_14_metadata$Long_Va)
well_15_metadata$Long_Va <- well_15_metadata [2,2]; well_15_metadata$Lat_Va <- well_15_metadata [2,3]; well_15_metadata <- well_15_metadata[-c(2), ]; well_15_metadata$Lat_Va <- unlist(well_15_metadata$Lat_Va); well_15_metadata$Long_Va <- unlist(well_15_metadata$Long_Va)
well_16_metadata$Long_Va <- well_16_metadata [2,2]; well_16_metadata$Lat_Va <- well_16_metadata [2,3]; well_16_metadata <- well_16_metadata[-c(2), ]; well_16_metadata$Lat_Va <- unlist(well_16_metadata$Lat_Va); well_16_metadata$Long_Va <- unlist(well_16_metadata$Long_Va)
well_17_metadata$Long_Va <- well_17_metadata [2,2]; well_17_metadata$Lat_Va <- well_17_metadata [2,3]; well_17_metadata <- well_17_metadata[-c(2), ]; well_17_metadata$Lat_Va <- unlist(well_17_metadata$Lat_Va); well_17_metadata$Long_Va <- unlist(well_17_metadata$Long_Va)
well_18_metadata$Long_Va <- well_18_metadata [2,2]; well_18_metadata$Lat_Va <- well_18_metadata [2,3]; well_18_metadata <- well_18_metadata[-c(2), ]; well_18_metadata$Lat_Va <- unlist(well_18_metadata$Lat_Va); well_18_metadata$Long_Va <- unlist(well_18_metadata$Long_Va)
well_19_metadata$Long_Va <- well_19_metadata [2,2]; well_19_metadata$Lat_Va <- well_19_metadata [2,3]; well_19_metadata <- well_19_metadata[-c(2), ]; well_19_metadata$Lat_Va <- unlist(well_19_metadata$Lat_Va); well_19_metadata$Long_Va <- unlist(well_19_metadata$Long_Va)
well_20_metadata$Long_Va <- well_20_metadata [2,2]; well_20_metadata$Lat_Va <- well_20_metadata [2,3]; well_20_metadata <- well_20_metadata[-c(2), ]; well_20_metadata$Lat_Va <- unlist(well_20_metadata$Lat_Va); well_20_metadata$Long_Va <- unlist(well_20_metadata$Long_Va)
well_21_metadata$Long_Va <- well_21_metadata [2,2]; well_21_metadata$Lat_Va <- well_21_metadata [2,3]; well_21_metadata <- well_21_metadata[-c(2), ]; well_21_metadata$Lat_Va <- unlist(well_21_metadata$Lat_Va); well_21_metadata$Long_Va <- unlist(well_21_metadata$Long_Va)
well_22_metadata$Long_Va <- well_22_metadata [2,2]; well_22_metadata$Lat_Va <- well_22_metadata [2,3]; well_22_metadata <- well_22_metadata[-c(2), ]; well_22_metadata$Lat_Va <- unlist(well_22_metadata$Lat_Va); well_22_metadata$Long_Va <- unlist(well_22_metadata$Long_Va)
well_23_metadata$Long_Va <- well_23_metadata [2,2]; well_23_metadata$Lat_Va <- well_23_metadata [2,3]; well_23_metadata <- well_23_metadata[-c(2), ]; well_23_metadata$Lat_Va <- unlist(well_23_metadata$Lat_Va); well_23_metadata$Long_Va <- unlist(well_23_metadata$Long_Va)
well_24_metadata$Long_Va <- well_24_metadata [2,2]; well_24_metadata$Lat_Va <- well_24_metadata [2,3]; well_24_metadata <- well_24_metadata[-c(2), ]; well_24_metadata$Lat_Va <- unlist(well_24_metadata$Lat_Va); well_24_metadata$Long_Va <- unlist(well_24_metadata$Long_Va)
well_25_metadata$Long_Va <- well_25_metadata [2,2]; well_25_metadata$Lat_Va <- well_25_metadata [2,3]; well_25_metadata <- well_25_metadata[-c(2), ]; well_25_metadata$Lat_Va <- unlist(well_25_metadata$Lat_Va); well_25_metadata$Long_Va <- unlist(well_25_metadata$Long_Va)
well_26_metadata$Long_Va <- well_26_metadata [2,2]; well_26_metadata$Lat_Va <- well_26_metadata [2,3]; well_26_metadata <- well_26_metadata[-c(2), ]; well_26_metadata$Lat_Va <- unlist(well_26_metadata$Lat_Va); well_26_metadata$Long_Va <- unlist(well_26_metadata$Long_Va)
well_27_metadata$Long_Va <- well_27_metadata [2,2]; well_27_metadata$Lat_Va <- well_27_metadata [2,3]; well_27_metadata <- well_27_metadata[-c(2), ]; well_27_metadata$Lat_Va <- unlist(well_27_metadata$Lat_Va); well_27_metadata$Long_Va <- unlist(well_27_metadata$Long_Va)
well_28_metadata$Long_Va <- well_28_metadata [2,2]; well_28_metadata$Lat_Va <- well_28_metadata [2,3]; well_28_metadata <- well_28_metadata[-c(2), ]; well_28_metadata$Lat_Va <- unlist(well_28_metadata$Lat_Va); well_28_metadata$Long_Va <- unlist(well_28_metadata$Long_Va)
well_29_metadata$Long_Va <- well_29_metadata [2,2]; well_29_metadata$Lat_Va <- well_29_metadata [2,3]; well_29_metadata <- well_29_metadata[-c(2), ]; well_29_metadata$Lat_Va <- unlist(well_29_metadata$Lat_Va); well_29_metadata$Long_Va <- unlist(well_29_metadata$Long_Va)
well_30_metadata$Long_Va <- well_30_metadata [2,2]; well_30_metadata$Lat_Va <- well_30_metadata [2,3]; well_30_metadata <- well_30_metadata[-c(2), ]; well_30_metadata$Lat_Va <- unlist(well_30_metadata$Lat_Va); well_30_metadata$Long_Va <- unlist(well_30_metadata$Long_Va)
well_31_metadata$Long_Va <- well_31_metadata [2,2]; well_31_metadata$Lat_Va <- well_31_metadata [2,3]; well_31_metadata <- well_31_metadata[-c(2), ]; well_31_metadata$Lat_Va <- unlist(well_31_metadata$Lat_Va); well_31_metadata$Long_Va <- unlist(well_31_metadata$Long_Va)
well_32_metadata$Long_Va <- well_32_metadata [2,2]; well_32_metadata$Lat_Va <- well_32_metadata [2,3]; well_32_metadata <- well_32_metadata[-c(2), ]; well_32_metadata$Lat_Va <- unlist(well_32_metadata$Lat_Va); well_32_metadata$Long_Va <- unlist(well_32_metadata$Long_Va)
well_33_metadata$Long_Va <- well_33_metadata [2,2]; well_33_metadata$Lat_Va <- well_33_metadata [2,3]; well_33_metadata <- well_33_metadata[-c(2), ]; well_33_metadata$Lat_Va <- unlist(well_33_metadata$Lat_Va); well_33_metadata$Long_Va <- unlist(well_33_metadata$Long_Va)
well_34_metadata$Long_Va <- well_34_metadata [2,2]; well_34_metadata$Lat_Va <- well_34_metadata [2,3]; well_34_metadata <- well_34_metadata[-c(2), ]; well_34_metadata$Lat_Va <- unlist(well_34_metadata$Lat_Va); well_34_metadata$Long_Va <- unlist(well_34_metadata$Long_Va)
well_35_metadata$Long_Va <- well_35_metadata [2,2]; well_35_metadata$Lat_Va <- well_35_metadata [2,3]; well_35_metadata <- well_35_metadata[-c(2), ]; well_35_metadata$Lat_Va <- unlist(well_35_metadata$Lat_Va); well_35_metadata$Long_Va <- unlist(well_35_metadata$Long_Va)
well_36_metadata$Long_Va <- well_36_metadata [2,2]; well_36_metadata$Lat_Va <- well_36_metadata [2,3]; well_36_metadata <- well_36_metadata[-c(2), ]; well_36_metadata$Lat_Va <- unlist(well_36_metadata$Lat_Va); well_36_metadata$Long_Va <- unlist(well_36_metadata$Long_Va)
well_37_metadata$Long_Va <- well_37_metadata [2,2]; well_37_metadata$Lat_Va <- well_37_metadata [2,3]; well_37_metadata <- well_37_metadata[-c(2), ]; well_37_metadata$Lat_Va <- unlist(well_37_metadata$Lat_Va); well_37_metadata$Long_Va <- unlist(well_37_metadata$Long_Va)
well_38_metadata$Long_Va <- well_38_metadata [2,2]; well_38_metadata$Lat_Va <- well_38_metadata [2,3]; well_38_metadata <- well_38_metadata[-c(2), ]; well_38_metadata$Lat_Va <- unlist(well_38_metadata$Lat_Va); well_38_metadata$Long_Va <- unlist(well_38_metadata$Long_Va)
well_39_metadata$Long_Va <- well_39_metadata [2,2]; well_39_metadata$Lat_Va <- well_39_metadata [2,3]; well_39_metadata <- well_39_metadata[-c(2), ]; well_39_metadata$Lat_Va <- unlist(well_39_metadata$Lat_Va); well_39_metadata$Long_Va <- unlist(well_39_metadata$Long_Va)
well_40_metadata$Long_Va <- well_40_metadata [2,2]; well_40_metadata$Lat_Va <- well_40_metadata [2,3]; well_40_metadata <- well_40_metadata[-c(2), ]; well_40_metadata$Lat_Va <- unlist(well_40_metadata$Lat_Va); well_40_metadata$Long_Va <- unlist(well_40_metadata$Long_Va)
well_41_metadata$Long_Va <- well_41_metadata [2,2]; well_41_metadata$Lat_Va <- well_41_metadata [2,3]; well_41_metadata <- well_41_metadata[-c(2), ]; well_41_metadata$Lat_Va <- unlist(well_41_metadata$Lat_Va); well_41_metadata$Long_Va <- unlist(well_41_metadata$Long_Va)
well_42_metadata$Long_Va <- well_42_metadata [2,2]; well_42_metadata$Lat_Va <- well_42_metadata [2,3]; well_42_metadata <- well_42_metadata[-c(2), ]; well_42_metadata$Lat_Va <- unlist(well_42_metadata$Lat_Va); well_42_metadata$Long_Va <- unlist(well_42_metadata$Long_Va)

# bind them all together
boerne_all_well_metadata <- rbind(well_1_metadata, well_2_metadata, well_3_metadata, well_4_metadata, well_5_metadata, well_6_metadata, well_7_metadata, well_8_metadata,
                                  well_9_metadata, well_10_metadata, well_11_metadata, well_12_metadata, well_13_metadata, well_14_metadata, well_15_metadata,
                                  well_16_metadata, well_17_metadata, well_18_metadata, well_19_metadata, well_20_metadata, well_22_metadata, well_23_metadata,
                                  well_24_metadata, well_25_metadata, well_26_metadata, well_27_metadata, well_28_metadata, well_29_metadata,
                                  well_30_metadata, well_31_metadata, well_32_metadata, well_33_metadata, well_34_metadata, well_35_metadata,
                                  well_36_metadata, well_37_metadata, well_38_metadata, well_39_metadata, well_40_metadata, well_41_metadata, well_42_metadata, well_21_metadata)
#rename columns
boerne_all_well_metadata <- rename(boerne_all_well_metadata, location = "...1", dec_long_va = "...2", dec_lat_va = "...3",
                                   elevation = "...4", elevation_at_mp = "...5", total_depth = "...6", casing_diameter = "...7",
                                   casing_type = "...8", casing_depth = "...9", cemented = "...10", estimated_gpm = "...11", aquifer = "...12",
                                   strata = "...13", district_id = "...14", state_id = "...15", avg_level = "...16", median_level = "...17",
                                   low = "...18", high = "...19", range = "...20", yrs_in_service = "...21", current = "...22", month = "...23", year = "...24", long_va = "Long_Va", lat_va = "Lat_Va")

boerne_all_well_metadata$agency <- "CCGCD" #include agency that collects data

colnames(boerne_all_well_metadata)
boerne_all_well_metadata <- as.data.frame(boerne_all_well_metadata) # change from a subclass to a data frame

#remove spaces
boerne_all_well_metadata$long_va <- gsub('\\s+', '', boerne_all_well_metadata$long_va)
boerne_all_well_metadata$lat_va <- gsub('\\s+', '', boerne_all_well_metadata$lat_va)

# change from list to numeric and/or string
str(boerne_all_well_metadata)
boerne_all_well_metadata$long_va <- as.numeric(boerne_all_well_metadata$long_va)
boerne_all_well_metadata$lat_va <- as.numeric(boerne_all_well_metadata$lat_va)
boerne_all_well_metadata$dec_long_va <- as.numeric(boerne_all_well_metadata$dec_long_va)
boerne_all_well_metadata$dec_lat_va <- as.numeric(boerne_all_well_metadata$dec_lat_va)
boerne_all_well_metadata$elevation <- as.numeric(boerne_all_well_metadata$elevation)
boerne_all_well_metadata$elevation_at_mp <- as.numeric(boerne_all_well_metadata$elevation_at_mp)
boerne_all_well_metadata$total_depth <- as.numeric(boerne_all_well_metadata$total_depth)
boerne_all_well_metadata$month <- as.numeric(boerne_all_well_metadata$month)
boerne_all_well_metadata$year <- as.numeric(boerne_all_well_metadata$year)
boerne_all_well_metadata$location <- unlist(boerne_all_well_metadata$location)
boerne_all_well_metadata$current <- unlist(boerne_all_well_metadata$current)
str(boerne_all_well_metadata)

# save out
write.csv(boerne_all_well_metadata, paste0(swd_data, "gw/boerne_well_metadata.csv"), row.names = FALSE)

#load in depth to water level data (42 wells)
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

# filter data up to 2021
boerne_all_gw_levels <- boerne_all_gw_levels %>% filter(year <= 2021)

check.last.date <- boerne_all_gw_levels %>% filter(date == max(date)) %>% dplyr::select(date)
table(check.last.date$date)

# save out
write.csv(boerne_all_gw_levels, paste0(swd_data, "gw/boerne_gw_levels.csv"), row.names = FALSE)

#data frame w/o elevation
boerne_gw_depth <- select(boerne_all_gw_levels, c(1, 2, 4, 5,7))

write.csv(boerne_gw_depth, paste0(swd_data, "gw/boerne_gw_depth.csv"), row.names=FALSE)

######################################################################################################################################################################
# mapview of the sites
zt <- st_as_sf(boerne_all_well_metadata, coords = c("dec_long_va", "dec_lat_va"), crs = 4326, agr = "constant")
mapview::mapview(zt)

#visual check - temp
print(ggplot(boerne_all_gw_levels, aes(x = as.Date(date, format = "%Y-%m-%d"), y = -1*depth_ft)) +
        geom_line(color = "steel blue") + geom_point(color = "navy blue") + ggtitle(paste0("Index number: ", i)) +
        xlab("date") + scale_x_date(date_labels = "%Y-%m") +
        ylab("depth below surface (ft)") + ylim(-1.1*max(boerne_all_gw_levels$depth_ft), 0))



######################################################################################################################################################################
#
#   RUN STATS: NOT NEEDED TO BE SAVED OUT
#
######################################################################################################################################################################
#unique sites:
#unique.sites <- unique(boerne_all_gw_levels$site) #42 unique sites.

#set up data frame for stats and include year
#stats <- as.data.frame(matrix(nrow=0,ncol=13));        colnames(stats) <- c("site", "julian", "min", "flow10", "flow25", "flow50", "flow75", "flow90", "max", "Nobs","startYr","endYr","date"); 
#year.flow  <- as.data.frame(matrix(nrow=0, ncol=6));    colnames(year.flow) <- c("site", "agency", "date", "julian", "depth_ft")

#loop through and calculate stats - takes around 20 minutes
#for (i in 1:length(unique.sites)) {
#  zt <- boerne_all_gw_levels %>% filter(site == unique.sites[i]) #one site at a time
  #if (nrow(zt) < 365) {next} #skips over sites with less than a year of data on record - these break the stats & loop. Should only remove 1 site - "304013095220101" 
  
  #summarize by julian
#  zt.stats <- zt %>% group_by(julian) %>% summarize(Nobs = n(), min=round(min(depth_ft, na.rm=TRUE),4), flow10 = round(quantile(depth_ft, 0.10, na.rm=TRUE),4), flow25 = round(quantile(depth_ft, 0.25, na.rm=TRUE),4),
#                                                    flow50 = round(quantile(depth_ft, 0.5, na.rm=TRUE),4), flow75 = round(quantile(depth_ft, 0.75, na.rm=TRUE),4), flow90 = round(quantile(depth_ft, 0.90, na.rm=TRUE),4), 
#                                                    max = round(max(depth_ft, na.rm=TRUE),4),
#                                                    .groups="keep")
#  zt.stats <- zt.stats %>% mutate(site = as.character(unique.sites[i]), startYr = min(zt$year), endYr = max(zt$year)) %>% select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs, startYr, endYr)
  
#  if(dim(zt.stats)[1] == 366) {zt.stats$date2 = julian.ref$day_month_leap} #leap year indexing
#  if(dim(zt.stats)[1] < 366) { #non-leap year indexing. Robust against irregular data dates.
#    sub.jul <- julian.ref %>% filter(julian_index %in% zt.stats$julian) %>% select(day_month, julian_index)
#    zt.stats <- merge(zt.stats, sub.jul, by.x = "julian", by.y = "julian_index", all.x = TRUE) %>%
#      rename(date2 = day_month) %>% select(site, julian, min, flow10, flow25, flow50, flow75, flow90, max, Nobs,startYr,endYr, date2)
#  }
#  zt.stats$date <- format(zt.stats$date2, format="%b-%d")
  
  #fill dataframe
#  stats <- rbind(stats, zt.stats)
#  zt <- zt %>% select(site, agency, date, julian, depth_ft);    colnames(zt) <- c("site", "agency", "date", "julian", "depth_ft")
#  zt <- zt %>% group_by(site, date, julian) %>% summarize(depth_ft = median(depth_ft, na.rm=TRUE), .groups="drop")
#  year.flow <- rbind(year.flow, zt)
  
#  print(paste0(round(100*i/length(unique.sites),2),"% complete"))
#}

#summary(stats) 
#summary(year.flow)


#year.flow <- year.flow %>% filter(year(as.Date(date, format="%Y-%m-%d")) >= year(start.date))
#write.csv(year.flow, paste0(swd_data, "gw/boerne_gw_depth2.csv"), row.names=FALSE) # file doesn't have julian


