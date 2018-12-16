####### 2_class

difftime("2019-02-27", Sys.Date(),units = "days")
difftime("2019-12-24", Sys.Date(),units = "weeks")
difftime("2019-02-27", Sys.Date(),units = "sec")

#### precipitation

install.packages("raster")
library(raster)
library(sp)

ecuador<-getData("GADM", country="ECU", level=2)
plot(ecuador)

mean <- getData("worldclim", var="tmean", res=10)
spplot(mean)

mean_ecu1<-crop(mean,ecuador)
spplot(mean_ecu1)

mean_ecu2<-mask(mean_ecu1,ecuador)
spplot(mean_ecu2)

mean_avg<-cellStats(mean_ecu2, stat="mean")
plot(mean_avg)
head(mean_avg)
summary(mean_avg)

########### Inverse mask

mean_final<-mask(mean_ecu1, ecuador, inverse=TRUE)   #drop off Ecuador 
mean_final<-mask(mean_ecu2, ecuador, inverse=TRUE)   #empty maps
plot(mean_final)


#######create a document


install.packages("rmarkdown")    #for information http://rmarkdown.rstudio.com>
library(rmarkdown)

install.packages("devtools")
library(devtools)
devtools::install_github("username/packagename")


####### Point Data as Data Frame

#download file from web page

getwd()
setwd("C:/Users/Personal/Desktop/Programming/tasks")

df<-read.csv("Steigerwald_sample_points_all_data_subset_withNames.csv")
df

#alternative import methods
#access online text file
install.packages("RCurl")
library(RCurl)

df<-read.csv("https://raw.githubusercontent.com/wegmann/R_data/master/Steigerwald_sample_points_all_data_subset_withNames.csv")
df

#other packages and different output
#tidyverse package
#out is a tibble object

install.packages("tidyverse")
library(tidyverse)
  
df<-read.csv("Steigerwald_sample_points_all_data_subset_withNames.csv")
df<-read.csv("https://raw.githubusercontent.com/wegmann/R_data/master/Steigerwald_sample_points_all_data_subset_withNames.csv")
df

head(df)
tail(df)
summary(df)
str(df)
names(df)
dim(df)
class(df)
levels(df)

plot(df)
plot.new()


########## INDEXING

#### VECTOR DATA (sequence of data elements of the same type)

c <- c(2,3,5)
c
x <- c("aa", "bb", "cc", "dd", "ee")
x  

####Indexing a Vector Data
#generate a vector 
X<-seq(1,100, by=2.5)     #create a sequence from 1 to 100 by steps of 2.5
X                         #show all data

X[5]           #query 5th position
X[4:10]        #extract 4th to 10th position 

#extract the last value
X[length(X)]   #length of X and query this position
X[length(X)-1] #length of X and query  this minus one position
X[length(X)-3]

X[-2]          #extract all except this position
X[-10]

#how to extract or omit a list of numbers
idx<-c(1,4,6)  #a vector  with 3 numbers
X[idx]         #query X based on idx numbers
X[-idx]        #omit X query of these 3 numbers

#how to query values of data
X>20                #above 20
(X<=10) | (X>=30)   #below or equal 10 OR above or equal 30 

#how to query values of data and receive the actual values
X[X<10 | X>30]      #provide all data below 10 OR above 30
X[X<10 & X>30]      #provide all data below 10 AND above 30
X[X<10 & X<30]      #provide all data below 10 AND below 30

#change values
X2<-numeric(length(X))       #change the values of the data with 0

X2[X<=30] <- 1               #change specific values (condition) with 1
X2[(X>30) & (X<70)] <- 2     #change specific values (condition) with 2
X2[X>70] <- 3                #change specific values (condition) with 3
X2

#alternative approach 
install.packages("car")
library(car)

X2<-recode(X, "0:30=1; 30:70=2; else=3")  #same as 3 conditions
X2

#some stats
summary(X)     #general summary stats 
sum(X)         #general sum
cumsum(X)      #cummulative sum

summary(X2)    
sum(X2)        
cumsum(X2)

#some data modification 
rev(X)                        #revert the order
sort(X, decreasing = TRUE)    #revert the order
sample(X, 10)                 #sample 10 values out of X


