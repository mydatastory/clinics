# -------------------------------------------------------------------------------------------
# Sometimes the 'noise' in our raw data prevents us from seeing the relationship between
# two variables.  In this learning experience, we plot raw sardine catch and ocean temperature
# data and then create smoothing lines for both, before calculating a Pearson's r correlation
# between the two.  Smoothed data is preferable in this case because the raw data is noisy.
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Statistical questions of interest:
# 1. What is the relationship between the sardine catch and ocean temperature during peak spawning
# season?
# 2. How does different regression technqiues influence the prediction of sardine landings (total sardine catch)
# using ocean temperature data?
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Learning outcomes for this story:
# 1. Students will be able to create line graphs of the sardine catch and ocean temperature data. 
# 2. Students will be able to interpret the relationship between the two variables on the line
# graph. 
# 3. Students will be able to identify when to use smoothing techniques for interpretation and
# prediction of data modeling. 
# -------------------------------------------------------------------------------------------

library(dplyr)

# -------------------------------------------------------------------------------------------
# Environment setup and load the two datasets.  The first is ocean temperature readings from
# La Jolla, CA, the second is sardine landings (total catch) in tons.
# -------------------------------------------------------------------------------------------

temps_df    <- read.csv('scripps_ocean_temps.csv', header = TRUE, stringsAsFactors = FALSE)
landings_df <- read.csv('sardine_landings_ueber.csv', header = TRUE, stringsAsFactors = FALSE)

# -------------------------------------------------------------------------------------------
# Because the onset of sardine spawning begins in February, create a subset of the temperature 
# data from February to April.  This is the peak spawning season.  Then create a new data set 
# of average temperatures for each year of the dataset. 
# 
# References for creating smoothing lines in R.
# https://stackoverflow.com/questions/3480388/how-to-fit-a-smooth-curve-to-my-data-in-r  
# http://r-statistics.co/Loess-Regression-With-R.html
# -------------------------------------------------------------------------------------------

temps_df <- temps_df[,-5]
temps_df <- na.omit(temps_df)
temps_df <- subset(temps_df, month == 2 | month == 3 | month == 4)
temps_df <- subset(temps_df, year < 1968)

avg_temps_df <- temps_df %>%
                  group_by(year) %>%
                  summarize(mean(surf_temp_c))

colnames(avg_temps_df)[2] <- "avg_temp"

# Overview of this section of the learning experience (not to show students, may be too leading)
# -------------------------------------------------------------------------------------------
# Plot the raw temperature data and then create a temperature model (loess), generate predicted 
# values using that model, and then lay down a smoothing line on top of the plot.
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Plot the raw landings data and then create a landings model (loess), generate predicted 
# values using that model, and then lay down a smoothing line on top of the plot.
# -------------------------------------------------------------------------------------------

# I would break up this part of the experience and allow the students to first look at and interpret
# the line graphs from the raw data. Then, I would introduce the smoothing line technique as a way
# to see an overall trend in the temperature and sardine landing data. 
# I would also have the students both look at the line graphs of the raw temperature and sardine 
# landings data first to have them start thinking about the potential relationship between the 
# two variables.

# After data cleaning is complete, start the students here.
# -------------------------------------------------------------------------------------------
# Plot the raw temperature data
# -------------------------------------------------------------------------------------------

plot(avg_temps_df$year, avg_temps_df$avg_temp,                  
     type = "l",
     col  = "blue",
     main = "",
     xlim = c(1915, 1970),
     xlab = "Year",
     ylab = 'Temperature (Celsius)')

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# What do you observe from this line graph? Does the temperature of the ocean change over the
# years? If so, how? 
# Are you able to identify an overall trend from this line graph?
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Plot the raw sardine landings data
# -------------------------------------------------------------------------------------------

plot(landings_df$year, landings_df$monterey_tons,                  
     type = "l",
     col  = "blue",
     main = "",
     xlim = c(1915, 1970),
     xlab = 'Year',
     ylab = 'Landings (Tons)')

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# What do you observe from this line graph? Does the amount of sardine landings change over the
# years? If so, how? 
# Are you able to identify an overall trend from this line graph?
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# Looking at both line graphs of the raw temperature and sardine landings data, do you notice
# any relationship between the two variables? Take note of the x-axis which allows us to 
# compare these two graphs. 
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Is there a statistical technique that could be used to better see the trend in each of these variables?

# Let's try a smoothing technique called the loess line.
# To do this we need to create a temperature model (loess), generate predicted 
# values using that model, and then lay down a smoothing line on top of the plot.
# -------------------------------------------------------------------------------------------

temp_model <- loess(avg_temp ~ year, data = avg_temps_df, span = .50)
temp_line  <- predict(temp_model)

lines(temp_line, x = avg_temps_df$year, col = 'red')

# -------------------------------------------------------------------------------------------
# Try the same method for the sardine landings data
# -------------------------------------------------------------------------------------------

