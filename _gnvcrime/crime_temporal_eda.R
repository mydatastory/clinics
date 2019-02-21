rm(list=ls(all=TRUE))
setwd('U:\\maxwell\\crimes')
crime=read.csv('crime_edited1.csv',as.is=T)

unique(crime$City)
unique(crime$State)
table(crime$year)
table(crime$month)
table(crime$hour)
sort(table(crime$type))

ind=which(colnames(crime)%in%c('ï..ID','State'))
crime1=crime[crime$year>=2011,-ind]

#look at temporal trends: decreasing trend but looks weird!
crime1$time=crime1$year+((crime1$month-1)/12)
crime1$count=1
all1=aggregate(count~time,data=crime1,sum)
plot(count~time,data=all1,type='l')
ind=which(all1$count<500)
all1[ind,]
weird.times=all1$time[ind]

#look at hour effects: huge spike at noon!
cond=crime1$year%in%c(2015,2018)
crime2=crime1[!cond,]
tmp=aggregate(count~hour+month,data=crime2,sum)
plot(NA,xlim=c(0,24),ylim=c(0,max(tmp$count)),xlab='hour',ylab='Crimes')
for (i in 1:12){
  tmp1=tmp[tmp$month==i,]
  lines(count~hour,data=tmp1,col=i)
}
abline(v=c(8,12,17,20),col='grey')

#look at just DISORDERLY, DRIVING UNDER THE INFLUENCE, DAMAGE, DISTURBANCE: huge spike at 2 am as well as noon! 
cond=crime2$type%in%c('DISORDERLY','DRIVING UNDER THE INFLUENCE','DAMAGE','DISTURBANCE')
crime3=crime2[cond,]
tmp=aggregate(count~hour+month,data=crime3,sum)
plot(NA,xlim=c(0,24),ylim=c(0,max(tmp$count)),xlab='hour',ylab='Crimes')
for (i in 1:12){
  tmp1=tmp[tmp$month==i,]
  lines(count~hour,data=tmp1,col=i)
}
abline(v=c(2,8,12,17,20),col='grey')

#look at overall vs "DISORDERLY, DRIVING UNDER THE INFLUENCE, DAMAGE, DISTURBANCE": monthly patterns
cond=crime2$type%in%c('DISORDERLY','DRIVING UNDER THE INFLUENCE','DAMAGE','DISTURBANCE')
crime3=crime2[cond,]
disorder=aggregate(count~month,data=crime3,sum)
disorder$prop=disorder$count/sum(disorder$count)
not.dis=aggregate(count~month,data=crime2[!cond,],sum)
not.dis$prop=not.dis$count/sum(not.dis$count)

plot(prop~month,data=not.dis,xlab='month',ylab='Crimes',type='l',ylim=c(0,0.1))
lines(prop~month,data=disorder,col='red')