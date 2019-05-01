############################################EAGLE MASTER###########################################
#####Belen Villacis
#####01/05/2018

###CHANGE DETECTION ANALYSIS OF LANDSAT 5 TM IMAGERY 2002 AND 2011 FROM SAN LUIS POTOSI - MEXICO###

###Notes:
#First, extract the attached forder R
#Put this folder into the "C" driver

install.packages("devtools")
library(devtools)

devtools::install_github("16EAGLE/getSpatialData")

install.packages("sf")
install.packages("sp")
install.packages("raster")
install.packages("zoom")
install.packages("ggplot2")
install.packages("rgeos")
install.packages("rgdal")
install.packages("randomForest")
install.packages("RStoolbox")
library(getSpatialData)
library(sf)
library(sp)
library(raster)
library(zoom)
library(ggplot2)
library(rgeos)
library(rgdal)
library(randomForest)
library(RStoolbox)

getwd()
setwd("C:/R/Project")

### Area of Interest
aoi <- read_sf(dsn = "C:/R/Project/AOI", layer = "study_area")   #read the shape
aoi <- aoi[[2]]                                                  #AOI as "sp" object
plot(aoi)         
set_aoi(aoi)                                                     #draw or define an AOI
view_aoi(color = "yellow")                                       #display the AOI on an interactive map
get_aoi(type = "sp")                                             #return the defined session AOI
#plot.new()                                                      #if you want to return a new plot window 

### Define and Display the Products
#set_archive("C:/R/Project/Images_download1", create = T)        #if you want to create a directory for the products or
set_archive("C:/R/Project/Images_download")                      #define an existing directory for the products
services_avail()                                                 #display the status of all online services
login_USGS("alebelen27")                                         #define login credentials to the USGS EROS Registration System

product_names <- getLandsat_names()                              #obtain available Landsat product names
product_names                                                    #display these names
time_range <- c("2002-09-01", "2011-09-31")                      #define the time range 
options(max.print = 10000)                                       #extend the table display 
query <- getLandsat_query(time_range = time_range,               #show the availability of the products
                          name = product_names[3], 
                          maxCloudLand = 7,
                          verbose = TRUE)
names(query)                                                     #return the names of the data frame that can be further filtered. 
query[,c(1,7)]                                                   #index the useful columns 
dim(query)                                                       #display the dimention of the data frame 
nrow(query)                                                      #display the number of rows of the data frame

### Select and Download the Products
#2002 Data
getLandsat_preview(query[1,])                                    #apply visual checks to records before downloading the images
query[1,]$levels_available                                       #display the level of available data
images <- getLandsat_data(records = query[1,],                   #download the selected data 
                          level = "sr", 
                          source = "auto")

setwd("C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20020925_20161207_01_T1_LEVEL_Sr")     #set the work directory
direc_imagery02 <- "C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20020925_20161207_01_T1_LEVEL_Sr/LT05_L1TP_028045_20020925_20161207_01_T1_LEVEL_Sr.ZIP"  #address zip folder
unzip(direc_imagery02, list = FALSE, overwrite = TRUE, junkpaths = FALSE,                                       #unzip the work folder 
      exdir = ".", unzip = "internal", setTimes = FALSE)

#2011 Data
getLandsat_preview(query[49,])                                   #apply visual checks to records before downloading the images
query[49,]$levels_available                                      #display the level of available data
images <- getLandsat_data(records = query[49,],                  #download the selected data 
                          level = "sr", 
                          source = "auto")

setwd("C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20110121_20161010_01_T1_LEVEL_Sr")     #set the work directory
direc_imagery11 <- "C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20110121_20161010_01_T1_LEVEL_Sr/LT05_L1TP_028045_20110121_20161010_01_T1_LEVEL_Sr.ZIP"  #address zip folder
unzip(direc_imagery11, list = FALSE, overwrite = TRUE, junkpaths = FALSE,                                       #unzip the work folder
      exdir = ".", unzip = "internal", setTimes = FALSE)

#2005 Data - example                                  #the data is not unzip in the folder, you can run this part
getLandsat_preview(query[4,])
query[4,]$levels_available
images <- getLandsat_data(records = query[49,], 
                          level = "sr", 
                          source = "auto")

setwd("C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20050512_20161127_01_T1_LEVEL_Sr")        
direc_imagery05 <- "C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20050512_20161127_01_T1_LEVEL_Sr/LT05_L1TP_028045_20050512_20161127_01_T1_LEVEL_Sr.ZIP"
unzip(direc_imagery05, list = FALSE, overwrite = TRUE, junkpaths = FALSE, 
      exdir = ".", unzip = "internal", setTimes = FALSE)


### Create a Band Combination - False Color
#2002 Data
plot.new()
setwd("C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20020925_20161207_01_T1_LEVEL_Sr")     #set the work directory       
imagery02 <- list.files(path = "C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20020925_20161207_01_T1_LEVEL_Sr", 
                        pattern = glob2rx("*band*.tif$"), all.files = TRUE,    #produce a character vector of the names of GeoTiff files
                        full.names = FALSE, recursive = FALSE,
                        ignore.case = FALSE, include.dirs = FALSE)
