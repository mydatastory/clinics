# -*- coding: utf-8 -*-
"""
Created on Thu May 16 12:38:42 2019

@author: danielmaxwell
"""

import pandas as pd
import matplotlib.pyplot as plt

base_df = pd.read_csv('c:/informatics/landings.csv')

tmp_df = base_df.groupby(['year','state','species'], as_index = False)['pounds'].sum()

tmp_df.columns = ['year','state','species','sum_pounds']


