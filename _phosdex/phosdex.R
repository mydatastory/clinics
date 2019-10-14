#DataDog frame on 'hacking into UNIVAC'# 

# ------------------------------------------------------------------
# MyDataStory - Exploring a Data Frame
# Story: Fountain of Youth?
# Dateset: Florida Census 2010
# By: Scott Cohen
# 
# Goal: Use R functions to summarize the contents of a data frame 
# Learning Objective: 
# ------------------------------------------------------------------

# Set working directory and download datasets
setwd("/Users/ScottCohen/OneDrive - University of Florida/MyDataStory")

#Import dataset and save as new data frame
FLCensus2010_df<-read.csv("data/FLCensus2010.csv",stringsAsFactors = F)

# How many rows and columns are there? 
dim(FLCensus2010_df) #4182 rows (observations) and 20 columns (variables)

# Names of the variables (columns)?
names(FLCensus2010_df)

# What types of variables are these? General summary of the structure of the data frame?
str(FLCensus2010_df)

# What does the data actully look like? Print Data
FLCensus2010_df

# Too much! How do I see the first few observations?
head(FLCensus2010_df) #Default at 6 rows
head(FLCensus2010_df, n=4) #Use the "n" to change to only 4 rows
tail(FLCensus2010_df) # See the last 6 rows

# Can I just get a spreadsheet view? The console makes everything hard to see...
View(FLCensus2010_df)

# ------------------------------------------------------------------
# MyDataStory - Subsetting
# Story: Fountain of Youth?
# Dateset: Florida Census 2010
# By: Scott Cohen
#
# Goal:  
# Learning Objective: 
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# The base R approach to subsetting...
# ------------------------------------------------------------------
setwd("/Users/ScottCohen/OneDrive - University of Florida/MyDataStory")
FLCensus2010_df<-read.csv("data/FLCensus2010.csv",stringsAsFactors = F)

# We can use the base R subset() function to create the subset.
Alachua_df <- subset(FLCensus2010_df, County == 'St Johns',
               select = c(GEOID, County, Actual_Age))
head(Alachua_df)

# Or we can use R indexes to accomplish the same result.
Alachua_df <- FLCensus2010_df[FLCensus2010_df$County == 'St Johns',
           c("GEOID","County","Actual_Age")]
head(Alachua_df)



# The dplyr approach to subsetting...  
library(dplyr)

# We can use the dplyr functions independently, using df2 as an intermediate
# dataframe to hold filtered results.
Alachua_df2  <- filter(FLCensus2010_df, County == 'St Johns')
Alachua_df <- select(Alachua_df2,GEOID, County, Actual_Age)
head(Alachua_df)

# Or we can use the pipe operator to accomplish everything in one fell swoop.
Alachua_df <- filter(FLCensus2010_df, County == 'St Johns') %>%
  select(GEOID, County, Actual_Age)
head(Alachua_df)



# The SQL approach to subsetting...
#
#install.packages("RSQLite")
#library ("RSQLite")
#
#con <- dbConnect(drv = SQLite(), dbname = "MyDataStory.db")
#
# With SQL, we simply query the database directly.  Alternatively, we could create
# a view in the database, thereby reducing the amount of code passed to the db engine.
#
#dbListTables(con)
#dbWriteTable(con, "FLCensus2010", FLCensus2010_df)
#Alachua_df<-dbGetQuery(con, "SELECT GEOID, POP10, Actual_Age FROM FLCensus2010 WHERE County = 'Alachua'")
#head(Alachua_df)
#
#Close SQL database connection
#dbDisconnect(con)

# ------------------------------------------------------------------
# MyDataStory - Data Manipulation
# Story: Fountain of Youth?
# Dateset: Florida Census 2010
# By: Scott Cohen
# 
# Goal: 
# Learning Objective: 
# ------------------------------------------------------------------



# ------------------------------------------------------------------
# MyDataStory - Joining/Merge
# Story: Fountain of Youth?
# Dateset: Florida Census 2010, IlludiumPhosdex2018
# By: Scott Cohen
# 
# Goal: Combine two dataframes into one
# Learning Objective: Learn and apply different types of joining types and methods
# ------------------------------------------------------------------

# Set working directory and download datasets
setwd("/Users/ScottCohen/OneDrive - University of Florida/MyDataStory/")
FLCensus2010_df<-read.csv("data/FLCensus2010.csv",stringsAsFactors = F)
Phosdex2018_df<-read.csv("data/IlludiumPhosdex2018.csv",stringsAsFactors = F)

View(Phosdex2018_df)
# Main Types of Joins
# Inner/Natural = Keep only rows that match from the data frames
# Full Join = Keep all rows from both data frames, regardless of matching
# Left Join = Include all the rows in data frame A and only those that match in data frame B
# Right join = Include all the rows in data frame B and only those that match in data frame A

