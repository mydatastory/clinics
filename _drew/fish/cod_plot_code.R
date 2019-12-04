
# ----------------------------------------------------------------------------------------
# Environment setup and load data into the base dataframe.
# ----------------------------------------------------------------------------------------

library(dplyr)

base_df <- read.csv('landings.csv', stringsAsFactors = FALSE)

# ----------------------------------------------------------------------------------------
# Group the data and then sum pounds for each.  The resulting object, in this case, is a 
# tibble.  Tidyverse uses this older datatype which was the original dataframe.  See 
# Grolemund and Wickham's (R for Data Science), chapter 10, for more tibble information. Or 
# view it here: https://r4ds.had.co.nz/tibbles.html
#
# This grouping and summing operation was necessary because the NOAA supplied data set had
# multiple rows for each state in 1988.
# ----------------------------------------------------------------------------------------

tmp_df <- base_df %>%
  group_by(year, state, species) %>%
  summarise(sum(pounds))

catch_df <- as.data.frame(tmp_df)                      # Convert tibble to dataframe.

colnames(catch_df)[colnames(catch_df) == 'sum(pounds)'] <- 'sum_pounds'  

mass_df <- filter(catch_df, state == 'Massachusetts')  # Get MA data.

mass_df$sum_tons <- mass_df$sum_pounds / 2000          # Add tons column.

plot(mass_df$year, mass_df$sum_tons,                   # Plot the MA COD catch.
     type = 'l',
     col  = 'blue',
     main = 'Atlantic Code (MA Landings)',
     ylab = 'Tons',
     xlab = 'Year',
     ylim = c(0, 35000),
     xlim = c(1985, 2017))







