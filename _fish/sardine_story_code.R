# -------------------------------------------------------------------------------------------
# Sometimes the 'noise' in our raw data prevents us from seeing the relationship between
# two variables.  In this learning experience, we plot raw sardine catch and ocean temperature
# data and then create smoothing lines for both, before calculating a Pearson's r correlation
# between the two.  Smoothed data is preferable in this case because the raw data is noisy.
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

# -------------------------------------------------------------------------------------------
# Plot the raw temperature data and then create a temperature model (loess), generate predicted 
# values using that model, and then lay down a smoothing line on top of the plot.
# -------------------------------------------------------------------------------------------

plot(avg_temps_df$year, avg_temps_df$avg_temp,                  
     type = "l",
     col  = "blue",
     main = "",
     xlim = c(1915, 1970),
     xlab = "Year",
     ylab = 'Temperature (Celsius)')

temp_model <- loess(avg_temp ~ year, data = avg_temps_df, span = .50)
temp_line  <- predict(temp_model)

lines(temp_line, x = avg_temps_df$year, col = 'red')

# -------------------------------------------------------------------------------------------
# Plot the raw landings data and then create a landings model (loess), generate predicted 
# values using that model, and then lay down a smoothing line on top of the plot.
# -------------------------------------------------------------------------------------------

plot(landings_df$year, landings_df$monterey_tons,                  
     type = "l",
     col  = "blue",
     main = "",
     xlim = c(1915, 1970),
     xlab = 'Year',
     ylab = 'Landings (Tons)')

landing_model <- loess(monterey_tons ~ year, data = landings_df, span = .50)
landing_line  <- predict(landing_model)

lines(landing_line, x = landings_df$year, col = 'red')

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

analysis_df <- merge(avg_temps_df, landings_df, by = 'year')
analysis_df <- subset(analysis_df, monterey_tons > 500)
analysis_df <- subset(analysis_df, year < 1954)

plot(x = analysis_df$avg_temp, y = analysis_df$monterey_tons,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

# -------------------------------------------------------------------------------------------
# Generate a simple linear regression model, add the regression line to the plot and then
# calculate Pearson's r between the raw temperatures and the raw landings.
# -------------------------------------------------------------------------------------------

fit <- lm(analysis_df$monterey_tons ~ analysis_df$avg_temp)

abline(fit, col = 'red')

raw_cor <- cor(analysis_df$monterey_tons, analysis_df$avg_temp)

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

analysis_df <- merge(temp_df, landing_df, by = 'year')
analysis_df <- subset(analysis_df, landings > 500)
analysis_df <- subset(analysis_df, year < 1954)

plot(x = analysis_df$temps, y = analysis_df$landings,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

# -------------------------------------------------------------------------------------------
# Generate a simple linear regression model, add the regression line to the plot and then
# calculate Pearson's r between the smoothed temperatures and the smoothed landings.
# -------------------------------------------------------------------------------------------

fit <- lm(analysis_df$landings ~ analysis_df$temps)

abline(fit, col = 'red')

smooth_cor <- cor(analysis_df$landings, analysis_df$temps)

# -------------------------------------------------------------------------------------------
# And finally, let's compare the correlation between the raw and smoothed data.
# -------------------------------------------------------------------------------------------

raw_cor
smooth_cor



