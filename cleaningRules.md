# Cleaning Documentation

This is an R Markdown document using R Markdown see <http://rmarkdown.rstudio.com>.  In R Studio, load this Cleaning_rules.Rmd file, click the **File > Knit** button to generate R documentation.

SOURCE DATA
**Source data is located in <https://www.dropbox.com/home/DataKind%20DataDive>.**  

1. DataKind_DataDive_MEDA_032715_v2.xlsx = original Excel file from MEDA 
2. DataKind_DataDive_MEDA_032715.Rdata = All sheets as pandas structure 
3. ma2.csv = 2nd sheet from original Excel saved as its own .csv 
4. ... 
14. ma13.csv = 13th sheet from original Excel saved as its own .csv

## Load Data  
1. Copy the source data above somewhere locally 
2. In R console, set your default dir to location in 1. above where you copied data 

```{r 
getwd();  # check working dir
setwd("C:/Users/bergmc/Documents/cb/volunteer/DataKind/MedaSF/data"); # set working dir
getwd(); # check working dir
```
3. Decide how to read your data into R.  
a)  You could just load .Rdata and you automatically have all sheets as pandas
```{r 
load("DataKind_DataDive_MEDA_032715.Rdata")
```
b)  Or, you could use read.csv(), in which case you have to manually re-convert types such as Dates and numbers
```{r 
mydf2 = read.csv(file="ma2.csv", header=TRUE, sep=",")
```

