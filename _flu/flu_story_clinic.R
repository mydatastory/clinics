# Read the Swiss flu file and plot.

sw_flu <-read.csv("swissFlu.csv", header = TRUE, stringsAsFactors = FALSE)

plot(sw_flu$age, sw_flu$totalDeaths)

plot(sw_flu$age, sw_flu$totalDeaths, 
     type = "l", 
     ylab = "Frequency",
     xlab = "Age",
     main = "Swiss Spanish Flu Deaths (1918)",
     col  = "blue",
     xlim = range(0:100))

# Read the Florida flu file and plot.

fl_flu <-read.csv("floridaFlu.csv", header = TRUE, stringsAsFactors = FALSE)

plot(fl_flu$age, fl_flu$totalDeaths, 
     type = "l", 
     ylab = "Frequency",
     xlab = "Age",
     main = "Florida Flu Deaths (1998)",
     col  = "red",
     ylim = range(0:300))

# Generate the frequency table for the data in floridaFlu.csv

for(i in 1:nrow(fl_flu)) {
  tmp <- rep(fl_flu$age[i], fl_flu$totalDeaths[i])
  
  if(i == 1) {
    fl_freq <- tmp    
  } 
  else {
    fl_freq <- c(fl_freq, tmp) 
  }
}

# Generate the frequency table for the data in swissFlu.csv

for(i in 1:nrow(sw_flu)) {
  tmp <- rep(sw_flu$age[i], sw_flu$totalDeaths[i])
  
  if(i == 1) {
    sw_freq <- tmp    
  } 
  else {
    sw_freq <- c(sw_freq, tmp) 
  }
}


