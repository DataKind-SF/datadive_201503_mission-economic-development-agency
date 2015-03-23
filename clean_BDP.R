getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read BDP
check = read.csv(file="ma7.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);

# Rename 
names(check)[names(check)=="Client..Contact.ID"] <- "Contact.ID"

# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows, otherwise "1904-01-01" for Excel Mac
# Sort by ContactID, so we can check values later
check <- check[with(check, order(Contact.ID)), ]
tempDates <- as.Date(check$Enrolled.Date, origin="1899-12-30")

# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(check$Enrolled.Date, n=5)
head(tempDates, n=5)

# Yes, they matched, do rest of Dates
check$Intake.Date <- as.Date(check$Intake.Date, origin="1899-12-30")
check$Enrolled.Date <- as.Date(check$Enrolled.Date, origin="1899-12-30")
check$Date.of.Most.Recent.Direct.Service <- as.Date(check$Date.of.Most.Recent.Direct.Service, origin="1899-12-30")
check$Pre.Startup.Status.Date <- as.Date(check$Pre.Startup.Status.Date, origin="1899-12-30")
check$Startup.Status.Date <- as.Date(check$Startup.Status.Date, origin="1899-12-30")
check$Established.Business.Status.Date <- as.Date(check$Established.Business.Status.Date, origin="1899-12-30")
check$Expanded.Business.Status.Date <- as.Date(check$Expanded.Business.Status.Date, origin="1899-12-30")
check$Closed.Business.Status.Date <- as.Date(check$Closed.Business.Status.Date, origin="1899-12-30")
check$Core.Training.Grad.Date <- as.Date(check$Core.Training.Grad.Date, origin="1899-12-30")
check$Business.Plan.Complete <- as.Date(check$Business.Plan.Complete, origin="1899-12-30")
check$Marketing.Plan.Complete <- as.Date(check$Marketing.Plan.Complete, origin="1899-12-30")
check$Business.Operations.Plan.Complete <- as.Date(check$Business.Operations.Plan.Complete, origin="1899-12-30")
check$Obtained.Business.License <- as.Date(check$Obtained.Business.License, origin="1899-12-30")
check$Business.Financials.Completed <- as.Date(check$Business.Financials.Completed, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(check, n=10)

# Check histograms where you expect numbers 
#hist(check$UOS..Minutes.)

# Write cleaned csv files
write.csv(check, file = 'cleaned_BDP.csv')

# Check it
check = read.csv(file="cleaned_BDP.csv", header=TRUE, sep=",")
head(check, n=10


