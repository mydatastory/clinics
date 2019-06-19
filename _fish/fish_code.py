# -*- coding: utf-8 -*-
"""
Created on Thu May 16 12:38:42 2019

@author: danielmaxwell
"""

# Environment setup with appropriate libraries.
import pandas as pd
import matplotlib.pyplot as plt

# Load the data into a base data frame.
base_df = pd.read_csv('c:/informatics/cod_landings.csv')

# The grouping and summing operation below was necessary because the NOAA 
# supplied data set had multiple rows for each state in 1988.
cod_df = base_df.groupby(['year','state','species'], as_index = False)['pounds'].sum()

# Assign column names and set state as the index.
cod_df.columns = ['year','state','species','sum_pounds']
cod_df = catch_df.set_index('state')

# Subset the MA data.
mass_df = cod_df.loc['Massachusetts']

# Plot the MA Cod catch.
plt.plot(mass_df.year, mass_df.sum_pounds / 2000)
plt.title('Atlantic Cod (MA Landings)')
plt.ylabel('Tons')
plt.xlabel('Year')


