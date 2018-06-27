# The arsenic data set contains data about arsenic levels in drinking
# water and toenails in New Hampshire.  The values for the categorical
# variables usedrink and usecook are A, B, C, D, and E.  As such, they
# represent an approximate percentage of well water used for drinking 
# and cooking.
# 
#         A: < 1/4, B: ~ 1/4, C: ~ 1/2, D: ~ 3/4, E: > 3/4

# Read the data file and then view its contents.

arsenic <- read.csv (file = "c:/informatics/arsenic.txt", header = TRUE, sep = "\t", as.is = TRUE)
View (arsenic)

# R supports for, while, and repeat loops.  The for loop simply executes 
# a block of code a set number of times, initializing an idx and then incrementing 
# it each iteration of the loop.  This is probably the most popular loop in R.

for(idx in 1:nrow(arsenic)){
  arsenic$usedrinkpct[idx] <- "NA"       # Assign a default to the variable.
  
  if (arsenic$usedrink[idx] == "A") {arsenic$usedrinkpct[idx] <- "< 1/4"} 
  if (arsenic$usedrink[idx] == "B") {arsenic$usedrinkpct[idx] <- "~ 1/4"}
  if (arsenic$usedrink[idx] == "C") {arsenic$usedrinkpct[idx] <- "~ 1/2"}
  if (arsenic$usedrink[idx] == "D") {arsenic$usedrinkpct[idx] <- "~ 3/4"}
  if (arsenic$usedrink[idx] == "E") {arsenic$usedrinkpct[idx] <- "> 3/4"}
}

# The while loop checks that a logical condition is true before entering the
# loop.  In the example below, we would not even enter the while loop if the 
# idx variable was greater than the number of rows (nrow) in the arsenic data 
# frame. The while condition is checked at each iteration of the loop.

idx <- 1

while (idx <= nrow(arsenic)) {
  arsenic$usedrinkpct[idx] <- "NA"       # Assign a default to the variable.
  
  if (arsenic$usedrink[idx] == "A") {arsenic$usedrinkpct[idx] <- "< 1/4"} 
  if (arsenic$usedrink[idx] == "B") {arsenic$usedrinkpct[idx] <- "~ 1/4"}
  # ... the other if statements.
  
  idx <- idx + 1
}

# The repeat loop, unlike the previous two examples, does not have a logical
# check at the beginning of its execution.  That is, it immediate begins to
# loop through and execute a block of code until a break statement is 
# encountered.  Absent such a statement, the repeat loop continues forever, 
# or until someone manually forces it to stop.  Thus one MUST provide a way
# to break out of the loop at some point.

idx <- 1

repeat {
  arsenic$usedrinkpct[idx] <- "NA"       # Assign a default to the variable.
  
  if (arsenic$usedrink[idx] == "A") {arsenic$usedrinkpct[idx] <- "< 1/4"} 
  if (arsenic$usedrink[idx] == "B") {arsenic$usedrinkpct[idx] <- "~ 1/4"}
  # ... the other if statements.
                                          
  if (idx >= nrow(arsenic)) {              # Break out of loop at last row.        
    break
  }

  idx <- idx + 1
}