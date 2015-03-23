getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read Other Outcomes
check = read.csv(file="ma12.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);

# Rename ContactID
names(check)[names(check)=="Case.Record..Contact.ID"] <- "Contact.ID"
# Rename CaseRecordID
names(check)[names(check)=="Case.Record..Case.Record.Easy.ID."] <- "Case.Record.Easy.ID."

# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows, otherwise "1904-01-01" for Excel Mac
# Sort by ContactID, so we can check values later
check <- check[with(check, order(Contact.ID, Case.Record.Easy.ID., Product.Service..Product.Service.Name)), ]
tempDates <- as.Date(check$Screened.Date, origin="1899-12-30")

# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(check$Screened.Date, n=5)
head(tempDates, n=5)

# Yes, they matched, do rest of Dates
check$Screened.Date <- as.Date(check$Screened.Date, origin="1899-12-30")
check$Applied.Date <- as.Date(check$Applied.Date, origin="1899-12-30")
check$Approved.Date <- as.Date(check$Approved.Date, origin="1899-12-30")
check$Denied.Declined.Date <- as.Date(check$Denied.Declined.Date, origin="1899-12-30")
check$Loan.Packaged.Date <- as.Date(check$Loan.Packaged.Date, origin="1899-12-30")
check$Loan.Disbursed.Dat <- as.Date(check$Loan.Disbursed.Dat, origin="1899-12-30")
check$Loan.Closing.Date <- as.Date(check$Loan.Closing.Date, origin="1899-12-30")
check$Denied.Date.Received.Incentive <- as.Date(check$Date.Received.Incentive, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(check, n=10)

# Check histograms where you expect numbers 
hist(check$UOS..Minutes.)

# Write cleaned csv files
write.csv(check, file = 'cleaned_Other_Outcomes.csv')



