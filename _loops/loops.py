# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
https://jakevdp.github.io/PythonDataScienceHandbook/04.01-simple-line-plots.html

"""

import pandas as pd
import matplotlib.pyplot as plt

plt.style.use('seaborn-whitegrid')

ghog_day = eval(input('Please enter the number of groundhog days: '))

for idx in range(1, ghog_day + 1):
    print("When will this day end? I've already lived it", idx, "times!")
    
df  = pd.read_csv('c:/informatics/gapminder.csv', index_col = 0)

# Set parameters for the base plot and its axes.
ax = plt.axes()
ax.set(xlabel = 'Year', 
       ylabel = 'Years', 
         xlim = (1950, 2010), 
        title = 'Life Expectancy')

df_gap = df.loc['United States']
plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = 'blue')

df_gap = df.loc['France']
plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = 'red')

df_gap = df.loc['Brazil']
plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = 'green')


countries = ['United States','France','Brazil']

# Set parameters for the base plot and its axes.
ax = plt.axes()
ax.set(xlabel = 'Year', 
       ylabel = 'Years', 
         xlim = (1950, 2010), 
        title = 'Life Expectancy')

df_gap = df.loc[countries[0]]
plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = 'blue')

df_gap = df.loc[countries[1]]
plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = 'red')

df_gap = df.loc[countries[2]]
plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = 'green')


countries   = ['United States','France','Brazil']
line_colors = ['blue','green','red']

# Set parameters for the base plot and its axes.
ax = plt.axes()
ax.set(xlabel = 'Year', 
       ylabel = 'Years', 
         xlim = (1950, 2010), 
        title = 'Life Expectancy')

for idx in range(len(countries)):
    df_gap = df.loc[countries[idx]]
    plt.plot(df_gap[['year']], df_gap[['lifeExp']], color = line_colors[idx])
# end for loop

idx = 1

ghog_day = eval(input('Please enter the number of groundhog days: '))

while idx < (ghog_day + 1):
     print("When will this day end? I've already lived it", idx, "times!")
     # Where is idx incremented?  without it, this is an infinite loop.
# end while loop

if __name__ == "__main__":
    
    df = pd.read_csv('c:/informatics/gapminder.csv')
    