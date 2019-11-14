The question we want to answer is: “For any given London Borough, are the Blue Plaques within that borough distributed randomly or do they exhibit some kind of dispersed or clustered pattern?”

# install libraries

library(spatstat)
library(sp)
library(rgeos)
library(maptools)
library(GISTools)
library(tmap)
library(sf)
library(geojson)
library(geojsonio)
library(tmaptools)
library("geojson_read")

install.packages("spatstat")
install.packages("maptools")
install.packages("GISTools")
install.packages("geojson")
install.packages("geojsonio")

##First, get the London Borough Boundaries
EW <- geojson_read(
  "https://opendata.arcgis.com/datasets/8edafbe3276d4b56aec60991cbddda50_4.geojson",
  what = "sp")

Pull out london using grep and the regex wildcard for’start of the string’ (^) to to look for the bit of the district code that relates to London (E09) from the ‘lad15cd’ column in the data slot of our spatial polygons dataframe
BoroughMap <- EW[grep("^E09",EW@data$lad15cd),]
#plot it using the base plot function
qtm(BoroughMap)
summary(BoroughMap)

#transform borough maop to BNG
BNG = "+init=epsg:27700"
BoroughMapBNG <- spTransform(BoroughMap,BNG)

##Now get the location of all Blue Plaques in the City
BluePlaques <- geojson_read(
  "https://s3.eu-west-2.amazonaws.com/openplaques/open-plaques-london-2018-04-08.geojson",
  what = "sp")
summary(BluePlaques)

#now set up an EPSG string to help set the projection 
BNG = "+init=epsg:27700"
WGS = "+init=epsg:4326"
BluePlaquesBNG <- spTransform(BluePlaques, BNG)
summary(BluePlaquesBNG)

#plot the blue plaques in the city
tmap_mode("view")
tm_shape(BoroughMapBNG) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaquesBNG) +
  tm_dots(col = "blue")

6.4.1 Data cleaning
#remove duplicates
BluePlaquesBNG <- remove.duplicates(BluePlaquesBNG)
# Now just select the points inside London - thanks to Robin Lovelace for posting how to do this one, very useful!
BluePlaquesSub <- BluePlaquesBNG[BoroughMapBNG,]
#check to see that they've been removed
tmap_mode("view")
tm_shape(BoroughMapBNG) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaquesSub) +
  tm_dots(col = "blue")

6.4.2 Study area - selecting London Borough of Harrow

#extract the borough
Borough <- BoroughMapBNG[BoroughMapBNG@data$lad15nm=="Harrow",]

#or as an sf object:
BoroughMapBNGSF <- st_as_sf(BoroughMapBNG)
BoroughSF <- BoroughMapBNGSF[BoroughMapBNGSF$lad15nm=="Harrow",]

#Check to see that the correct borough has been pulled out
tm_shape(Borough) +
  tm_polygons(col = NA, alpha = 0.5)
#Next we need to clip our Blue Plaques so that we have a subset of just those that fall within the borough or interest
#clip the data to our single borough
BluePlaquesSub <- BluePlaquesBNG[Borough,]
#check that it's worked
tmap_mode("view")
## tmap mode set to interactive viewing
tm_shape(Borough) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaquesSub) +
  tm_dots(col = "blue")

=====
# try doing this for Lewisham
  
#extract the borough
Borough <- BoroughMapBNG[BoroughMapBNG@data$lad15nm=="Lewisham",]

#or as an sf object:
BoroughMapBNGSF <- st_as_sf(BoroughMapBNG)
BoroughSF <- BoroughMapBNGSF[BoroughMapBNGSF$lad15nm=="Lewisham",]

#Check to see that the correct borough has been pulled out
tm_shape(Borough) +
  tm_polygons(col = NA, alpha = 0.5)
#Next we need to clip our Blue Plaques so that we have a subset of just those that fall within the borough or interest
#clip the data to our single borough
BluePlaquesSub <- BluePlaquesBNG[Borough,]
#check that it's worked
tmap_mode("view")
## tmap mode set to interactive viewing
tm_shape(Borough) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(BluePlaquesSub) +
  tm_dots(col = "blue")

