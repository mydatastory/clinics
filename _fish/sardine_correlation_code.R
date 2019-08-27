library(dplyr)

# -------------------------------------------------------------------------------------------
# Environment setup and load the two datasets.
# -------------------------------------------------------------------------------------------

temps_df    <- read.csv('scripps_ocean_temps.csv', header = TRUE, stringsAsFactors = FALSE)
landings_df <- read.csv('sardine_landings_ueber.csv', header = TRUE, stringsAsFactors = FALSE)

# -------------------------------------------------------------------------------------------
# Because the onset of sardine spawning begins in February, create a subset of the temperature data from February to April.  This is the peak spawning season.  Then create a new data set of average temperatures for each year of the dataset. https://stackoverflow.com/questions/3480388/how-to-fit-a-smooth-curve-to-my-data-in-r  http://r-statistics.co/Loess-Regression-With-R.html
# -------------------------------------------------------------------------------------------

temps_df <- temps_df[,-5]
temps_df <- na.omit(temps_df)
temps_df <- subset(temps_df, month == 2 | month == 3 | month == 4)
temps_df <- subset(temps_df, year < 1968)

avg_temps_df <- temps_df %>%
                  group_by(year) %>%
                  summarize(mean(surf_temp_c))

colnames(avg_temps_df)[2] <- "avg_temp"

temp_model <- loess(avg_temp ~ year, data = avg_temps_df, span = .50)
temp_line  <- predict(temp_model)

plot(avg_temps_df$year, avg_temps_df$avg_temp,                  
     type = "l",
     col  = "blue",
     main = "",
     xlim = c(1915, 1970),
     xlab = "",
     ylab = '')

lines(temp_line, x = avg_temps_df$year, col = 'red')

landing_model <- loess(monterey_tons ~ year, data = landings_df, span = .50)
landing_line  <- predict(landing_model)

plot(landings_df$year, landings_df$monterey_tons,                  
     type = "l",
     col  = "blue",
     main = "",
     xlim = c(1915, 1970),
     xlab = '',
     ylab = '')

lines(landing_line, x = landings_df$year, col = 'red')

catch_df <- data.frame(landing_line)
temp_df  <- data.frame(temp_line)

catch_df$year <- 1917:1967
temp_df$year  <- 1917:1967

analysis_df <- merge(temp_df, catch_df, by = 'year')
analysis_df <- subset(analysis_df, landing_line > 500)
analysis_df <- subset(analysis_df, year < 1954)

plot(x = analysis_df$temp_line, y = analysis_df$landing_line,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

fit <- lm(analysis_df$landing_line ~ analysis_df$temp_line)

abline(fit, col = 'red')

cor(analysis_df$landing_line, analysis_df$temp_line)

# -------------------------------------------------------------------------------------------
# Join the two datasets on year and retain only those years where the catch was greater than 500 tons.  When the catch was less than 500 tons, the fishery was effectively shutdown.
# -------------------------------------------------------------------------------------------

analysis_df <- merge(temps_df, landings_df, by = 'year')
analysis_df <- subset(analysis_df, monterey_tons > 500)

# -------------------------------------------------------------------------------------------
# Create a simple linear model with landings as the response variable surface temperature as the predictor variable.
# -------------------------------------------------------------------------------------------

fit <- lm(analysis_df$monterey_tons ~ analysis_df$surf_temp_c)

# Create a scatterplot of the data and overlay it with the regression line.

plot(x = analysis_df$surf_temp_c, y = analysis_df$monterey_tons,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

abline(fit, col = 'red')

# Calculate the correlation (Pearson's r) between landings and surface temperature.

cor(analysis_df$monterey_tons, analysis_df$surf_temp_c)
