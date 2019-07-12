# -*- coding: utf-8 -*-
"""
Created on Thu May 16 12:38:42 2019

@author: danielmaxwell
"""

# ----------------------------------------------------------------------------
# Atlantic Cod Analysis
# ----------------------------------------------------------------------------

# Environment setup with appropriate libraries.
import pandas as pd
import matplotlib.pyplot as plt

# Clean and stage the date.  The .csv file was downloaded from the NOAA website
# @ https://foss.nmfs.noaa.gov.  The selection criteria was 'Cod, Atlantic' for
# seven New England states, from 1988 to 2017.  Using Excel, the original file
# was then modified as follows: a) the Conf column was removed, b) all of the 
# column (variable) names were set to lower-case, and c) the pounds and dollars
# columns were formatted as numbers.  The raw data is formatted as currency, 
# using commas as separators.  This last step is mandatory.  Otherwise, the
# load_csv function will import these columns as strings rather than numbers.

base_df = pd.read_csv('c:/informatics/cod_landings.csv')

# Pivot the data set from long to wide format to view pounds caught for each  
# state by year.  Compare numbers from late 1980's to present.  The grouping
# and summing operation is necessary because the NOAA supplied data set often
# has multiple observations for a given state in a given year.
pbase_df = base_df.groupby(['year','state'], as_index = False).sum()

pivot_df = pbase_df.pivot(index = 'state', columns = 'year', values = 'pounds')
pivot_df.head(n = 7)

# Viewing data in a table gives us an initial sense of catch sizes over time.
# An initial inspection of the numbers suggests that there have been some
# dramatic declines in catches from the late 1980's.  Let's plot the data for
# one state (Massachussetts) to get a sense of what's happening. 
cod_df = base_df.groupby(['year','state','species'], as_index = False)['pounds'].sum()

# Assign column names and set state as the index.
cod_df.columns = ['year','state','species','sum_pounds']
cod_df = cod_df.set_index('state')

# Subset the MA data.
ma = cod_df.loc['Massachusetts']

# Generate the MA plot.
plt.plot(ma.year, ma.sum_pounds / 2000)
plt.title('Atlantic Cod (MA Landings)')
plt.ylabel('Tons')
plt.xlabel('Year')

# Plot and compare the seven states in our data set.  Do catch numbers follow
# a similar pattern across the states?  Subset the data into dataframes, one
# for each state.
me = cod_df.loc['Maine']
ct = cod_df.loc['Connecticut']
ri = cod_df.loc['Rhode Island']
nh = cod_df.loc['New Hampshire']
nj = cod_df.loc['New Jersey']
md = cod_df.loc['Maryland']

# Generate the plot.  Do all of the states follow a similar pattern?
plt.plot(ma.year, ma.sum_pounds / 2000)
plt.plot(me.year, me.sum_pounds / 2000)
plt.plot(ct.year, ct.sum_pounds / 2000)
plt.plot(ri.year, ri.sum_pounds / 2000)
plt.plot(nh.year, nh.sum_pounds / 2000)
plt.plot(nj.year, nj.sum_pounds / 2000)
plt.plot(md.year, md.sum_pounds / 2000)
plt.title('Atlantic Cod (Landings)')
plt.ylabel('Tons')
plt.xlabel('Year')
plt.legend(['MA','ME','CT','RI','NH','NJ','MD'])



