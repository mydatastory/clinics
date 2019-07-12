## Sardines in California

#### Prep Code

import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression

os.chdir("C:/Users/drewc/Documents/stories")

noaa = pd.read_csv("data/fish_data_noaa.csv")
noaa.info()

temp = pd.read_csv("data/fish_data_newtemps.csv")
temp.info()

short = pd.read_csv("data/fish_data_shorttons.csv")
short.info()

old = pd.read_csv("data/fish_data_oldtemp.csv")
old.info()

#### Group NOAA data By Year, State, and Species

group = noaa.groupby(["Year", "State", "Species"], as_index = False).sum()
group.info()

#### Drop Unwanted Columns

ready = group.drop(["Dollars"], axis=1)
ready.info()

#### Filter Dataset for Sardines in California

sard = ready[ready.Species == "SARDINE, PACIFIC"]
ca = sard[sard.State == 'California']

#### Define Varriables and Create Plot with Labels, Title and Legend

xc = ca["Year"]
yp = ca["Pounds"]
plt.plot(xc, yp, 'b--')
plt.ylabel("Pounds")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")

#### Create filtered plot for after 1985 

ca85 = ca[ca.Year > 1985]
x85 = ca85["Year"]
y85 = ca85["Pounds"]
plt.plot(x85, y85, 'b--')
plt.ylabel("Pounds")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")

## Temperature Data from La Jolla Pier

#### Group Temperature Data by day, month, and year average

group = temp.groupby(["Year", "Month", "Day"]).mean()
group.info()

groups = group.groupby("Year")["Surf"].mean() 
groupb = group.groupby("Year")["Bottom"].mean() 

#### Convert Series to Frame, Reset Index, and Combine back together

dfs = groups.to_frame()
dfb = groupb.to_frame()

indexs = dfs.reset_index(level=["Year"])
indexb = dfb.reset_index(level=["Year"])

indexb["Surf"] = indexs["Surf"]
tm = indexb
tm.info()

#### Create Plot with Labels, Title and Legend

xt = tm["Year"]
ys = tm["Surf"]
plt.plot(xt, ys, 'y--')
plt.ylabel("Temperature")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Surf Temperature at La Jolla Pier")

yb = tm["Bottom"]
plt.plot(xt, yb, 'r--')
plt.ylabel("Temperature")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Bottom Temperature at La Jolla Pier")

##### Plot All Data Together

fig, ax1 = plt.subplots()

xc = ca["Year"]
yp = ca["Pounds"]
ax1.plot(xc, yp, color = "blue")
ax1.set_ylabel("Pounds (Hundred Millions)")
ax1.set_xlabel("Fishing Year")
ax1.legend()

ax2 = ax1.twinx()

xta = tm["Year"]
ysa = tm["Surf"]
ax2.plot(xta, ysa, "orange")
ax2.set_ylabel("Temperature C")

yba = tm["Bottom"]
ax2.plot(xta, yba, "red")
ax2.legend()

fig.suptitle("Sardines Harvested in California and Water Temperature at La Jolla Pier", y = 0.95, fontsize = 12)
fig.savefig("fig/fish_plot_combine.jpeg")

#### Plot All Data Together after 1985

fig, ax1 = plt.subplots()

ca85 = ca[ca.Year > 1985]
x85 = ca85["Year"]
y85 = ca85["Pounds"]
ax1.plot(x85, y85, color = "blue")
ax1.set_ylabel("Pounds (Hundred Millions)")
ax1.set_xlabel("Fishing Year")
ax1.legend()

ax2 = ax1.twinx()

tm85 = tm[tm.Year > 1985]
xt85 = tm85["Year"]
ys85 = tm85["Surf"]
ax2.plot(xt85, ys85, "orange")
ax2.set_ylabel("Temperature C")

yb85 = tm85["Bottom"]
ax2.plot(xt85, yb85, "red")
ax2.legend()

fig.suptitle("Sardines Harvested in California and Water Temperature at La Jolla Pier", y = 0.95, fontsize = 12)
fig.savefig("fig/fish_plot_combine85.jpeg")

#### Perform Linear Regression on after 1985 data

model = LinearRegression(fit_intercept = False)

xsr = np.array(tm85["Bottom"]).reshape((-1, 1))
ysr = np.array(ca85["Pounds"]).reshape((-1, 1))

model.fit(xsr, ysr)
model.score(xsr, ysr)

#### Perform Linear Regression on 1952 to 1958 data

model = LinearRegression()

ca6 = ca[ca.Year < 1958]
tm6 = tm[tm.Year < 1958]

ca5 = ca6[ca6.Year > 1952]
tm5 = tm6[tm6.Year > 1952]

x5 = np.array(tm5["Surf"]).reshape((-1, 1))
y5 = np.array(ca5["Pounds"]).reshape((-1, 1))

model.fit(x5, y5)
model.score(x5, y5)

## Monterrey Finshing Data Before 1970

#### Plot Monterrey Data

xsh = short["Year"]
ysh = short["Short"]
plt.plot(xsh, ysh, 'g--')
plt.ylabel("Short Tons")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in Monterrey")

#### Group Temperature Data by day, month, and year average

group = old.groupby(["Year", "Month", "Day"]).mean()
group.info()

groupo = group.groupby("Year")["Temperature"].mean() 

#### Convert Series to Frame, Reset Index

dfo = groupo.to_frame()
old = dfo.reset_index(level=["Year"])
old.info()

#### Plot Data

xo = old["Year"]
yo = old["Temperature"]
plt.plot(xo, yo, "r--")
plt.ylabel("Temperature C")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Temperature at La Jolla Pier")

#### Combine with Older Temperature Data between 1925 and 1945

sh5 = short[short.Year < 1946]
ol5 = old[old.Year < 1946]

fig, ax1  = plt.subplots()

xsh = sh5["Year"]
ysh = sh5["Short"]
ax1.plot(xsh, ysh, color = "green")
ax1.set_ylabel("Short Tons")
ax1.set_xlabel("Fishing Year")

ax1.legend()

ax2 = ax1.twinx()

xol = ol5["Year"]
yol = ol5["Temperature"]
ax2.plot(xol, yol, color = "red")
ax2.set_ylabel("Temperature C")

ax2.legend()

fig.suptitle("Sardines Harvested in California and Water Temperature at La Jolla Pier", y = 0.95, fontsize = 12)
fig.savefig("fig/fish_plot_combineold.jpeg")

#### Perform Linear Regression on Old Data

xold = np.array(ol5["Temperature"]).reshape((-1, 1))
yold = np.array(sh5["Short"]).reshape((-1, 1))

model.fit(x5, y5)
model.score(x5, y5)
