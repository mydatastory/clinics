#### Prep Code: import libraries, set wd, import data

import os
import pandas as pd
import numpy as np
import matplotlib as plt
import geopandas as gp

os.chdir("C:/Users/drewc/Documents")

chic = pd.read_csv("_data/crime_chi_stage.csv")
chic.info()

black = pd.read_csv("_data/crime_hood_black_stage.csv")
black.info()

#### Subset By Date Range

chi = chic[(chic["Date"] > "1/1/02 0:00") & (chic["Date"] < "12/31/02 23:59")]
chi.info()

#### Print Unique Values in Column

print(chic["CrimePrimary"].unique())

#### Subset Data by Column Values or String Selection

crim = chi[(chi.CrimePrimary == "HOMICIDE")]
crim.info()

crim = chi[chi["CrimeDescription"].str.contains("CANNABIS") & (chi.Arrest == True)]
crim.info()

#### Get Map of Chicago in Folium

import folium as fol

chimap = fol.Map(location = [41.644668, -87.540093], zoom_start = 11)

#### Import Json Shape File with Json in Folium

import json as js

js = json.load(open("crime/crime_neighborhoods.geojson"))

shape = gp.read_file("crime/Neighborhoods_2012/Neighborhoods_2012b.shp")
shape.head()

hoods = fol.features.GeoJson(js)
chim.add_child(hoods)

#### GeoJoin with Black Neighborhood data

shape["Neighborhood"] = shape["pri_neigh"]
black["Neighborhood"] = black["PRI_NEIGH"]

merge = pd.merge(shape, black, on = "Neighborhood", how = "inner")
merge.head()

sub = merge[(merge.Black == True)]
sub.info()

#### Add Shapefile to Map in Folium with json

hoods = folium.features.GeoJson(sub)

chimap.add_child(hoods)
chimap.save("_fig/crime_chi_map.html")

#### Create Heat Map in Folium

from folium.plugins import HeatMap

heat = [[row["Lat"], row["Lon"]] for index, row in crim.iterrows()]
heatmp = HeatMap(heat)

chimap.add_child(heatmp)
chimap.save("_fig/crime_chi_map.html")

#### Create Choropleth Map in Folium

chimap.choropleth(geo_data = "crime/crime_neighborhoods.geojson")
chimap.save("_fig/crime_chi_map.html")

