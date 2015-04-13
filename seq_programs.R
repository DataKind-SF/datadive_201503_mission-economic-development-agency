#############################
# R Script
# Author Christy Bergman
# Desc:  Create dataset to visualize program bundling and DISC success time sequences
#        Final presentation showed just 3 programs (home, bdp, fincap) by enrollment date.
#        Michelle from MEDA suggested using different date field with less missing data and all programs.
# 
# Data Input:
# 1. .Rdata from https://www.dropbox.com/home/DataDive_MEDA
# Data Output:
# 1. https://www.dropbox.com/home/DataDive_MEDA/visualizations/seq_demogr.csv
# 2. https://www.dropbox.com/home/DataDive_MEDA/visualizations/seq_demogr2.csv
# Viz Output:
# 1. https://www.dropbox.com/home/DataDive_MEDA/visualizations?preview=seq_programs.twbx
# 2. https://www.dropbox.com/home/DataDive_MEDA/visualizations?preview=seq_programs2.twbx
#
# Data Notes:  
# Missing Data - Approx 1000 clients had missing Enrollment Date, this will throw off visualization.
# Dirty Data - Approx 100 clients were entered 2x for the same program, this will throw off counts.
#
# 4/12/2015 - Revised program per Michelle's advice to use "Most Recent Service Date" instead of Enrollment Dates.
# Also included all programs.  Results 2nd Data+Viz Outputs.
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

# ##########################
# Program Data - keep only 
#  Contact.ID
#  Date.of.Most.Recent.Direct.Service
#  Program.Name
#
# Note: originally coded this using Enrollment.Date.
# ##########################
# read BDP program data
bdp <- data[[7]]
nrow(bdp)
names(bdp)
# keep only Contact.ID, ProgramName, EnrollmentDate
#bdp <- bdp[, c(1, 7, 3)]
# keep only Contact.ID, ProgramName, Date.of.Most.Recent.Direct.Service
bdp <- bdp[, c(1, 10, 3)]
nrow(bdp)
# read HOP program data
hop <- data[[8]]
names(hop)
nrow(hop)
# keep same few cols
#hop <- hop[, c(1, 7, 3)]
hop <- hop[, c(1, 11, 3)]
names(hop)
nrow(hop)
# read FINCAP program data
fin <- data[[9]]
names(fin)
nrow(fin)
# keep same few cols
#fin <- fin[, c(1, 8, 2)]
fin <- fin[, c(1, 11, 2)]
names(fin)
nrow(fin)
# read TAX program data
tax <- data[[10]]
names(tax)
nrow(tax)
# keep same few cols
#tax <- tax[, c(1, 6, 2)]
tax <- tax[, c(1, 9, 2)]
names(tax)
nrow(tax)
# read WORKforce program data
work <- data[[11]]
names(work)
nrow(work)
# keep same few cols
#work <- work[, c(1, 6, 2)]
work <- work[, c(1, 9, 2)]
names(work)
nrow(work)


# ##########################
# Append Programs into one big frame
# ##########################
allp <- rbind(as.matrix(hop), as.matrix(bdp))
allp <- rbind(as.matrix(allp), as.matrix(fin))
allp <- rbind(as.matrix(allp), as.matrix(tax))
allp <- rbind(as.matrix(allp), as.matrix(work))
allp <- data.frame(allp)
sapply(allp, mode)


# ##########################
# Dirty Data Check:  count duplicate client entries in same program
# Notice approx 100 clients were entered 2x in same program,
# Note: Lots of duplicate clients per program (same clientIDs appear 2x per program).  
# ##########################
ndup <- data.frame(table(bdp$Contact.ID))
bdpidx <- ndup[ndup$Freq > 1,]
ndup <- data.frame(table(hop$Contact.ID))
hopidx <- ndup[ndup$Freq > 1,]
ndup <- data.frame(table(fin$Contact.ID))
finidx <- ndup[ndup$Freq > 1,]
ndup <- data.frame(table(tax$Contact.ID))
workidx <- ndup[ndup$Freq > 1,]
ndup <- data.frame(table(work$Contact.ID))
taxidx <- ndup[ndup$Freq > 1,]

# ##########################
# Missing Data Check:  Program Enrollment date appears to be missing
# Found approx 1000 missing values or approx 10% of database.
# ##########################
#sapply(allp, function(x) sum(is.na(x)))


