# -*- coding: utf-8 -*-
"""
Created on Thu May 16 12:38:42 2019

@author: danielmaxwell
"""

# ----------------------------------------------------------------------------
# Sardine Analysis
# ----------------------------------------------------------------------------

# Setup environment with appropriate libraries.

import pandas as pd
import matplotlib.pyplot as plt

# Clean and stage the date.  The .xls file was downloaded from the Scripps 
# website.  Using Excel, the original file was then modified as follows: a) 
# all of the column (variable) names were set to lower-case, b) removed the
# time_pst, time_flag, surf_flag, and bot_flag fields, c) the meta-data at 
# the top of the file was deleted, and d) everything was saved as a .csv 
# file. The code below groups the data and calculates a mean for bottom and 
# surface temperatures for each year.  This, then, becomes a base dataset, to 
# be used for analysis. N.B. This only needs to be done once!

base_df = pd.read_csv('c:/informatics/scripps_ocean_temps.csv')

avg_df = base_df.groupby(["year"])["surf_temp_c","bot_temp_c"].mean()
