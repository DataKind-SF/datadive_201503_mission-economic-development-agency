getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read Financial Assessments
check = read.csv(file="ma4.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);

# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows, otherwise "1904-01-01" for Excel Mac
# Sort by ContactID, so we can check values later
check <- check[with(check, order(Contact.ID)), ]
tempDates <- as.Date(check$Assessment.Date, origin="1899-12-30")

# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(check$Assessment.Date, n=5)
head(tempDates, n=5)

# Yes, they matched, do rest of Dates
check$Assessment.Date <- as.Date(check$Assessment.Date, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(check, n=10)

# Check histograms where you expect numbers 
hist(check$Total.Income.Minus.Expenses)
hist(check$Transportation.Total)

# Write cleaned csv files
write.csv(check, file = 'cleaned_financial_assess.csv')

# Check it
financial_asses = read.csv(file="cleaned_financial_assess.csv", header=TRUE, sep=",");
head(financial_asses, n=10)


