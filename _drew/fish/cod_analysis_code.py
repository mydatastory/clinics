# -*- coding: utf-8 -*-
"""
Created on Thu May 16 12:38:42 2019

@author: danielmaxwell
"""

# ----------------------------------------------------------------------------
# Atlantic Cod Analysis
# ----------------------------------------------------------------------------

# Setup environment with appropriate libraries.

import pandas as pd
import matplotlib.pyplot as plt

# Clean and stage the date.  The .csv file was downloaded from the NOAA website
# @ https://foss.nmfs.noaa.gov.  The selection criteria was 'Cod, Atlantic' for
# seven New England states, from 1988 to 2017.  Using Excel, the original file
# was then modified as follows: a) the Conf column was removed, b) all of the 
# column (variable) names were set to lower-case, and c) the pounds and dollars
# columns were formatted as numbers.  The raw data was formatted as currency, 
# using commas as separators.  This last step is mandatory.  Otherwise, the
# load_csv function will import these columns as strings rather than numbers.
# The code below adds a new tons column to the dataframe and then saves it as
# a .csv file.  This, then, becomes our new base dataset, the one we work with
# from this point forward.  N.B. This only needs to be done once!

base_df = pd.read_csv('c:/informatics/cod_landings_raw.csv')

base_df['tons'] = base_df['pounds'] / 2000

base_df.to_csv('c:/informatics/cod_landings.csv', index = False)

# Pivot the data set from long to wide format to view tons caught for each  
# state by year.  Compare numbers from late 1980's to present.  The grouping
# and summing operation is necessary because the NOAA supplied data set often
# has multiple observations for a given state in a given year.  The pounds and
# dollars columns are removed as they are not needed.

base_df = pd.read_csv('c:/informatics/cod_landings.csv')
base_df = base_df.drop(['pounds','dollars'], axis = 1)

pbase_df = base_df.groupby(['year','state'], as_index = False).sum()

pivot_df = pbase_df.pivot(index = 'state', columns = 'year', values = 'tons')
pivot_df.head(n = 7)

# Viewing data in a table gives us an initial sense of catch sizes over time.
# An inspection of the numbers suggests that there have been some dramatic
# declines in catches from the late 1980's.  Let's plot the data for one state
# (Massachussetts) to get a sense of what's happening. 
cod_df = base_df.groupby(['year','state','species'], as_index = False)['tons'].sum()

# Assign column names and set state as the index.
cod_df.columns = ['year','state','species','tons']
cod_df = cod_df.set_index('state')

# Subset the MA data.
ma = cod_df.loc['Massachusetts']

# Generate the MA plot.
plt.plot(ma.year, ma.tons)
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
plt.plot(ma.year, ma.tons)
plt.plot(me.year, me.tons)
plt.plot(ct.year, ct.tons)
plt.plot(ri.year, ri.tons)
plt.plot(nh.year, nh.tons)
plt.plot(nj.year, nj.tons)
plt.plot(md.year, md.tons)
plt.title('Atlantic Cod (Landings)')
plt.ylabel('Tons')
plt.xlabel('Year')
plt.legend(['MA','ME','CT','RI','NH','NJ','MD'])