imagery02                                                                      #display a character vector of the names of files
imagery02[2]                                                                   #select a specific band from the work folder

# only band 2
imagery02_band2 <- raster(imagery02[2])                                        #create a raster only with band 2    
par(col.axis = "blue", col.lab = "blue", tck = 0)                              #set some parameters to the plots
box(col = "black")                                                             #set some parameters to the plots
plot(imagery02_band2, main = "Image 2002 - band 2", col = gray(0:100 / 100))   #plot the band 2 of 2002 image in gray scale
plot(imagery02_band2, main = "Image 2002 - band 2")                            #plot the band 2 of 2002 image 

# more bands
imagery02_stack <- stack(imagery02)                                            #create a collection of RasterLayer objects with the same spatial extent and resolution
imagery02_brick <- brick(imagery02_stack)                                      #create a multi-layer raster layer 
ima
gery02_brick                                                                #display the information of the brick
plot(imagery02_brick, col = gray(20:100/100))                                  #plot the brick in gray scale - Do you notice the long names?

names(imagery02_brick)                                                         #display the names of the brick 
names(imagery02_brick) <- gsub(pattern = "LT05_L1TP_028045_20020925_20161207_01_T1_sr_",     #change de names of the plots 
                               replacement = "", names(imagery02_brick))
plot(imagery02_brick, col = gray(20:100/100))                                  #plot again and see the difference in gray scale
plot(imagery02_brick)                                                      

#just plot and see the complete false color combination
falsecolor02 <- plotRGB(imagery02_brick, r = 6, g = 4, b = 2,                  #plot a RGB combination: false color 
                stretch = "lin", maxpixels = 60000000, axes = TRUE, 
                main = "False Color Combination 2002, RGB: 7,4,2")
box(col = "black")                                                             #set a parameter to the plot
zm(type = "session", rp = NULL)                                                #zoom with commands - but take a lot of time                             

#2011 Data    
setwd("C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20110121_20161010_01_T1_LEVEL_Sr")    #set the work directory
imagery11 <- list.files(path = "C:/R/Project/Images_download/get_data/LANDSAT/SR/LT05_L1TP_028045_20110121_20161010_01_T1_LEVEL_Sr", 
                        pattern = glob2rx("*band*.tif$"), all.files = TRUE,    #produce a character vector of the names of GeoTiff files
                        full.names = FALSE, recursive = FALSE,
                        ignore.case = FALSE, include.dirs = FALSE)
imagery11                                                                      #display a character vector of the names of files
imagery11[4]                                                                   #select a specific band from the work folder
  
# only band 4
imagery11_band4 <- raster(imagery11[4])                                        #create a raster only with band 4 
plot(imagery11_band4, main = "Image 2011 - band 4", col = gray(0:100 / 100))   #plot the band 4 of 2011 image in gray scale
plot(imagery11_band4, main = "Image 2011 - band 4")                            #plot the band 4 of 2011 image

# more bands
imagery11_stack <- stack(imagery11)                                            #create a collection of RasterLayer objects with the same spatial extent and resolution                                       
imagery11_brick <- brick(imagery11_stack)                                      #create a multi-layer raster layer 
imagery11_brick                                                                #display the information of the brick
plot(imagery11_brick, col = gray(20:100/100))                                  #plot the brick in gray scale - Do you notice the long names?

names(imagery11_brick)                                                         #display the names of the brick
names(imagery11_brick) <- gsub(pattern = "LT05_L1TP_028045_20110121_20161010_01_T1_sr_",      #change de names of the plots
                               replacement = "", names(imagery11_brick))         
plot(imagery11_brick, col = gray(20:100/100))                                  #plot again and see the difference in gray scale
plot(imagery11_brick)

falsecolor11 <- plotRGB(imagery11_brick, r = 6, g = 4, b = 2,                  #plot the complete RGB combination: false color              
                        stretch = "lin", maxpixels = 60000000, axes = TRUE, 
                        main = "False Color Combination 2011, RGB: 7,4,2")
box(col = "black")                                                             #set a parameter to the plot
zm(type = "session", rp = NULL)                                                #zoom with commands - but take a lot of time                             


### Create a Subset of the Interest Area
subset <- readOGR(dsn = "C:/R/Project/SUBSET/subset.shp", layer = "subset")    #readthe polygon shape file to subset 
subset                                                                         #display the information of the shape file 
plot(subset)                                                                   #plot the shape file

# 2002 Data 
subset02 <- crop(imagery02_brick, subset)                                      #crop the bands of the false color combination 
subset02                                                                       #display information of the subset
plot(subset02)                                                                 #plot the band of the subset
subset02_final <- plotRGB(subset02, r = 6, g = 4, b = 2,                       #visualize the subset RGB combination: false color
                          stretch = "lin", maxpixels = 60000000, axes = TRUE,
                          main = "False Color Combination 2002, RGB: 7,4,2")                                                                #plot the bands of the subset