## Cleanup by sheet 
1. **Schema of Record Relationships** - no cleanup required 
2. **Clients inc. Demographics**, cleaned using "Client_Demographics.wrangle.txt" in <http://trifacta.com>: 
```{r
splitrows col: column1 on: '\r\n'
split col: column1 on: ',' limit: 32 quote: '\"'
header
drop col: column
drop col: Client_Household_ID
drop col: Household_Size
settype col: Household_Members_Under_18 type: 'Integer'
drop col: Income_Level_HUD_2013
settype col: Annual_Household_Income type: 'Integer'
drop col: Family_Schools
drop col: Medical_Home_Place_Child
drop col: MPN_Household
drop col: MPN_Population_Level
drop col: Number_of_Active_Case_Participations
drop col: Number_of_Active_Case_Records
drop col: Number_of_Active_Programs
drop col: Number_of_Case_Participations
drop col: Number_of_Case_Records
drop col: Number_of_Direct_Services_Enrolled
drop col: Number_of_Groups_Classes
drop col: Number_of_Programs
drop col: Number_of_Referrals
drop col: Number_of_Services
drop col: Num_Group_Class_Direct_Services_Enrolled
drop col: Sum_Minutes_Group_Class_Direct_Services_Enrolled
drop col: Sum_Minutes_of_Direct_Services_Enrollled
settype col: Mailing_Zip_Postal_Code type: 'Zipcode'
settype col: Medical_Care_for_Child type: 'Bool'
splitrows col: column1 on: 'trifacta'
split col: column1 on: 'trifacta'
replace col: * on: '' with: '' global: true
standardize with: dictionary_3 col: Mailing_City threshold: 0.85
```
3. **Client Household Demographics**, cleaned using "Client_Demographics.wrangle.txt" in <http://trifacta.com>: 
```{r
load location: 'id:\/\/7'
splitrows col: column1 on: '\r' quote: '\"'
split col: column1 on: ',' limit: 41 quote: '\"'
header
drop col: Signed_MPN_consent, San_Francisco_District, Primary_language_spoken_at_home, Created_Date, School, School_Address, Client_Household_Medical_Home_Place_Child, Client_Household_Family_Schools, Client_Household_MPN_Household, Client_Household_MPN_Flag, Client_Household_MPN_Population_Level, Number_of_Referrals, All_Active_Services, All_Services, Sum_Group_Class_Direct_Services_Enrolled, Num_Group_Class_Direct_Services_Enrolled, Number_of_Services, Number_of_Active_Services, Sum_of_Direct_Services_Enrollled, All_Programs, All_Active_Programs, Number_of_Active_Programs
drop col: Client_Contact_ID
replace col: Primary_State_Province on: `{delim}` with: '' global: true
settype col: Current_Grade_or_Pre_K type: 'String'
settype col: Number_of_Completed_Programs type: 'Integer'
settype col: Primary_Zip_Postal_Code type: 'Zipcode'
set col: Hispanic_Origin value: '' row: Hispanic_Origin == 'Choose not to respond'
```
4. **Universal Financial Assessments**, cleaned in R, cleaned in R
```{r
# Read Financial Assessments
check = read.csv(file="ma4.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
# Sort by ContactID, so we can check values later
check <- check[with(check, order(Contact.ID)), ]
tempDates <- as.Date(check$Assessment.Date, origin="1899-12-30")
# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(check$Assessment.Date, n=5)
head(tempDates, n=5)
# Yes, they matched, do rest of Dates
check$Assessment.Date <- as.Date(check$Assessment.Date, origin="1899-12-30")
# Check histograms where you expect numbers 
hist(check$Total.Income.Minus.Expenses)
hist(check$Transportation.Total)
# Write cleaned csv files
write.csv(check, file = 'cleaned_financial_assess.csv')
```
5. **All Services Provided**, cleaned in R, cleaned in R
```{r
# Read All Services Time
services = read.csv(file="ma5.csv", header=TRUE, sep=",");
names(services);
nrow(services);
head(services, n=5);
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
# Sort by ContactID, so we can check values later
services <- services[with(services, order(Contact.ID, Case.Record.Easy.ID., Date)), ]
tempDates <- as.Date(services$Date, origin="1899-12-30")
# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(services$Date, n=5)
head(tempDates, n=5)
# Yes, they matched, do rest of Dates
services$Date <- as.Date(services$Date, origin="1899-12-30")
# Check histograms where you expect numbers 
hist(services$UOS..Minutes.)
# Write cleaned csv files
write.csv(services, file = 'cleaned_all_services.csv')
```
6. **Staff Time 1-1 Coaching Only**, cleaned in R, cleaned in R
```{r
# Read Coaching Time
coach = read.csv(file="ma6.csv", header=TRUE, sep=",");
names(coach);
nrow(coach);
head(coach, n=5);
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
# Sort by ContactID, so we can check values later
coach <- coach[with(coach, order(Contact.ID, Case.Record.Easy.ID., Date)), ]
tempDates <- as.Date(coach$Date, origin="1899-12-30")
# Check dates with original .xls sheet, sorted by ClientID, filtered by Program=Workforce Development
head(coach$Date, n=5)
head(tempDates, n=5)
# Yes, they matched, do rest of Dates
coach$Date <- as.Date(coach$Date, origin="1899-12-30")
coach$Created.Date <- as.Date(coach$Created.Date, origin="1899-12-30")
# Check histograms where you expect numbers 
hist(coach$UOS..Time.Spent.in.Minutes.)
# Write cleaned csv files
write.csv(coach, file = 'cleaned_staff_time_1-1_coach.csv')
```
7. **BDP Case Records:**, cleaned in R, cleaned in R
```{r
# Read BDP
check = read.csv(file="ma7.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);
# Rename Client.ID
names(check)[names(check)=="Client..Contact.ID"] <- "Contact.ID"
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
# Sort by ContactID, so we can check values later
check <- check[with(check, order(Contact.ID)), ]
tempDates <- as.Date(check$Enrolled.Date, origin="1899-12-30")
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
# Write cleaned csv files
write.csv(check, file = 'cleaned_BDP.csv')
```
8. **HOP Case Records**, cleaned in R, cleaned in R
```{r
# Read HOP
check = read.csv(file="ma8.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);
# Rename Client.ID
names(check)[names(check)=="Client..Contact.ID"] <- "Contact.ID"
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
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
check$Homeownership.Status.Date <- as.Date(check$Homeownership.Status.Date, origin="1899-12-30")
# Check histograms where you expect numbers 
hist(check$UOS..Minutes.)
# Write cleaned csv files
write.csv(check, file = 'cleaned_HOP.csv')
```
9. **FINCAP Case Records**, cleaned in R, cleaned in R
```{r
# Read FINCAP
check = read.csv(file="ma9.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);
# Rename Client.ID
names(check)[names(check)=="Client..Contact.ID"] <- "Contact.ID"
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
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
# Write cleaned csv files
write.csv(check, file = 'cleaned_FINCAP.csv')
```
11. **Workforce Case Records**, cleaned in R, cleaned in R
```{r
# Read Workforce Program Data
bd = read.csv(file="ma11.csv", header=TRUE, sep=",");
names(bd);
nrow(bd);
head(bd, n=5);
# Rename ContactID
names(bd)[names(bd)=="Client..Contact.ID"] <- "Contact.ID"          
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30"
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
# Write cleaned csv files
write.csv(bd, file = 'cleaned_workforce_program.csv')
```
12. **Other Outcomes and Milestones**, cleaned in R, cleaned in R
```{r
# Read Other Outcomes
check = read.csv(file="ma12.csv", header=TRUE, sep=",");
names(check);
nrow(check);
head(check, n=5);
# Rename ContactID
names(check)[names(check)=="Case.Record..Contact.ID"] <- "Contact.ID"
# Rename CaseRecordID
names(check)[names(check)=="Case.Record..Case.Record.Easy.ID."] <- "Case.Record.Easy.ID."
# Convert .csv dates into R dates, format 'mm/dd/yyyy', origin="1899-12-30" for Excel Windows
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
check$Loan.Disbursed.Date <- as.Date(check$Loan.Disbursed.Date, origin="1899-12-30")
check$Loan.Closing.Date <- as.Date(check$Loan.Closing.Date, origin="1899-12-30")
check$Denied.Date.Received.Incentive <- as.Date(check$Date.Received.Incentive, origin="1899-12-30")
# Write cleaned csv files
write.csv(check, file = 'cleaned_Other_Outcomes.csv')
```
