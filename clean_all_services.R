getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read All Services Time
services = read.csv(file="ma5.csv", header=TRUE, sep=",");
names(services);
nrow(services);
head(services, n=5);

# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows, otherwise "1904-01-01" for Excel Mac
# Sort by ContactID, so we can check values later
services <- services[with(services, order(Contact.ID, Case.Record.Easy.ID., Date)), ]
tempDates <- as.Date(services$Date, origin="1899-12-30")

# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(services$Date, n=5)
head(tempDates, n=5)

# Yes, they matched, do rest of Dates
services$Date <- as.Date(services$Date, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(services, n=10)

# Check histograms where you expect numbers 
hist(services$UOS..Minutes.)

# Write cleaned csv files
write.csv(services, file = 'cleaned_all_services.csv')

# Check it
services = read.csv(file="cleaned_all_services.csv", header=TRUE, sep=",")
head(services, n=10

check = read.csv(file="CleanedData/cleaned_workforce_development_program.csv", header=TRUE, sep=",")
head(check, n=10)

check = read.csv(file="CleanedData/cleaned_business_development_program.csv", header=TRUE, sep=",")
head(check, n=10)
