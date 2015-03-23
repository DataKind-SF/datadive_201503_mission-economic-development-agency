####
# Clean up sheet#13, Job Placements
# Author: Ming Lu
# Modified: CB
# Subset on "Program" field = "Workforce Development" 
# Drop some columns
# 
### 	


getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read Workforce Program Data
bd = read.csv(file="ma11.csv", header=TRUE, sep=",");
names(bd);
nrow(bd);
head(bd, n=5);

# Rename ContactID
names(bd)[names(bd)=="Client..Contact.ID"] <- "Contact.ID"
                            
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
# Assume Excel came from Windows
# Sort by ContactID, so we can check values later
bd <- bd[with(bd, order(Contact.ID)), ]
tempDates <- as.Date(bd$Most.Recent.Start.Date, origin="1899-12-30")
# Check dates with original .xls sheet, sorted by ClientID
head(bd$Most.Recent.Start.Date, n=20)
head(tempDates, n=20)
# Yes, they matched, so origin date assumption was correct, do rest of Dates
bd$Most.Recent.Start.Date <- as.Date(bd$Most.Recent.Start.Date, origin="1899-12-30")
bd$Intake.Date <- as.Date(bd$Intake.Date, origin="1899-12-30")
bd$Enrolled.Date <- as.Date(bd$Enrolled.Date, origin="1899-12-30")
bd$Date.of.Most.Recent.Direct.Service <- as.Date(bd$Date.of.Most.Recent.Direct.Service, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(bd, n=10)

# Write cleaned csv files
write.csv(bd, file = 'cleaned_workforce_program.csv')