====
#go back to harrow to continue practical 
====
# create an observation window for spatstat to carry out its analysis within — we’ll set this to the extent of the Harrow boundary
#now set a window as the borough boundary
window <- as.owin(Borough)
plot(window)


#need to create a point pattern (ppp) object.
#create a ppp object
BluePlaquesSub.ppp <- ppp(x=BluePlaquesSub@coords[,1],y=BluePlaquesSub@coords[,2],window=window)

#check blue plaque coordinates
BluePlaquesSub@coords[,1]

#Have a look at the new ppp object
plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques Harrow")
====

6.5 Point pattern analysis
6.5.1 Kernel Density Estimation
# produce a Kernel Density Estimation (KDE) map from a ppp object using the density function
plot(density(BluePlaquesSub.ppp, sigma = 500))

#experimenting with different values of sigma to see how that affects the density estimate.
plot(density(BluePlaquesSub.ppp, sigma = 1000))
plot(density(BluePlaquesSub.ppp, sigma = 2000))

6.5.2 Quadrat Analysis
we are interesting in knowing whether the distribution of points is ‘complete spatial randomness’ 
#carry out a simple quadrat analysis using the quadrat count function in spatstat

#First plot the points
plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques in Harrow")
#now count the points in that fall in a 6 x 6 grid overlaid across the window
plot(quadratcount(BluePlaquesSub.ppp, nx = 6, ny = 6),add=T,col="red")

# want to know whether or not there is any kind of spatial patterning associated with the Blue Plaques in areas of London
# Using the same quadratcount function again (for the same sized grid) we can save the results into a table:

#run the quadrat count
Qcount<-data.frame(quadratcount(BluePlaquesSub.ppp, nx = 6, ny = 6))
#put the results into a data frame
QCountTable <- data.frame(table(Qcount$Freq, exclude=NULL))
#view the data frame
QCountTable

#we don't need the last row, so remove it
QCountTable <- QCountTable[-nrow(QCountTable),]

# Check the data type in the first column - if it is factor, we will need to convert it to numeric
class(QCountTable[,1])

#oops, looks like it's a factor, so we need to convert it to numeric
vect<- as.numeric(levels(QCountTable[,1]))
vect <- vect[1:6]
QCountTable[,1] <- vect

# next we need to calculate our expected values

#calculate the total blue plaques (Var * Freq)
QCountTable$total <- QCountTable[,1]*QCountTable[,2]
#calculate mean
sums <- colSums(QCountTable[,-1])
sums

#and now calculate our mean Poisson parameter (lambda)
lambda <- sums[2]/sums[1]

# Calculate expected using the Poisson formula 
QCountTable$Pr <- ((lambda^QCountTable[,1])*exp(-lambda))/factorial(QCountTable[,1])
#now calculate the expected counts and save them to the table
QCountTable$Expected <- round(QCountTable$Pr * sums[1],0)
QCountTable

#Compare the frequency distributions of the observed and expected point patterns
plot(c(1,5),c(0,14), type="n", xlab="Number of Blue Plaques (Red=Observed, 
     Blue=Expected)", ylab="Frequency of Occurances")
points(QCountTable$Freq, col="Red", type="o", lwd=3)
points(QCountTable$Expected, col="Blue", type="o", lwd=3)

# need to confirm that the pattern is close to Complete Spatial Randomness (i.e. no clustering or dispersal of points). use we can use the quadrat.test function, built into spatstat. 
teststats <- quadrat.test(BluePlaquesSub.ppp, nx = 6, ny = 6)
teststats

# then plot the results
plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques in Harrow")
plot(teststats, add=T, col = "red")
============================
6.5.3 Running a quadrat analysis for different grid arrangements say 10 by 10 
  plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques in Harrow")
#now count the points in that fall in a 10 x 10 grid overlaid across the window
plot(quadratcount(BluePlaquesSub.ppp, nx = 10, ny = 10),add=T,col="red")

