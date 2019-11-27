## Data in Steinbeck's Cannery Row

#### Prep Code

import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression

os.chdir("C:/Users/drewc/Documents/GitHub/stories")

temp = pd.read_csv("data/scripps_temps_stage.csv")
temp.info()

ueber = pd.read_csv("data/ueber_landings_stage.csv")
ueber.info()

noaa = pd.read_csv("data/noaa_master_stage.csv")
noaa.info()

### NOAA State Fishing Data

#### Group NOAA data By Year, State, and Species. Drop Columns

gnoaa = noaa.groupby(["Year", "State", "Species"], as_index = False).sum()
dnoaa = gnoaa.drop(["Dollars", "Pounds"], axis=1)

#### Filter Dataset for Sardines in California

snoaa = dnoaa[dnoaa.Species == "SARDINE, PACIFIC"]
ca = snoaa[snoaa.State == "California"]

#### Create Plot with Labels, Title and Legend

xca = ca["Year"]
yca = ca["Tons"]
plt.plot(xca, yca, 'b--')
plt.ylabel("Tons")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")
plt.show()

#### Drop year 1951 as Outlier and Replot

ca = ca[ca.Year > 1951] 

xca = ca["Year"]
yca = ca["Tons"]
plt.plot(xca, yca, 'b--')
plt.ylabel("Tons")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")
plt.show()

#### Create filtered plot for after 1985 

ca85 = ca[ca.Year > 1985]
x85 = ca85["Year"]
y85 = ca85["Tons"]
plt.plot(x85, y85, 'b--')
plt.ylabel("Tons")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")

### Water Temperature Data from La Jolla Pier

#### Group Temperature Data by Day, Month, and Year average

gtemp = temp.groupby(["Year", "Month", "Day"]).mean()
gsurf = gtemp.groupby("Year")["Surf"].mean() 
gbott = gtemp.groupby("Year")["Bottom"].mean() 

#### Convert Series to Frame, Reset Index, and Combine back together

dsurf = gsurf.to_frame()
dbott = gbott.to_frame()

isurf = dsurf.reset_index(level=["Year"])
ibott = dbott.reset_index(level=["Year"])

ibott["Surf"] = isurf["Surf"]
tm = ibott

#### Create Plot with Labels, Title and Legend

xtm = tm["Year"]
ytms = tm["Surf"]
plt.plot(xtm, ytms, 'y--')
plt.ylabel("Temperature")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Surf Temperature at La Jolla Pier")

ytmb = tm["Bottom"]
plt.plot(xtm, ytmb, 'r--')
plt.ylabel("Temperature")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Bottom Temperature at La Jolla Pier")

#### Plot All Data Together

fig, ax1 = plt.subplots()

xca = ca["Year"]
yca = ca["Tons"]
ax1.plot(xca, yca, color = "blue")
ax1.set_ylabel("Tons")
ax1.set_xlabel("Fishing Year")
plt.legend()

ax2 = ax1.twinx()

tm51 = tm[tm.Year > 1951] 
xtm51 = tm51["Year"]
ytms51 = tm51["Surf"]
ax2.plot(xtm51, ytms51, "orange")
ax2.set_ylabel("Temperature C")

ytmb51 = tm51["Bottom"]
plt.plot(xtm51, ytmb51, "red")

plt.legend()
fig.suptitle("Sardines Harvested and Water Temperature in California", y = 0.95, fontsize = 12)

### Monterrey Fishing Data Before 1970

#### Plot Monterrey Data

xu = ueber["Year"]
yu = ueber["Tons"]
plt.plot(xu, yu, 'g--')
plt.ylabel("Short Tons")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in Monterrey")

#### Combine with Older Temperature Data before 1963

xu = ueber["Year"]
yu = ueber["Tons"]
plt.plot(xu, yu, 'g--')
plt.ylabel("Short Tons")
plt.xlabel("Fishing Year")
plt.legend()

