difftime("2018-12-24",Sys.Date(),units="days")
difftime("2019-02-27",Sys.Date(),units="weeks")
difftime("2019-02-27",Sys.Date(),units="secs")



install.packages("raster")
library(raster)
ecuador<-getData("GADM",country="ECU"),level=0)
plot(ecuador)
prec<-getData("worldclim",var="prec",res=.5,lon=78,lat=1)
plot(prec)

getw()
setwd()

install.packages("RCurl")
library(RCurl)
setwd("C:\\Users\\s373669\\Desktop\\belen")
table <- read.csv("table1.csv")
table
df<-read.csv("C:\\Users\\s373669\\Desktop\\belen")

getwd()
table<-read.csv("table1.csv")
table

table<- seq(1,100,by=2.5)
table[5]
table[-2]

idex<-c(1,4,6)
table[idx]

table>20


head(table)




df$LUCAS.LC