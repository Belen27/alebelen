###### simple operations
5+67*9
0/0
1/0
result1<-5+6
result1

log(10)
max(6,9,12,1)
min(7,2,5,-2)
sum(77,90,8734928734928374)
seq(1,100,by=10)
seq(1000)
a<-c(1,4,6,7)

c("&A",1:100)

#######################
seq()         #generate a user defined sequence of data
seq(1,9,by=2) #generates: 1,3,5,7,9
seq(100)      #generates a sequence from 1 to 100 in 1 steps


c()           #coerces values into a vector
a <- c(1,3,5,7,9) 

c("A", 1:100) #combines character and numbers 1 to 100
x <- c("A", 1:100) #assigns result to "x"

plot(seq(100)) #plot sequence of 100 values

runif(100)     #random numbers reated
sample(100)
rnorm(100)

q()            #quit
q("n")         #exits R without saving (n=no)

summary(seq(100)) #generate summary statistics 
plot(a)           #plot the data
str()             #display structure of your data file
head()            #display the top rows of your data
ls()              #list all  files in the working directory
rm(a)             #remove the file from the working directory
getwd()           #print working directory
setwd("C:/Users/Personal/Desktop/Programming") #set working directory

prec_avg <- c(56,46,50,53,69,83,83,80,62,55,60,63) #c command combines values
plot(prec_avg)    #plot the data

plot(prec_avg, pch=19, cex=2, col="#00ff0060") 
pch=              #point type
cex=              #magnify symbols and text
col=""            #html color code with translucency

lines(lowess(prec_avg, f=.2)) #a smoothed lines connecting the points

--------------------------------------------------------------------------

install.packages ("raster")     #install the package
library(raster)                 #load it
install.packages("sp")
library(sp)

germany <- getData("GADM",country="DEU",level=2)  #get country borders, other country codes can be found in the manual
plot(germany)     #plot germany boundaries
prec<-getData("worldclim",var="prec",res=.5,lon=10,lat=51)  #get precipitation data, lon/lat only needed for res=.5
plot(prec)  #plot precipitation

prec_ger1<-crop(prec, germany) #crop precipitation to extend of germany
spplot(prec_ger1)               #plot result

prec_ger2<-mask(prec_ger1,germany) #mask precipitation to shape of germany 
spplot(prec_ger2)                  #plot result


prec_avg<-cellStats(prec_ger2,stat="mean") #extract precipitation average of germany, other statistics possible as well


------------------------------------------------------------------------------
##### DOCUMENTS
  
install.packages("rmarkdown")
library(rmarkdown)
install.packages("knitr")
library(knitr)
install.packages("Tex")
install.packages("libs")

sessionInfo()

#ask for libreries (png, tex, libs)
#why I cannot create a Pdf
#how can I put a picture from internet
#how can I save a scrip in github
#I can connet to my reporsitory alebelen

------------------------------------------------------------------

####google

install.packages("googlesheets")

---------------------------------------------------------------------------
###### IMPORT

install.packages("rgdal")
library(rgdal)
install.packages("sp")
library(sp)
install.packages("rt")
library(rt)

getwd()         #print the current working directory

#the working direectory should be the location on your hardrive where your project/data is stored
setwd("C:/Users/Personal/Desktop/Programming/tasks")  #set the new working directory

#alternative option is to
#(1)keep the current directory and add full path to your import command 
#(2)save the directory where your data is stored and enter it each time in the comand 
set_dir<-"/home/wegmann/analysis/project4/data"  #insert the path in import/export path definition

my.df<-read.csv("tabla.csv",header = TRUE,sep = "/")

read.table("mytextfile.txt",   #your actual file
header= TRUE,                  #define if first row consists of name not values
sep="/")                       #define how columns are separated, just open it in a text editor to check

dec="."                        #define the decimal separator
na.strings="NA"                #define how NAs are identified, can be changed to e.g. a number
stringsAsFactors=TRUE          #if variables are converted to character type (FALSE)

my.df                          #print the whole data
head("my.df")                  #just print the first rows
summary("my.df")               #provide summary statistics
plot(my.df)                    #first plot of the data 

my.df<-read.csv("tabla.csv",header = FALSE,sep = ";")
my.df<-read.csv("tabla.csv",header = TRUE,sep = ";")

write.table("my.df", file="my_data_frame.txt")     
"my.df",                       #define the data frame to export
file="my_data_frame.txt"       #name of the exported file

----------------------------------------------------------------
############### task
  
##### Import  

getwd()
setwd("C:/Users/Personal/Desktop/Programming")
set_dir<-"C:/Users/Personal/Desktop/Programming"

x<-read.table("tabla.csv",header = TRUE,sep=";")
x<-read.csv("tabla.csv",header=TRUE, sep=";")
x<-read.csv("tabla.csv", header=TRUE, sep=";", dec=".",na.strings = "NA", stringsAsFactors = TRUE)
x

###### Inspection

head(x)
summary(x)
plot(x)


####### Export

write.table("x", file="tabla1.csv")

getwd()

  

      