### MATRIX DATA (data elements arranged in a two-dimensional rectangular layout)

m1<-matrix(c(4,7,3,8,9,2), nrow=2)    #generate a 2x3 matrix
m1

m2<-matrix(c(2,4,3,1,5,7), nrow=2, ncol=3, byrow = TRUE)  #with defined rows and columns and how to fill it
m2
#c(2,4,3,1,5,7)          the data number      
#nrow=2                  number of rows
#ncol=3                  number of columns
#byrow=TRUE              fill matrix by rows

#Indexing a Matrix Data
m1[,2]            #query 2nd column
m1[2,]            #query 2nd row
m1[2,2]           #query 2nd row and 2nd column

#created a matrix out of a vector
number_1<-rnorm(80, mean=0, sd=1)   #create a vector with 80 entries based on normally distributed data 
number_1
class(number_1)

mat_1<-matrix(number_1, nrow=20, ncol=4)  #populate matrix with vector data in 20 rows and 4 columns
mat_1

#convert a matrix into a DATA FRAME
df_1 <- data.frame(mat_1)     #matrix values into a data frame
df_1                          
class(df_1)

names(df_1) <- c("var1", "var2", "var3", "var4")  #assign column names

head(df_1)
summary(df_1)

#######DATA FRAME (Similar to a spreadsheet - table)
#create a Data Frame
test<-data.frame(A=c(1,2,3), B=c("aB1", "aB2", "aB3")) #generate a data frame with 2 columns (vector)
test

#indexing a Data Frame
test[,1]     #query just "A"
test[,"A"]   #equivalent to
test$A

#create another data frame
df_2<-data.frame(var1=c(0.08, 0.34, 0.12, 0.81), var2=c(83, 65, 87, 19), var3=c("A","B","C","D"), var4=c(1,1,0,1))
df_2
names(df_2)

#indexing the data frame
df_2[1,1]
df_2[3,2]
df_2[,1]
df_2[2,]
df_2$var1
df_2$var3[1:3]
df_2[3:4,]
df_2[,1:3]
df_2[3:4,1:3]

##more complex Data Frames

#first we create a data frame with characters and numbers

options(max.print = 1000000)       #increase the numbers of plot values
df_3<-data.frame(plot="location_name_1", measure1=runif(100)*1000, measure2=round(runif(100)*100), value=rnorm(100,2,1), ID=rep(LETTERS,50))
df_3

df_4<-data.frame(plot="location_name_2", measure1=runif(50)*100, measure2=round(runif(50)*10), value=rnorm(50), ID=rep(LETTERS,50))
df_4


dfx<-rbind(df_3,df_4)         #data frame combined by rows
dfx
names(dfx)

dfy<-cbind(df_3,df_4)         #data frame combined by columns
dfy
names(dfy)

#value=....        name of column and its data 
#runif()           equal distribution w/number of observations
#rnorm()           normal distribution w/mean and sd
#rep()             repeat x times
#round()           rounding of numbers
#LETTERS=          in-build constants
#rbind()           combine 2 data frame row-wise (see also cbind for columns)

#before indexing start a quick look at the data
summary(dfx)
str(dfx)
mode(dfx)
head(dfx)
class(dfx)

#indexing data 
dfx[,c('plot', 'measure1', 'measure2')]        #plot whole data just for plot, measure1 and measure2
dfx[66:115,c('plot', 'measure1', 'measure2')]  #plot data just for rows 66 to 115 and for plot, measure 1 and 2


######LIST DATA (generic vector containing other objects)

#create a list based on 2 vectors
a<- runif(199)
b<- c("aa", "bb", "cc", "dd", "ee")

c<- list(a,b)    #a list from 2 vectors of different sizes
c

#indexing a list
c[2]           #index the 2nd object
c[[2]]         #same as
c[[2]][1]      #first entry of second object
c[[2]][4]      #fourth entry of second object *** preguntar como llamo al ultimo valor

a<- list(obj_1=runif(100), obj_2=c("aa", "bb"), obj_3=c(1,2,4)) #list from vectors of different sizes
a

a$obj_1           #call the object name
a[["obj_1"]]      #or
a[[1]]            #or

