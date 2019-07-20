---
  title: "American Community Survey"
author: "Andrew Cistola"
date: "June 17, 2019"
output: html_document
---
 
library(plyr)
library(dplyr)
library(randomForest)
library(MASS)   
library(tibble)

setwd("C:/Users/drewc/Downloads")

Social <- read.csv("ACS_16_5YR_DP02_with_ann.csv")
Economic <- read.csv("ACS_16_5YR_DP03_with_ann.csv")
Housing <- read.csv("ACS_16_5YR_DP04_with_ann.csv")
Demographic <- read.csv("ACS_16_5YR_DP05_with_ann.csv")

se = inner_join(Social, Economic, by = "GEO.id")
seh = inner_join(se, Housing, by = "GEO.id")
acs = inner_join(seh, Demographic, by = "GEO.id")

write.csv(acs, "C:/Users/drewc/Documents/GitHub/stories/data/acs_data_raw.csv")

## Join Datasets

setwd("C:/Users/drewc/Documents/GitHub/stories")

a <- read.csv("data/acs_data_stage.csv")
b <- read.csv("data/trump_data_stage.csv")

join = inner_join(a, b, by = "State")

## Random Forest

rf = join

rf$Geo.Id <- NULL

rf = rf %>% mutate_if(is.factor, as.numeric)

ofD = randomForest(formula = D ~ ., data = rf, ntree = 1000, importance=TRUE)
ofR = randomForest(formula = R ~ ., data = rf, ntree = 1000, importance=TRUE)

rankD = importance(ofD)
rankR = importance(ofR)

write.csv(rankD, "data/vote_rf_D.csv")
write.csv(rankR, "data/vote_rf_R.csv")



