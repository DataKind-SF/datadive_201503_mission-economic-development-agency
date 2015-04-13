#############################
# R Script
# Author Christy Bergman
# Desc:  Create one big demographics table by Contact.ID  
#        By merging HH and individual demographics.  
#        numrow: 16495, not all Contacts have HH info
# 
# Inputs:
#  .Rdata from https://www.dropbox.com/home/DataDive_MEDA
# Outputs:
#  https://www.dropbox.com/home/DataDive_MEDA/merged_outcome_datasets?preview=client_inc_HH_demogr.csv
############################

getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data/CleanedData/DataDive_CleanData"); # set working dir
getwd(); # check working dir

# ##########################
# Load clean data directly from .Rdata. List structure below.
# data[2] = client_inc_demogr
# data[3] = client_HH_demogr
# data[4] = UFA
# data[5] = all services
# data[6] = staff time 1-1
# data[7] = BDP
# data[8] = HOP
# data[9] = FINCAP
# data[10] = Tax
# data[11] = Workforce
# data[12] = Other Outcomes
# data[13] = Job Placements
# ##########################
load("DataKind_DataDive_MEDA_032715_v2_2015-03-26_clean.Rdata")
# read client income demographics
# client_inc_demogr = read.csv(file="DataKind_DataDive_MEDA_032715_v2_2015-03-26_clean_02_Clients_inc_Demographics.csv", header=TRUE, sep=",");
client_inc_demogr <- data.frame(data[[2]])
names(client_inc_demogr);
# read client HH demographics
# client_HH_demogr = read.csv(file="DataKind_DataDive_MEDA_032715_v2_2015-03-26_clean_03_Client_Household_Demographics.csv", header=TRUE, sep=",");
client_HH_demogr <- data.frame(data[[3]])
names(client_HH_demogr);


# ##########################
# Create one big Client Demographics table
# ##########################
client_inc_HH_demogr <- merge(x=client_inc_demogr, y=client_HH_demogr, by="Client.HH.Easy.ID", all.x=TRUE)
names(client_inc_HH_demogr)
nrow(client_inc_demogr);
nrow(client_HH_demogr);
nrow(client_inc_HH_demogr)

#check summary
summary(client_inc_HH_demogr$Household.Size)
summary(client_inc_HH_demogr$Number.of.Direct.Services.Enrolled)
summary(client_inc_HH_demogr$Number.of.Programs.x) 
summary(client_inc_HH_demogr$Annual.Household.Income)

#check a few expected numeric variables
hist(client_inc_HH_demogr$Number.of.Direct.Services.Enrolled)
hist(client_inc_HH_demogr$Number.of.Programs.x)
hist(client_inc_HH_demogr$Annual.Household.Income)

# Write the .csv file
write.csv(client_inc_HH_demogr,file="client_inc_HH_demogr.csv")

