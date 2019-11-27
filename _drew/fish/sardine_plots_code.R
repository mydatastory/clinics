## Sardines

#### Prep Code

library(dplyr)

setwd("C:/Users/drewc/Documents")

noaa = read.csv("stories/data/fish_data_noaa.csv")

temp = read.csv("stories/data/fish_data_oceantemps.csv")

#### Group NOAA data By Year, State, and Species

group <- noaa %>%
  group_by(Year, State, Species) %>%
  summarise(sum(Pounds))

#### Convert tibble to dataframe and Check/Fix Column names

ready <- as.data.frame(group) 
ready(head)
colnames(ready)[4] <- "Pounds"

#### Filter Dataset for Sardines in California

sard <- filter(ready, Species == "SARDINE, PACIFIC")
ca <- filter(sard, State == "California")

#### Define Varriables and Create Plot with Labels, Title and Legend

plot(ca$Year, ca$Pounds,                  
     type = "l",
     col  = "blue",
     main = "Sardines Harvested in California",
     xlab = "Pounds",
     ylab = 'Fishing Year',
     xlim = c(1950, 2017),
     ylim = c(0, 250000000))

#### Create filtered plot for after 1985 

plot(ca$Year, ca$Pounds,                  
     type = "l",
     col  = "blue",
     main = "Sardines Harvested in California",
     xlab = "Pounds",
     ylab = 'Fishing Year',
     xlim = c(1985, 2017),
     ylim = c(0, 250000000))

## Temperature

#### Group Temperature Data by day, month, and year average

temp = na.omit(temp)
groups <- temp %>%
  group_by(Year) %>% summarise(mean(Surf))
groupb <- temp %>%
  group_by(Year) %>% summarise(mean(Bottom))
  
#### Convert Series to Frame, Merge back together, Rename Columns

readyb = as.data.frame(groupb)
readys = as.data.frame(groups) 
merge= merge(readys, readyb, by = "Year")
colnames(merge) <- c("Year", "Surf", "Bottom")
tm = merge

#### Define Varriables and Create Plot with Labels, Title and Legend

plot(tm$Year, tm$Surf,                  
     type = "l",
     col  = "orange",
     main = "Water Temperature in California",
     xlab = "Fishing Year",
     ylab = "Temperature C",
     xlim = c(1950, 2017),
     ylim = c(15, 20))
lines(tm$Year, tm$Bottom,
     col  = "red")
par(new = True)
plot(ca$Year, ca$Pounds,                  
     type = "l",
     col  = "blue",
     xlab = "Pounds",
     ylab = 'Fishing Year',
     xlim = c(1950, 2017),
     ylim = c(0, 250000000))