landing_model <- loess(monterey_tons ~ year, data = landings_df, span = .50)
landing_line  <- predict(landing_model)

lines(landing_line, x = landings_df$year, col = 'red')

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# What do you observe from each of these line graphs with the loess curve? Are you able to identify a better overall
# trend using the loess lines for the temperature and sardine landings variables? 
# Can you describe the relationship between the two variables better now with the loess lines?
# What do you notice between the two line graphs? How do they compare? How are they different?
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Now that we can better identify the trend of the temperature and sardine landings over the years,
# let's take a closer look at the relationship between these two variables. We know that sardines 
# need an ideal temperature in order to catch and grow their population. In order to better understand
# the change in sardine landings over the years, we will use the temperature data to predict the 
# amount of sardine landings. This type of technique is called linear regression. 
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Video explain linear regression
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# RAW TEMPERATURE AND LANDING REGRESSION & CORRELATION
#
# First compute a simple linear regression and Pearson's correlation on the raw data and
# then we'll do the same with the smoothed data and compare the two.
#
# Data Note:  landings_df and temps_df contain raw data.  
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Join the two datasets on year and retain only those years where the catch was greater than 
# 500 tons.  When the catch was less than 500 tons, the fishery was effectively shutdown. And
# then plot the data.
# -------------------------------------------------------------------------------------------

analysis_df_raw <- merge(avg_temps_df, landings_df, by = 'year')
analysis_df_raw <- subset(analysis_df_raw, monterey_tons > 500)
analysis_df_raw <- subset(analysis_df_raw, year < 1954)

plot(x = analysis_df_raw$avg_temp, y = analysis_df_raw$monterey_tons,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# What can you say visually about the relationship between the average surface temperatures and 
# the catch in tons? Is the relationship positive or negative? Strong or weak?
# Think about where you would place the linear regression line on the plot. 
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Generate a simple linear regression model, add the regression line to the plot and then
# calculate Pearson's r between the raw temperatures and the raw landings.
# -------------------------------------------------------------------------------------------

fit_raw <- lm(analysis_df_raw$monterey_tons ~ analysis_df_raw$avg_temp)

abline(fit_raw, col = 'red')

raw_cor <- cor(analysis_df_raw$monterey_tons, analysis_df_raw$avg_temp)

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# Does the correlation value align with your visual interpretation of the relationship between
# the surface temperature and the sardine catch? 
# How does the linear regression line compare to your regression line?
# Overall, what does Pearson's r and the simple linear regression model tells us about surface
# temperature as a predictor for the sardine catch?
# -------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------
# SMOOTHED TEMPERATURE AND LANDING REGRESSION & CORRELATION
#
# Now that we've conducted a simple linear regression and correlation with the raw data, let's
# do the same with the smoothed data from our loess model.  With the smoothing line vectors,
# create two new dataframes.  Add a year variable, populate it with values from 1917 to
# 1955, and then join both into an analysis dataframe.  Remove rows from analysis_df for years
# when the fishery was shut down.  Plot the new dataset.  
#
# Data Note:  landing_df and temp_df contain smoothed data.  
# -------------------------------------------------------------------------------------------

landing_df <- data.frame("landings" = landing_line)
temp_df    <- data.frame("temps" = temp_line)

landing_df$year <- 1917:1967
temp_df$year    <- 1917:1967

analysis_df_smooth <- merge(temp_df, landing_df, by = 'year')
analysis_df_smooth <- subset(analysis_df_smooth, landings > 500)
analysis_df_smooth <- subset(analysis_df_smooth, year < 1954)

plot(x = analysis_df_smooth$temps, y = analysis_df_smooth$landings,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# What can you say visually about the relationship between the smooth surface temperatures data and 
# the smooth catch data? Is the relationship positive or negative? Strong or weak?
# Think about where you would place the linear regression line on the plot.
# -------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------
# Generate a simple linear regression model, add the regression line to the plot and then
# calculate Pearson's r between the smoothed temperatures and the smoothed landings.
# -------------------------------------------------------------------------------------------

fit_smooth <- lm(analysis_df_smooth$landings ~ analysis_df_smooth$temps)

abline(fit_smooth, col = 'red')

smooth_cor <- cor(analysis_df$landings, analysis_df$temps)

# -------------------------------------------------------------------------------------------
# And finally, let's compare the correlation between the raw and smoothed data.
# -------------------------------------------------------------------------------------------

raw_cor
smooth_cor

# -------------------------------------------------------------------------------------------
# QUESTIONS:
# Does the correlation value for the smoothed data align with your visual interpretation of the 
# relationship between the smoothed surface temperature data and the smoothed sardine catch data? 
# How does the linear regression line of the smoothed data compare to estimated regression line?

# Overall, how does the linear regression line and the correlations compare between the smoothed
# and raw data? What does this tell us?
# -------------------------------------------------------------------------------------------