#run the quadrat count
Qcount<-data.frame(quadratcount(BluePlaquesSub.ppp, nx = 10, ny = 10))
#put the results into a data frame
QCountTable <- data.frame(table(Qcount$Freq, exclude=NULL))
#view the data frame
QCountTable
#we don't need the last row, so remove it
QCountTable <- QCountTable[-nrow(QCountTable),]
class(QCountTable[,1])
vect<- as.numeric(levels(QCountTable[,1]))
vect <- vect[1:10]
QCountTable[,1] <- vect
QCountTable$total <- QCountTable[,1]*QCountTable[,2]
#calculate mean
sums <- colSums(QCountTable[,-1])
sums
#and now calculate our mean Poisson parameter (lambda)
lambda <- sums[2]/sums[1]
# Calculate expected 
QCountTable$Pr <- ((lambda^QCountTable[,1])*exp(-lambda))/factorial(QCountTable[,1])
#now calculate the expected counts and save them to the table
QCountTable$Expected <- round(QCountTable$Pr * sums[1],0)
QCountTable

#Compare the frequency distributions of the observed and expected point patterns
plot(c(1,5),c(0,14), type="n", xlab="Number of Blue Plaques (Red=Observed, 
     Blue=Expected)", ylab="Frequency of Occurances")
points(QCountTable$Freq, col="Red", type="o", lwd=3)
points(QCountTable$Expected, col="Blue", type="o", lwd=3)

# remember to change grid to 10 by 10 
teststats <- quadrat.test(BluePlaquesSub.ppp, nx = 10, ny = 10)
teststats

plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques in Harrow")
plot(teststats, add=T, col = "red")

# result 10 by 10m is to detailed - so try something different 
======================
  
6.5.3 Running a quadrat analysis for different grid arrangements say 4 by 4 
plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques in Harrow")
#now count the points in that fall in a 10 x 10 grid overlaid across the window
plot(quadratcount(BluePlaquesSub.ppp, nx =4, ny = 4),add=T,col="red")

#run the quadrat count
Qcount<-data.frame(quadratcount(BluePlaquesSub.ppp, nx = 4, ny = 4))
#put the results into a data frame
QCountTable <- data.frame(table(Qcount$Freq, exclude=NULL))
#view the data frame
QCountTable
#we don't need the last row, so remove it
QCountTable <- QCountTable[-nrow(QCountTable),]
class(QCountTable[,1])
vect<- as.numeric(levels(QCountTable[,1]))
vect <- vect[1:4]
QCountTable[,1] <- vect
QCountTable$total <- QCountTable[,1]*QCountTable[,2]
#calculate mean
sums <- colSums(QCountTable[,-1])
sums
#and now calculate our mean Poisson parameter (lambda)
lambda <- sums[2]/sums[1]
# Calculate expected 
QCountTable$Pr <- ((lambda^QCountTable[,1])*exp(-lambda))/factorial(QCountTable[,1])
#now calculate the expected counts and save them to the table
QCountTable$Expected <- round(QCountTable$Pr * sums[1],0)
QCountTable

#Compare the frequency distributions of the observed and expected point patterns
plot(c(1,5),c(0,14), type="n", xlab="Number of Blue Plaques (Red=Observed, 
     Blue=Expected)", ylab="Frequency of Occurances")
points(QCountTable$Freq, col="Red", type="o", lwd=3)
points(QCountTable$Expected, col="Blue", type="o", lwd=3)

# remember to change grid to 4 by 4 
teststats <- quadrat.test(BluePlaquesSub.ppp, nx = 4, ny = 4)
teststats

plot(BluePlaquesSub.ppp,pch=16,cex=0.5, main="Blue Plaques in Harrow")
plot(teststats, add=T, col = "red")

==========
  
6.5.4 Ripley’s K  
# used to compare the observed distribution of points with the Poisson random model for a whole range of different distance radii.
K <- Kest(BluePlaquesSub.ppp, correction="border")
plot(K)

