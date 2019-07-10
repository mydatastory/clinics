#### Prep Code

import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

os.chdir("C:/Users/drewc/Documents/stories")

noaa = pd.read_csv("data/fish_data_noaa.csv")
noaa.info()

temp = pd.read_csv("data/fish_data_oceantemps.csv")
temp.info()

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

x = ca["Year"]
y = ca["Pounds"]
plt.plot(x, y, 'b--')
plt.ylabel("Pounds")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")

#### Create filtered plot for after 1985 

ca85 = ca[ca.Year > 1985]
x85 = ca85["Year"]
y85 = ca85["Pounds"]
plt.plot(xa, ya, 'b--')
plt.ylabel("Pounds")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")

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

#### Define Varriables and Create Plot with Labels, Title and Legend

xt = tm["Year"]
ys = tm["Surf"]
plt.plot(xt, ys, 'y--')
plt.ylabel("Temperature")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Surf Temperature in Southern California")

yb = tm["Bottom"]
plt.plot(xt, yb, 'r--')
plt.ylabel("Temperature")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Bottom Temperature in Southern California")

##### Plot All Data Together

fig, ax1 = plt.subplots()

x = ca["Year"]
y = ca["Pounds"]
ax1.plot(x, y, color = "blue")
ax1.set_ylabel("Pounds")
ax1.set_xlabel("Fishing Year")

ax2 = ax1.twinx()

xt = tm["Year"]
ys = tm["Surf"]
ax2.plot(xt, ys, "orange")
ax2.set_ylabel("Temperature C")

yb = tm["Bottom"]
plt.plot(xt, yb, "red")

plt.legend()
fig.suptitle("Sardines Harvested and Water Temperature in California", y = 0.95, fontsize = 12)

#### Plot All Data Together after 1985

fig, ax1 = plt.subplots()

ca85 = ca[ca.Year > 1985]
x85 = ca85["Year"]
y85 = ca85["Pounds"]
ax1.plot(x85, y85, color = "blue")
ax1.set_ylabel("Pounds")
ax1.set_xlabel("Fishing Year")

ax2 = ax1.twinx()

tm85 = tm[tm.Year > 1985]
xt85 = tm85["Year"]
ys85 = tm85["Surf"]
ax2.plot(xt85, ys85, "orange")
ax2.set_ylabel("Temperature C")

yb85 = tm85["Bottom"]
plt.plot(xt85, yb85, "red")

plt.legend()
fig.suptitle("Sardines Harvested and Water Temperature in California", y = 0.95, fontsize = 12)

#### Perform Linear Regression on after 1985 data

model = LinearRegression(fit_intercept = False)

xsr = np.array(tm85["Bottom"]).reshape((-1, 1))
ysr = np.array(ca85["Pounds"]).reshape((-1, 1))

model.fit(xsr, ysr)
model.score(xsr, ysr)

#### Perform Linear Regression on 1952-1958 data

model = LinearRegression()

ca6 = ca[ca.Year < 1958]
tm6 = tm[tm.Year < 1958]

ca5 = ca6[ca6.Year > 1952]
tm5 = tm6[tm6.Year > 1952]

x5 = np.array(tm5["Surf"]).reshape((-1, 1))
y5 = np.array(ca5["Pounds"]).reshape((-1, 1))

model.fit(x5, y5)
model.score(x5, y5)