# FLCensus2010_df contains all Census Tracts in Florida (Data Frame A)
# IlludiumPhosdex2018_df contains environmental sampling data for 2018 by Census Tract in FLorida (Data Frame B)

# Before joining, lets review the structure of the datasets
str(FLCensus2010_df)
str(Phosdex2018_df)

# GEOID is going to be the variable we basing the matching on, this is because it is the unique identifier in both datasets
merged_df1 <- merge(FLCensus2010_df,Phosdex2018_df, by = "GEOID") #Inner/Natural Join
head(merged_df1) #Column names that overlap in the datasets gets an .*dataframe* added to the name

#If we only want to merge selected columns, we can do this by subseting the data as we merge 
merged_df1a <- merge(FLCensus2010_df, Phosdex2018_df[ , c("GEOID","Date_Sampled","Illudium_Phosdex")], by = "GEOID")
head(merged_df1a)

#If we want to merge Data Frame B into A without removing the rows in A that do not match, we want to do a LEFT join
merged_df2 <- merge(FLCensus2010_df, Phosdex2018_df[ , c("GEOID","Date_Sampled","Illudium_Phosdex")], by = "GEOID", all.x = TRUE)
str(merged_df2) # Notice we still have the same number of observation from the FLCensus2010 data frame
head(merged_df2) # Those do not match have missing data ("NA")


# ------------------------------------------------------------------
# MyDataStory - Descriptive Statistics/Summarizing Data
# Story: Fountain of Youth?
# Dateset: Merged Data Frame (Florida Census 2010 + IlludiumPhosdex2018)
# By: Scott Cohen
# 
# Goal:  
# Learning Objective: 
# ------------------------------------------------------------------

#Basic Descriptive Statsitics Functions
mean(merged_df1a$Illudium_Phosdex)    # Mean
sd(merged_df1a$Illudium_Phosdex)      # Standard Deviation
var(merged_df1a$Illudium_Phosdex)     # Variance
min(merged_df1a$Illudium_Phosdex)     # Minimum value
max(merged_df1a$Illudium_Phosdex)     # Maximum value
median(merged_df1a$Illudium_Phosdex)  # Median
range(merged_df1a$Illudium_Phosdex)   # Range
quantile(merged_df1a$Illudium_Phosdex)# Quantiles
IQR(merged_df1a$Illudium_Phosdex)     #Interquartile Range

#NOTE: These functions require no missing values. You can use the na.rm = TRUE option to remove missing values prior to calculation

#Overall summary of every variable within the data frame
summary(merged_df1a)

#Descriptive statistics by groups using frequency/contingency tables
# Frequncy (contingency) Tables = Compare one or more categorical variables
table(merged_df1a$County) # Simple table with 1 categorical variable
table(merged_df1a$GEOID, merged_df1a$County) 

# ------------------------------------------------------------------
# MyDataStory - Measures of Association
# Story: Fountain of Youth?
# Dateset: Merged Data Frame (Florida Census 2010 + IlludiumPhosdex2018)
# By: Scott Cohen
# 
# Goal:  
# Learning Objective: 
# ------------------------------------------------------------------

#Correlation
#Chi-Square
#Fisher's Exact
#T-test, paired T-Test
#One-Way ANOVA
#Wilcoxson Rank Sum, Signed-Ranked Sum
#Linear Regression

# ------------------------------------------------------------------
# MyDataStory - Hypothesis Testing
# Story: Fountain of Youth?
# Dateset: Merged Data Frame (Florida Census 2010 + IlludiumPhosdex2018)
# By: Scott Cohen
# 
# Goal:  
# Learning Objective: 
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# MyDataStory - Visualization
# Story: Fountain of Youth?
# Dateset: Merged Data Frame (Florida Census 2010 + IlludiumPhosdex2018)
# By: Scott Cohen
# 
# Goal:  
# Learning Objective: 
# ------------------------------------------------------------------

#Histogram - Visualize 1 continuous variable
hist(merged_df1a$Illudium_Phosdex)
hist(merged_df1a$Distance)

#Scatterplot - Visualize 2 continious variables
cor(merged_df1a$Distance, merged_df1a$Illudium_Phosdex)

merged_df1a_test <- merged_df1a
cor.test(merged_df1a_test$Distance, merged_df1a_test$Illudium_Phosdex)
corrupt <- rbinom(length(merged_df1a_test$Illudium_Phosdex),1,.5)
corrupt <- as.logical(corrupt)
corrupt
noise <- rnorm(sum(corrupt),10,3)
noise
merged_df1a_test$Illudium_Phosdex[corrupt] <- merged_df1a_test$Illudium_Phosdex[corrupt] + noise
plot(merged_df1a_test$Distance, merged_df1a_test$Illudium_Phosdex)
cor.test(merged_df1a_test$Distance, merged_df1a_test$Illudium_Phosdex)