# ##########################
# Count clients who bundled programs. Ignore 2x or fewer programs.    
# 2x is either error (due to dirty data above) or MEDA requirement bdp+fin together.
# ##########################
ndup <- data.frame(table(allp$Contact.ID))
allpidx <- ndup[ndup$Freq > 3,] #high bundles are > 3 since 3 is just "single bundle"
nrow(bdpidx)
nrow(hopidx)
nrow(finidx)
nrow(workidx)
nrow(taxidx)
nrow(allpidx)
summary(allp)


# ##########################
# Append Bundling Clients into 1 big vis table
# 51 clients with bundled >3 programs
# 210 observations all client/program combos
# ##########################
allpidx <- allpidx[with(allpidx, order(-Freq)), ]
vis <- allp[allp$Contact.ID %in% allpidx[, c(1)], ]
nrow(vis)
sapply(vis, mode)
# notice .csv files lost leading 00's in front of Contact.ID
#vis$Contact.ID <- formatC(as.numeric(vis$Contact.ID), format='f',width=7, digits=0, flag=0)
#vis$Date.of.Most.Recent.Direct.Service <- as.Date(vis$Date.of.Most.Recent.Direct.Service, origin="1899-12-30")
#vis$Program.Name <- formatC(as.character(vis$Program.Name))
sapply(vis, mode)
#vis <- vis[ order(vis[,3]), ] #order by Program Name
write.csv(vis, file="seq.csv")


# ##########################
# Read reduced financial assessments table
# 1783 clients with DISC measures
# ##########################
red = read.csv(file="merged_outcome_datasets/fin_assess_reduced.csv", header=TRUE, sep=",");
names(red)
nrow(red)
sapply(red, mode)
# notice csv lost leading 00's in front of Contact.ID and dates
red$Contact.ID <- formatC(as.numeric(red$Contact.ID), format='f',width=7, digits=0, flag=0)
red$Assessment.Date <- as.Date(red$Assessment.Date, origin="1899-12-30")
red$Program.Name <- formatC(as.character(red$Program.Name))
#check expect lots of duplicate entries by client.ID
ndup <- data.frame(table(red$Contact.ID))
redidx <- ndup[ndup$Freq > 1,]
nrow(redidx)


# ##########################
# Merge DISC success into Vis tables
# For each client who bundled keep those with financial assessments
# 469 observations total of 38 clients
# #########################
# make sure columns exactly match between red and vis
names(red)
red <- transform(red, Program.Name = "")
colnames(red)[4] <- "Date.of.Most.Recent.Direct.Service"
red <- red[ -c(1)] #drop column X
movetolast <- function(data, move) {
  data[c(setdiff(names(data), move), move)]
}
red <- movetolast(red, c("Order", "D", "I", "S", "C"))
vis <- transform(vis, Order = NA)
vis <- transform(vis, D = NA)
vis <- transform(vis, I = NA)
vis <- transform(vis, S = NA)
vis <- transform(vis, C = NA)
# double check your column names
names(red)
names(vis)
# limit to just clients who bundled
#red <- red[red$Contact.ID %in% allpidx[, c(1)], ]
red_temp <- red[red$Contact.ID %in% vis[, c(1)], ]
nrow(red_temp)
# append keeping all financial assessments for clients who bundled
vis <- rbind(as.matrix(vis), as.matrix(red_temp))
nrow(vis)
write.csv(red_temp, file="seq2.csv")


# ##########################
# Read the big Client Demographics table
# ##########################
client_inc_HH_demogr = read.csv(file="merged_outcome_datasets/client_inc_HH_demogr.csv", header=TRUE, sep=",");
client_inc_HH_demogr$Contact.ID <- formatC(as.numeric(client_inc_HH_demogr$Contact.ID), format='f',width=7, digits=0, flag=0)
names(client_inc_HH_demogr)
nrow(client_inc_HH_demogr)
sapply(client_inc_HH_demogr, mode)


# ##########################
# Merge Demographics into Vis tables
# #########################
# notice .csv files lost leading 00's in front of Contact.ID
client_inc_HH_demogr$Contact.ID <- formatC(as.numeric(client_inc_HH_demogr$Contact.ID), format='f',width=7, digits=0, flag=0)

# Read vis again, if necessary
vis = read.csv(file="seq_demogr2.csv", header=TRUE, sep=",");
vis$Contact.ID <- formatC(as.numeric(vis$Contact.ID), format='f',width=7, digits=0, flag=0)
#vis <- vis[ -c(4)] #drop column X
sapply(vis, mode)
names(vis)
# skip above section if don't need to read in .csv

vis2 <- merge(x=vis, y=client_inc_HH_demogr, by="Contact.ID", all.x=TRUE)
nrow(vis2)
#write.csv(red_temp, file="seq_demogr.csv")
write.csv(vis2, file="seq_demogr2.csv")



