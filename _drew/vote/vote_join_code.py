#### Prep Code

import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression

os.chdir("C:/Users/drewc/Documents/GitHub/stories")

sen = pd.read_csv("data/senate_state_stage.csv")
sen.info()

pres = pd.read_csv("data/president_state_stage.csv")
pres.info()

acs = pd.read_csv("data/acs_rf_stage.csv")
acs.info()

#### Stack Dataframes

votes = pd.concat([pres, sen])

#### Group data By Columns

voteg = votes.groupby(["Year", "State", "Party"], as_index = False).sum()

#### Pivot from Long to Wide Format

votew = voteg.pivot_table(index = ["Year", "State"], columns = "Party", values = "Votes")

#### Reset Index

votei = votew.reset_index(level = ["Year", "State"])

#### Add a new column based on difference

votei["D"] = votei["democrat"] - votei["republican"]
votei["R"] = votei["republican"] - votei["democrat"] 
vote = votei

#### Group by Columns for Yearly National Total

voteus = vote.groupby(["Year"], as_index = False).sum()

#### Plot National Differences

plt.plot(voteus.Year, voteus.D, color = "b")
plt.plot(voteus.Year, voteus.R, color = "r")
plt.ylabel("Vote Differential")
plt.xlabel("Election Year")
plt.legend()
plt.title("Vote Differential for Senate and President")

#### Plot National Totals

plt.plot(voteus.Year, voteus.republican, color = "r")
plt.ylabel("Votes")
plt.xlabel("Election Year")
plt.legend()
plt.title("U.S. Votes for Senate and President")

plt.plot(voteus.Year, voteus.democrat, color = "b")
plt.ylabel("Votes")
plt.xlabel("Election Year")
plt.legend()
plt.title("U.S. Votes for Senate and President")

#### Isolate for Swing States

fl = vote[vote.State == "Florida"]
oh = vote[vote.State == "Ohio"]
pa = vote[vote.State == "Pennsylvania"]
co = vote[vote.State == "Colorado"]

#### Plot Trends over Years

plt.plot(co.Year, co.D, color = "b")
plt.plot(co.Year, co.R, color = "r")
plt.ylabel("Vote Differential")
plt.xlabel("Election Year")
plt.legend()
plt.title("Colorado Vote Differential for Senate and President")

plt.plot(oh.Year, oh.D, color = "b")
plt.plot(oh.Year, oh.R, color = "r")
plt.ylabel("Vote Differential")
plt.xlabel("Election Year")
plt.legend()
plt.title("Ohio Vote Differential for Senate and President")

plt.plot(pa.Year, pa.D, color = "b")
plt.plot(pa.Year, pa.R, color = "r")
plt.ylabel("Vote Differential")
plt.xlabel("Election Year")
plt.legend()
plt.title("Pennsylvania Vote Differential for Senate and President")

plt.plot(fl.Year, fl.D, color = "b")
plt.plot(fl.Year, fl.R, color = "r")
plt.ylabel("Vote Differential")
plt.xlabel("Election Year")
plt.legend()
plt.title("Florida Vote Differential for Senate and President")

#### Plot Totals for Florida
plt.plot(fl.Year, fl.democrat, color = "b")
plt.ylabel("Votes")
plt.xlabel("Election Year")
plt.legend()
plt.title("Florida Votes for Senate and President")

plt.plot(fl.Year, fl.republican, color = "r")
plt.ylabel("Votes")
plt.xlabel("Election Year")
plt.legend()
plt.title("Florida Votes for Senate and President")

#### Subset for 2016 Data

trump = vote[vote.Year == 2016]

trump.to_csv("data/trump_data_stage.csv")

#### Join with Social Data

pd.merge(trump, acs, on = "State")

#### Plot Social Variables and R Vote Diff

fig, ax1 = plt.subplots()
plt.xticks(rotation = 90)

ax1.plot(trump.State, trump.R, color = "r")
ax1.set_ylabel("Vote Differential")
ax1.set_xlabel("State")
plt.legend()

ax2 = ax1.twinx()

ax2.plot(acs.State, acs.Moved, color = "g")
ax2.plot(acs.State, acs.Chinese, color = "yellow")
ax2.plot(acs.State, acs.Alone, color = "orange")
ax2.plot(acs.State, acs.Male, color = "pink")
ax2.plot(acs.State, acs.Foreign, color = "grey")
ax2.set_ylabel("Social")

plt.legend()
fig.suptitle("Vote Differential in 2016 and Social Variables", y = 0.95, fontsize = 12)

#### Plot Social Variables and D Vote Diff

fig, ax1 = plt.subplots()
plt.xticks(rotation = 90, fontsize = 8)

ax1.plot(trump.State, trump.D, color = "b")
ax1.set_ylabel("Vote Differential")
ax1.set_xlabel("State")
plt.legend()

ax2 = ax1.twinx()

ax2.plot(acs.State, acs.Moved, color = "g")
ax2.plot(acs.State, acs.Chinese, color = "yellow")
ax2.plot(acs.State, acs.Alone, color = "orange")
ax2.plot(acs.State, acs.Male, color = "pink")
ax2.plot(acs.State, acs.Foreign, color = "grey")
ax2.set_ylabel("Social")

plt.legend()
fig.suptitle("Vote Differential in 2016 and Social Variables", y = 0.95, fontsize = 12)

#### Perform Linear Regression on Foreign Born and R Differential by State

model = LinearRegression(fit_intercept = False)

x = np.array(acs["Chinese"]).reshape((-1, 1))
y = np.array(trump["D"]).reshape((-1, 1))

c = model.fit(x, y)
r = model.score(x, y)
print("Rsq = ", r)
print("Slope = ", c.coef_)