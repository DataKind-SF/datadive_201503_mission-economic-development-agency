#############################
# R Script
# Author Christy Bergman
# Desc:  Create a reduced Financial Assessments table  
#        Preserver orginal structure by ClientID, by Date of Assessment  
#        Reduce each DISC variable to just one letter D,I,S,C with T/F success or not
# 
# Inputs:
#  .Rdata from https://www.dropbox.com/home/DataDive_MEDA 
# Outputs:
#  https://www.dropbox.com/home/DataDive_MEDA/merged_outcome_datasets?preview=fin_assess_reduced.csv
############################

install.packages('dplyr')
library(dplyr)
require(dplyr)

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
load("DataKind_DataDive_MEDA_032715_v2_2015-03-27_clean.Rdata")
# Read Universal Financial Assessments data
ufa <- data[[4]]
names(ufa)
nrow(ufa)

# ##########################
# Create Reduced Financial Assessments table
# Keep ContactID, Order, Date, and below
#  D = X.Change.to.Debt.from.Baseline <= -5%
#  I = X.Change.to.HH.Income.from.Baseline > 5%
#  S = X4.Weeks.of.Mo..Expenses.Saved == “TRUE”
#  C = Greatest.Credit.Gain.Value.de.Baseline is “Success” if max (Equifax score, Experian Score, TransUnion Score) >= 650
# Could rename later using command names(df)[names(df)=="old"] <- "new"
############################
red <- ufa[, c(1, 18, 19, 3, 4, 5, 6, 10, 11, 12)]
names(red)
nrow(red)

# Check data types
sapply(red, mode)
# Convert from character to Number
red$X.Change.to.Debt.from.Baseline <- 
  as.numeric(red$X.Change.to.Debt.from.Baseline)
# Notice that NAs introduced by coercion
summary(red$X.Change.to.Debt.from.Baseline)
# For these calculations, replace NA with 0 is OK
#red[is.na(red)] <- 0
# Force dates, just in case
red$Assessment.Date <- as.Date(red$Assessment.Date, origin="1899-12-30")

# Add variable D
red$D <- 
  ifelse(red$X.Change.to.Debt.from.Baseline <= -5, 
         "TRUE", "FALSE")

# Add variable I
red$I <- 
  ifelse(red$X.Change.to.HH.Income.from.Baseline > 5, 
         "TRUE", "FALSE")

# Add variable S
names(red)[names(red)=="X4.Weeks.of.Mo.Expenses.Saved"] <- "S"

# Add variable C
red <- red %>% 
  mutate(C = ifelse(Equifax.score > 650, "TRUE", 
                    ifelse(Experian.Score > 650, "TRUE", 
                           ifelse(TransUnion.Score > 650, "TRUE","FALSE"))))

names(red)
nrow(red)
head(red, n=20)

#Drop the unnecessary columns
red <- red[ -c(4, 5, 7:10)]
names(red)
nrow(red)

summary(red$D)
summary(red$I)
summary(red$S)
summary(red$C)

red$D <- factor(red$D)
red$I <- factor(red$I)
red$S <- factor(red$S)
red$C <- factor(red$C)
summary(red)
levels(red)

# Double check types again
sapply(red, mode)

# Write the .csv file
write.csv(red, file="fin_assess_reduced.csv")
