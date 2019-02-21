# -*- coding: utf-8 -*-
"""
Created on Thu Feb 21 13:14:17 2019

@author: danielmaxwell
"""

import csv

with open('c:/informatics/gnv_crime.tsv') as tsvfile:
    reader = csv.DictReader(tsvfile, dialect = 'excel-tab')
    
    for row in reader:
        print(row)

print(row['ID'])
print(row['State'])
