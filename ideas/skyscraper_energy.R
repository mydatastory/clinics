#
# This code demonstrates how to connect to a SQLite database -- in this case the
# don_blackbear_gradres.db -- execute a simple select statement, and then close the 
# connection.
#

library ("RSQLite")
library ("lubridate")

#
# The dbConnect function is peculiar in that it creates an empty database for
# you if it does not find one at the specified location.  This function, in other 
# words, never throws an error.  If you don't specify a full path for the dbname 
# parameter, dbConnect appends the working directory path.  Use getwd() to query
# this value.  You can also display the contents of con to see the database file
# that dbConnect either opened or created.  
#
# If you run a SELECT statement against a newly created database, dbGetQuery throws 
# an error, indicating that the table or view does not exist.  When this happens, 
# take a look at the location of the database file in the con object.  Best practice
# here is to specify the full pathname to the database file in the dbname argument
# so you don't have to deal with the unintended consequences of new but empty 
# database.
#

# Connect to the database.
con <- dbConnect(drv = SQLite(), dbname = "c:/informatics/skyscraper.db")

# Retrieve the daily_energy data and assign to local dataframe.
energy_df <- dbGetQuery(con, 'select * from daily_energy')

# --------------------------------------------------------------------------------
# Note: the lubridate time functions take into account the hh:mm:ss portion of a
# date field when making comparisons.  The command ymd_hm(time_stamp) > '2015-08-25',
# for example, selects all of the 08-25 dates when those dates contain the hours, 
# minutes, and seconds.  Even if a date is one second past midnight, it is greater
# than midnight 2015-08-25 on the dot.  SQL, on the other hand, interprets the >
# operator such that it selects dates from 08-26 forward, ignoring the time part 
# of the date.  Also, keep in mind that lubridate functions are extremely picky
# about date formats.  The ymd_hms() function expects date strings to be in this
# format: yyyy-mm-dd hh:mm:ss.  Anything other than that results in the Warning
# message: All formats failed to parse. No formats found.
# --------------------------------------------------------------------------------

tmp <- energy_df[ymd_hm(energy_df$time_stamp) >= '2015-08-26' & 
                 ymd_hm(energy_df$time_stamp) <  '2015-12-18', c('time_stamp')]

dbDisconnect(con)
