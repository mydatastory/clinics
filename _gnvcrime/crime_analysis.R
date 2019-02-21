rm(list=ls(all=TRUE))
setwd('U:\\maxwell\\crimes')
crime=read.table('Crime_Incident_Heatmap_2011_-_Present.tsv',sep='\t',header=T,as.is=T)
crime$hour=crime$month=crime$year=crime$latit=crime$longit=NA

#get dates
datas=strsplit(crime$Offense.Date,split=' ')
datas1=matrix(unlist(datas),length(datas),3,byrow=T)
tmp=strsplit(datas1[,1],split='/')
tmp1=matrix(unlist(tmp),length(tmp),3,byrow=T)
crime$month=tmp1[,1]
crime$year=tmp1[,3]

#get hours
tmp=gsub(':',',',datas1[,2])
tmp1=strsplit(tmp,split=',')
tmp2=matrix(unlist(tmp1),length(tmp1),3,byrow=T)
tmp3=ifelse(datas1[,3]=='AM',as.numeric(tmp2),as.numeric(tmp2)+12)
crime$hour=tmp3

#get incident type
crime$type='other'
z=sort(table(crime$Incident.Type),decreasing=T)
tmp=c("ASSAULT", "BATTERY", "BURGLARY", "CRIMINAL MISCHIEF", "DAMAGE", "DATING VIOLENCE", 'DCF',"DISORDERLY", "DISTURBANCE", "DOMESTIC", "DRIVING UNDER THE INFLUENCE", "DRUG", "FRAUD", 'IDENTITY THEFT','RUNAWAY',"ROBBERY", "STOLEN PROPERTY", "STOLEN VEHICLE", "THEFT GRAND", "THEFT PETIT",'TRESPASS')
for (i in 1:length(tmp)){
  ind=grep(tmp[i],crime$Incident.Type)
  crime$type[ind]=tmp[i]
}
table(crime$type)

#get locations
tmp=strsplit(crime$Location,split='\\(')
for (i in 1:length(tmp)){
  print(i)
  tmp1=tmp[[i]]
  n=length(tmp1)
  if (n>1){
    tmp1=gsub('\\)','',tmp1[n])
    tmp2=strsplit(tmp1,', ')
    crime[i,c('latit','longit')]=as.numeric(tmp2[[1]])
  }
}
sum(is.na(crime$latit))

nomes=c('ï..ID','City','State','longit','latit','year','month','hour','type')
write.csv(crime[,nomes],'crime_edited1.csv',row.names=F)