ax2 = ax1.twinx()

tm65 = tm[tm.Year < 1965]
xta = tm65["Year"]
ysa = tm65["Surf"]
ax2.plot(xta, ysa, "orange")
ax2.set_ylabel("Temperature C")

yba = tm65["Bottom"]
ax2.plot(xta, yba, "red")
ax2.legend()

fig.suptitle("Sardines Harvested in Monterrey and Water Temperature at La Jolla Pier", y = 0.95, fontsize = 12)
fig.savefig("fig/fish_plot_uebertemp.jpeg")























## Temperature Data from La Jolla Pier

#### Group Temperature Data by day, month, and year average

na = temp.dropna()

group = na.groupby(["Year", "Month", "Day"]).mean()
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

xu = ueber["Year"]
yu = ueber["Tons"]
plt.plot(xu, yu, 'g--')
plt.ylabel("Short Tons")
plt.xlabel("Fishing Year")
plt.legend()

ax2 = ax1.twinx()

tm65 = tm[tm.Year < 1965]
xta = tm65["Year"]
ysa = tm65["Surf"]
ax2.plot(xta, ysa, "orange")
ax2.set_ylabel("Temperature C")

yba = tm65["Bottom"]
ax2.plot(xta, yba, "red")
ax2.legend()

fig.suptitle("Sardines Harvested in Monterrey and Water Temperature at La Jolla Pier", y = 0.95, fontsize = 12)
fig.savefig("fig/fish_plot_uebertemp.jpeg")




### Post Collapse in California

#### Plot All Data Together between 1952 and 1958

fig, ax1 = plt.subplots()

ca2 = ca[ca.Year > 1952]
ca28 = ca2[ca2.Year < 1958]

tm2 = tm[tm.Year > 1952]
tm28 = tm2[tm2.Year < 1958]

x28 = ca28["Year"]
y28 = ca28["Pounds"]
ax1.plot(x28, y28, color = "blue")
ax1.set_ylabel("Pounds (Hundred Millions)")
ax1.set_xlabel("Fishing Year")

ax2 = ax1.twinx()

xt28 = tm28["Year"]
ys28 = tm28["Surf"]
ax2.plot(xt28, ys28, "orange")
ax2.set_ylabel("Temperature C")

yb28 = tm28["Bottom"]
plt.plot(xt28, yb28, "red")

plt.legend()
fig.suptitle("Sardines Harvested and Water Temperature in California", y = 0.95, fontsize = 12)

model = LinearRegression()

ca6 = ca[ca.Year < 1958]
tm6 = tm[tm.Year < 1958]

ca5 = ca6[ca6.Year > 1952]
tm5 = tm6[tm6.Year > 1952]

x5 = np.array(tm5["Surf"]).reshape((-1, 1))
y5 = np.array(ca5["Pounds"]).reshape((-1, 1))

model.fit(x5, y5)
model.score(x5, y5)

## Post Recovery in California

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
r = model.score(xsr, ysr)
print("Rsq = ", r)






#### Plot Data between 1925 and 1945

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










## NOAA State Fishing Data

#### Group NOAA data By Year, State, and Species

group = noaa.groupby(["Year", "State", "Species"], as_index = False).sum()
group.info()

#### Drop Unwanted Columns

ready = group.drop(["Dollars", "Pounds"], axis=1)
ready.info()

#### Filter Dataset for Sardines in California

sard = ready[ready.Species == "SARDINE, PACIFIC"]
ca = sard[sard.State == 'California']

#### Define Varriables and Create Plot with Labels, Title and Legend

xc = ca["Year"]
yp = ca["Tons"]
plt.plot(xc, yp, 'b--')
plt.ylabel("Tons")
plt.xlabel("Fishing Year")
plt.legend()
plt.title("Sardines Harvested in California")
plt.show

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
r = model.score(xsr, ysr)
print("Rsq = ", r)
