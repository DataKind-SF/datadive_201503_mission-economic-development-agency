getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read FINCAP
check = read.csv(file="ma9.csv", header=TRUE, sep=",");
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
check$Dismissal.Date <- as.Date(check$Dismissal.Date, origin="1899-12-30")
check$Next.Follow.Up.Assessment.Due <- as.Date(check$Next.Follow.Up.Assessment.Due, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(check, n=10)

# Check histograms where you expect numbers 
#hist(check$UOS..Minutes.)

# Write cleaned csv files
write.csv(check, file = 'cleaned_FINCAP.csv')