6.6 Density-based spatial clustering of applications with noise: DBSCAN
library(raster)
install.packages("fpc")
library(fpc)
library(plyr)
install.packages("OpenStreetMap")
library(OpenStreetMap)

#first check the coordinate reference system of the Harrow spatial polygon:
crs(Borough)

#first extract the points from the spatial points data frame
BluePlaquesSubPoints <- data.frame(BluePlaquesSub@coords[,1:2])
#now run the dbscan analysis
db <- fpc::dbscan(BluePlaquesSubPoints, eps = 700, MinPts = 4)
#now plot the results
plot(db, BluePlaquesSubPoints, main = "DBSCAN Output", frame = F)
plot(Borough, add=T)

# used to find suitable eps value based on the knee in plot
# k is no of nearest neighbours used, use min points
install.packages("dbscan")
library(dbscan)
dbscan::kNNdistplot(BluePlaquesSubPoints, k =  4)
====
@ 500 Meters

# experiment vary eps and min ponts.. say 500 meters

#now run the dbscan analysis
db <- fpc::dbscan(BluePlaquesSubPoints, eps = 500, MinPts = 4)
#now plot the results
plot(db, BluePlaquesSubPoints, main = "DBSCAN Output", frame = F)
plot(Borough, add=T)

# used to find suitable eps value based on the knee in plot
# k is no of nearest neighbours used, use min points

dbscan::kNNdistplot(BluePlaquesSubPoints, k =  4)
===
try 900 meters
db <- fpc::dbscan(BluePlaquesSubPoints, eps = 900, MinPts = 4)
#now plot the results
plot(db, BluePlaquesSubPoints, main = "DBSCAN Output", frame = F)
plot(Borough, add=T)

# used to find suitable eps value based on the knee in plot
# k is no of nearest neighbours used, use min points

dbscan::kNNdistplot(BluePlaquesSubPoints, k =  4)
===
  
#  re run at 700 to continue with the practical
BluePlaquesSubPoints <- data.frame(BluePlaquesSub@coords[,1:2])
#now run the dbscan analysis
db <- fpc::dbscan(BluePlaquesSubPoints, eps = 700, MinPts = 4)
#now plot the results
plot(db, BluePlaquesSubPoints, main = "DBSCAN Output", frame = F)
plot(Borough, add=T)

# used to find suitable eps value based on the knee in plot
# k is no of nearest neighbours used, use min points

dbscan::kNNdistplot(BluePlaquesSubPoints, k =  4)

# lets produce a better map 
library(ggplot2)
# summary of database objects
db
db$cluster

# adding cluster info back into our dataframe
BluePlaquesSubPoints$cluster <- db$cluster
# Next we are going to create some convex hull polygons to wrap around the points
# Use the ddply function in the plyr package to get the convex hull coordinates

chulls <- ddply(BluePlaquesSubPoints, .(cluster), 
                function(df) df[chull(df$coords.x1, df$coords.x2), ])

#note remove 0 as this is not a cluster point - ie points need to be greater than  1 (>1)
chulls <- subset(chulls, cluster>=1)

# Now create a ggplot2 object from our data
dbplot <- ggplot(data=BluePlaquesSubPoints, 
                 aes(coords.x1,coords.x2, colour=cluster, fill=cluster)) 

#add the points in
dbplot <- dbplot + geom_point()

#now the convex hulls
dbplot <- dbplot + geom_polygon(data = chulls, 
                                aes(coords.x1,coords.x2, group=cluster), 
                                alpha = 0.5) 

# now plot, setting the coordinates to scale correctly and as a black and white plot 

dbplot + theme_bw() + coord_equal()

###add a basemap
##First get the bbox in lat long for Harrow
latlong <- "+init=epsg:4326" 
BoroughWGS <-spTransform(Borough, CRS(latlong))
BoroughWGS@bbox

# Now convert the basemap to British National Grid
basemap<-OpenStreetMap(c(51.5530613,-0.4040719),c(51.6405318,-0.2671556), zoom=NULL,"stamen-toner")

install.packages("OpenStreetMap")
library(OpenStreetMap)

