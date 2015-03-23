getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir

# Read Coaching Time
coach = read.csv(file="ma6.csv", header=TRUE, sep=",");
names(coach);
nrow(coach);
head(coach, n=5);

# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows, otherwise "1904-01-01" for Excel Mac
# Sort by ContactID, so we can check values later
coach <- coach[with(coach, order(Contact.ID, Case.Record.Easy.ID., Date)), ]
tempDates <- as.Date(coach$Date, origin="1899-12-30")

# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(coach$Date, n=5)
head(tempDates, n=5)

# Yes, they matched, do rest of Dates
coach$Date <- as.Date(coach$Date, origin="1899-12-30")
coach$Created.Date <- as.Date(coach$Created.Date, origin="1899-12-30")

# Eyeball your data for strange-looking dates
head(coach, n=10)

# Check histograms where you expect numbers 
hist(coach$UOS..Time.Spent.in.Minutes.)

# Write cleaned csv files
write.csv(coach, file = 'cleaned_staff_time_1-1_coach.csv')

# Check it
coach = read.csv(file="cleaned_staff_time_1-1_coach.csv", header=TRUE, sep=",");
head(coach, n=10)

