# -------------------------------------------------------------------------------------------
# Environment setup and load the two datasets.
# -------------------------------------------------------------------------------------------

temps_df    <- read.csv('scripps_ocean_avg_temps.csv', header = TRUE, stringsAsFactors = FALSE)
landings_df <- read.csv('sardine_landings_ueber.csv', header = TRUE, stringsAsFactors = FALSE)

# -------------------------------------------------------------------------------------------
# Join the two datasets on year and retain only those years where the catch was greater than 
# 500 tons.  When the catch was less than 500 tons, the fishery was effectively shutdown.
# -------------------------------------------------------------------------------------------

analysis_df <- merge(temps_df, landings_df, by = 'year')
analysis_df <- subset(analysis_df, monterey_tons > 500)

# -------------------------------------------------------------------------------------------
# Create a simple linear model with landings as the response variable surface temperature as
# the predictor variable.
# -------------------------------------------------------------------------------------------

fit <- lm(analysis_df$monterey_tons ~ analysis_df$surf_temp_c)

# Create a scatterplot of the data and overlay it with the regression line.

plot(x = analysis_df$surf_temp_c, y = analysis_df$monterey_tons,
     xlab = 'Surface Temp (Celsius)',
     ylab = 'Tons')

abline(fit, col = 'red')

# Calculate the correlation (Pearson's r) between landings and surface temperature.

cor(analysis_df$monterey_tons, analysis_df$surf_temp_c)