# 2011 Data
subset11 <- crop(imagery11_brick, subset)                                      #crop the bands of the false color combination 
subset11                                                                       #display information of the subset
plot(subset11)                                                                 #plot the band of the subset
subset11_final <- plotRGB(subset11, r = 6, g = 4, b = 2,                       #visualize the subset RGB combination: false color
                          stretch = "lin", maxpixels = 60000000, axes = TRUE,
                          main = "False Color Combination 2011, RGB: 7,4,2")  


###Image Clasification - Random Forest Classification
training_data <- readOGR(dsn = "C:/R/Project/TRAINING_DATA/training_c.shp", layer = "training_c")    #define the training shape file
training_data                                                                                        #display information of the shape file
plot(training_data)                                                                                  #plot the shape file

#Data 2002: subset02 (brick - multi layer raster) and training_data (shape file)
subset02                                                                                             #required data for the classification
training_data 

getwd()                                                                                              #see the current work directory
setwd("C:/R/Project/RF_CLASSIFICATION")                                                              #set a new directory to save the classification
classification02 <- superClass(subset02, training_data, responseCol = "class", trainPartition = 0.75,       #classify raster brick subset 2002
                               model = "rf", mode  = "classification", filename = "classification02.tif", 
                               overwrite = T)
plot(classification02$map, main = "Random Forest Classification 2002 - San Luis Potosi")             #plot classification 2002
classification02$validation                                                                          #display information about validation process
#overal accuracy for classification 2002: 0.8894
#kappa index: 0.7321


#Data 2011: subset11 (brick - multi layer raster) and training_data (shape file)
subset11                                                                                             #required data for the classification
training_data 

classification11 <- superClass(subset11, training_data, responseCol = "class", trainPartition = 0.75,       #classify raster brick subset 2011
                               model = "rf", mode  = "classification", filename = "classification11.tif", 
                               overwrite = T)
plot(classification11$map, main = "Random Forest Classification 2011 - San Luis Potosi")             #plot classification 2011         
classification11$validation                                                                          #display information about validation process
#overal accuracy for classification 2002: 0.8576
#kappa index: 0.6841


#change Detection Analysis
class02 <- raster("C:/R/Project/RF_CLASSIFICATION/classification02.tif")         #define the classification 2002 image           
class11 <- raster("C:/R/Project/RF_CLASSIFICATION/classification11.tif")         #define the classification 2011 image
change_detection <- overlay(class02, class11,                                    #determine the difference (changes) between the images
                            fun = function(r1,r2){(r2-r1)}, 
                            unstack = T, forcefun = F, 
                            filename = "change_detection.tif", overwrite = T)
plot(change_detection,  main = "Change Detection 2002 and 2011")                 #plot the result image
hist(change_detection,  main = "Change and No-change Values",                    #display the histogram to see the values
     maxpixels = 1000000, col = "orange")

#reclassification: define the values from 0 to 1 as built changes
breaks <- 0:1                                                                    #define the interest values
reclass_change_detection <- cut(change_detection, breaks = breaks,               #reclassify the complete classification
                                filename = "reclass_change_detection.tif", 
                                overwrite = T)
reclass_change_detection                                                         #display the information of the result
plot(reclass_change_detection, main = "Reclassified Built Change Detection")     #plot the result


#Masking the Changes with the Urban Area of San Luis Potosi                      
urban_area <- readOGR(dsn = "C:/R/Project/URBAN_AREA/urban_area.shp", layer = "urban_area")    #define the urban area shape file
urban_area                                                                                     #display information of the shape file
plot(urban_area)                                                                               #plot the urban area file

built_change_detection_2002_2011 <- raster("C:/R/Project/RF_CLASSIFICATION/reclass_change_detection.tif")   #define the work raster file

built_changes <- mask(built_change_detection_2002_2011, urban_area,                            #mask the raster file with the urban area shape file
                      filename = "Built_Change_Detection_2002_2011.tif", overwrite = T)
plot(built_changes, main = "Built Change Detection 2002-2011 from San Luis Potosi - Mexico")   #plot the final result


### Finally a Nice Plot
built_changes_final <- raster("C:/R/Project/RF_CLASSIFICATION/Built_Change_Detection_2002_2011.tif")
built_changes_final
urban_area

box(col = "transparent")
subset11_final <- plotRGB(subset11, r = 3, g = 2, b = 1,                                       #visualize the subset RGB combination: false color
                          stretch = "lin", maxpixels = 60000000, axes = TRUE,
                          main = "Built Change Detection 2002 - 2011 from San Luis Potosi")
plot(built_changes_final, col = "red", add=TRUE)                                               #visualize the change raster
plot(urban_area, add=TRUE)                                                                     #visualize the shape file
#########################################END#################################################
