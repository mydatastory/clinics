library(NCStats) #Subset function
library(vegan) #Ordinations
library(car) #Scatterplot function
library(sciplot) #Bargraph.CI function
library(AICcmodavg) #Automated model selection


setwd("C:/Users/iausp/OneDrive - University of Florida/Aves del Bosque Montano/Analyses/Data Story")

all <- read.csv("all richness 20191203.csv") #Concepts 1 & 2: Species richness for full study 
sp <- read.csv("species matrix 20191203.csv") #Concept 1: Species occupancy matrix for full study
silvo <- read.csv("silvo richness 20191203.csv") #Concept 3: Species richness per point for silvopasture sites

######################################################
# CONCEPT 1: Biodiversity and Environmental Gradients
######################################################

# Richness

# Richness decreases with elevation for forest bird communities
forest <- Subset(all,habitat=="forest")
scatterplot(rich ~ elevation, data=forest, smooth=F)
mod.elev <- lm(rich~elevation,data=forest)
summary(mod.elev)

# Richness differs among habitat types
hab <- all
hab$habitat <- factor(hab$habitat,levels=c("forest","shrubs","fragment","tree","fence","pasture"))

boxplot(rich ~ habitat, data=hab)
bargraph.CI(habitat,rich,data=hab)

hab.mod <- aov(rich~habitat,data=all)
TukeyHSD(hab.mod)

#Community composition differs among habitats
sp1 <- as.matrix(sp[7:length(sp)])
sp.sites <- sp[c("site","habitat","ha","elevation")]
sp.sites$habitat <- as.character(sp.sites$habitat)
sp.sites$habitat[sp.sites$ha > 9.9] <- "large fragment"
#sp.sites$habitat[sp.sites$ha < 10 & sp.sites$ha > 0] <- "small fragment"

nmds <- metaMDS(sp1)
plot(nmds)
ordihull(nmds,sp.sites$elevation,label=T,lwd=2) #Show by elevation
ordihull(nmds,sp.sites$habitat,label=T,lwd=2) #Show by habitat type


########################################
# CONCEPT 2: Species Area Relationship
########################################

# Subset data into fragment habitats

frags <- Subset(all,habitat=="fragment")
frags$elevation <- as.character(frags$elevation)

# Plot richness v. fragment area

scatterplot(rich~ha+elevation,data=frags,smooth=F)

# Hard to see patterns, so put on log scale 

scatterplot(rich~ha+elevation,data=frags,smooth=F,log="x")

# Shrub/Forest habitat within a 300m buffer of each fragment

scatterplot(rich~matrix+elevation,data=frags,smooth=F)

# The pattern is not as consistent across landscapes as fragment area, but there are some patterns.

# Create model set to determine the best predictors of species richness within fragments

frag.mod <- list()

frag.mod[["null"]] <- lm(rich ~ 1, data=frags)
frag.mod[["elev"]] <- lm(rich ~ elevation, data=frags)
frag.mod[["ha"]] <- lm(rich ~ log(ha), data=frags)
frag.mod[["matrix"]] <- lm(rich ~ matrix, data=frags)
frag.mod[["ha+matrix"]] <- lm(rich ~ log(ha)+matrix, data=frags)
frag.mod[["ha+elev"]] <- lm(rich ~ log(ha)+elevation, data=frags)
frag.mod[["matrix+elev"]] <- lm(rich ~ matrix+elevation, data=frags)
frag.mod[["ha+matrix+elev"]] <- lm(rich ~ log(ha)+matrix+elevation, data=frags)

aictab(frag.mod)
summary(frag.mod[["ha+matrix+elev"]])

# The global model including fragment size and amount of landscape habitat is the 
# top model, indicating that richess within fragments increases as a function of 
# both fragment size and isolation.


######################################
# CONCEPT 3: Habitat associations
#########################################

# Subset into fencerow (remnant shrubs) and tree habitats

fnc <- Subset(silvo, habitat=="fence")
fnc$elevation <- as.character(fnc$elevation)
tre <- Subset(silvo, habitat=="tree")
tre$elevation <- as.character(tre$elevation)

# Plot the data: 100m and 50m are best for shrubs and trees, respectively
scatterplot(rich ~ shrubs100+elevation, data=fnc, smooth=F)
scatterplot(rich ~ trees50+elevation, data=tre, smooth=F)

# Both graphs show a positive correlation between richness and amount of 
# shrubs or trees, although the pattern for shrubs is not consistent among elevations.

# Build model set for each habitat

# Fencerows
shr.mod <- list()

shr.mod[["null"]] <- lm(rich ~ 1, data=fnc)
shr.mod[["elev"]] <- lm(rich ~ elevation, data=fnc)
shr.mod[["shrub"]] <- lm(rich ~ shrubs100, data=fnc)
shr.mod[["elev+shrub"]] <- lm(rich ~ elevation+shrubs100, data=fnc)

aictab(shr.mod)
summary(shr.mod[["elev+shrub"]])

# Pasture Trees
tre.mod <- list()

tre.mod[["null"]] <- lm(rich ~ 1, data=tre)
tre.mod[["elev"]] <- lm(rich ~ elevation, data=tre)
tre.mod[["trees"]] <- lm(rich ~ trees50, data=tre)
tre.mod[["elev+trees"]] <- lm(rich ~ elevation+trees50, data=tre)

aictab(tre.mod)
summary(tre.mod[["elev+trees"]])

# Richness increases with the amount of residual shrub cover (eg., fencerows) and
# number of residual pasture trees. 


