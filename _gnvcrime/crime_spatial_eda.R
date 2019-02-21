rm(list=ls(all=TRUE))
# devtools::install_github("dkahle/ggmap")
library('ggmap')

#get crimes data
setwd('U:\\maxwell\\crimes')
crime=read.csv('crime_edited1.csv',as.is=T)
ind=which(colnames(crime)%in%c('ï..ID','State'))
crime1=crime[crime$year>=2011 & !(crime$year%in%c(2015,2018)),-ind]

#get basemap for gainesville
latit=29+(39/60)+(7.19/3600)
longi=-(82+(19/60)+(29.97/3600))
gnv=get_stamenmap(bbox=c(left=-82.44,
                          bottom=29.61,
                          right=-82.3,
                          top=29.675),zoom=14)
ggmap(gnv)

#calculate density of crimes
plot(latit~longit,data=crime1,xlim=c(-82.44,-82.3),ylim=c(29.61,29.675))

#let's try using raw statistics instead of density
seq.lat=seq(from=29.61,to=29.675,length.out=100)
seq.lon=seq(from=-82.44,to=-82.3,length.out=100)
combo=expand.grid(lat=seq.lat,lon=seq.lon)
dif1=(seq.lat[2]-seq.lat[1])
combo$res=NA
for (i in 1:nrow(combo)){
  print(i)
  bottom=combo$lat[i]-dif1
  upper=combo$lat[i]+dif1
  left=combo$lon[i]-dif1
  right=combo$lon[i]+dif1
  cond=crime1$longit>left & crime1$longit<right & 
       crime1$latit>bottom & crime1$latit<upper
  tmp=crime1[cond,]
  combo$res[i]=nrow(tmp)
}

#plot results
range(combo$res)
combo$res1=combo$res/sum(combo$res)
ggmap(gnv)+
  geom_tile(data=combo,aes(x=lon,y=lat,alpha=res1),fill='red')+
  scale_alpha(range = c(0, 1))
#-----------------------------------------
#look at just (in summer and outside summer) DISORDERLY, DRIVING UNDER THE INFLUENCE, DAMAGE, DISTURBANCE
#greater spatial concentration in downtown during school year 
#less spatial concentration during summer
crime1$summer=ifelse(crime1$month%in%c(5,6,7),1,0)
cond=crime1$type%in%c('DISORDERLY','DRIVING UNDER THE INFLUENCE','DAMAGE','DISTURBANCE') &
     crime1$summer==1
crime2=crime1[cond,]
combo$disorder=NA
for (i in 1:nrow(combo)){
  print(i)
  bottom=combo$lat[i]-dif1
  upper=combo$lat[i]+dif1
  left=combo$lon[i]-dif1
  right=combo$lon[i]+dif1
  cond=crime2$longit>left & crime2$longit<right & 
    crime2$latit>bottom & crime2$latit<upper
  tmp=crime2[cond,]
  combo$disorder[i]=nrow(tmp)
}

#plot results
range(combo$disorder)
combo$disorder1=combo$disorder/sum(combo$disorder)
ggmap(gnv)+
  geom_tile(data=combo,aes(x=lon,y=lat,alpha=disorder1),fill='red')+
  scale_alpha(range = c(0, 1))