#a list with a matrix, vector and data frame of different sizes
a<- list(m1=matrix(runif(50),nrow=5), v1=c(1,6,10), df5=data.frame(a=runif(100),b=rnorm(100)))
a

a$df5[,1]   #index a data frame or matrix as known

########## task (plot-indexing data frame)
dfx[, c("measure1", "measure2")]           #indexing 2 variables
dfx[100:200, c("measure1")]                #part of 1 variable
dfx[,c("plot", "measure1", "measure2")]    #indexing 3 variables

plot(dfx[, c("measure1", "measure2")])         #plot-indexing 2 variables
plot(dfx[, c("plot", "measure1", "measure2")]) #plot-indexing 3 variables
plot(dfx[100:200, c("measure1")])              #plot-indexing part of 1 variable

boxplot(split(dfx$measure1, dfx$measure2), main="values", by="ID") #boxplot
boxplot(split(dfx$measure1, dfx$measure2), main="values", xlab="values", ylab="ID")
boxplot(split(dfx$measure1, dfx$measure2), main="values", xlab="values", ylab="ID", col=c("gold","darkgreen"))

plot.new()

####### example Violin Plots
install.packages("vioplot")
library(vioplot)
x1 <- mtcars$mpg[mtcars$cyl==4]
x1
plot(x1)
x2 <- mtcars$mpg[mtcars$cyl==6]
x2
plot(x2)
x3 <- mtcars$mpg[mtcars$cyl==8]
x3
plot(x3)
vioplot(x1, x2, x3, names=c("4 cyl", "6 cyl", "8 cyl"), col="green")
title("Violin Plots of Miles Per Gallon")

#######other plots

#bagplot
install.packages("aplpack")
library(aplpack)
attach(mtcars)
bagplot(wt,mpg, xlab="Car Weight", ylab="Miles Per Gallon", main="Bagplot Example") 

#hist
hist(x=runif(50)*100, main="Histogram", xlab="value", border="blue", col="green",las=0, breaks=5)

#coplot (no sale)
coplot(measure1 ~ values|measure2, data=dfx, rows=1, xlab="value", ylab = "ID")


################Mean Data Ecuador

mean_avg[7]          #how to extract the value of July (7)
plot(mean_avg[4:9])  #plot the data "mean" form April to September

#some basics analysis of your mean data
mean_avg[2]-mean_avg[1]   #substract the January from the February mean data
sum(mean_avg)             #sum of mean data
cumsum(mean_avg)          #cummulative of mean data
max(mean_avg)             #maximum mean data
range(mean_avg)           #range of values
which.min(mean_avg)       #which is the minimum value
which.min(abs(mean_avg-50))  #which is closest to value x (50)
diff(mean_avg)            #difference between elements

########## task
cut()
sort()
order()
quantile()

x<-rnorm(10) #generate random numbers
x

###CUT()
#the new created numbers are now ordered to the defined area -2:1
#the new area has three groups
#now you can see how often a number of the data appears in which group
table(cut(x, breaks=-2:1))

###SORT()
sort(x, decreasing = FALSE)  #from low to high values
sort(x, decreasing = TRUE)   #from high to low values
sort.int(x, partial = NULL, na.last = NA, decreasing = FALSE, method = c("auto", "shell", "quick", "radix"), index.return = FALSE)

###ORDER()
order(x, na.last = TRUE, decreasing = FALSE, method = c("auto", "shell", "radix"))

###QUANTILE()
quantile(x, probs = seq(0, 1, 0.25), na.rm = FALSE, names = TRUE, type = 7,)


######### task Index Data Frame (df->Martin)
head(df)
df$LUCAS_LC           #same as, index column LUCAS_LC
df[,"LUCAS_LC"]       #same as, index column LUCAS_LC
df[,3]                #same as, index column LUCAS_LC
  
df[,4:13]             #index only S2* data
head(df[,4:13])

df[length(df)-1]      #index the second last column
head(df[length(df)-1])

df[1:10,]             #index all columns but just 10 rows

df[,c(3, 14)]               #Index column LUCAS_LC ans SRTM
df[,c("LUCAS_LC", "SRTM")]

############ READ THE ARTICLE




