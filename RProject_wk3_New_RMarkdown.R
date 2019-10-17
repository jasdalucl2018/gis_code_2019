jan<-raster("N:/GIS/wk3/wc2.0_5m_tmin.zip/wc2.0_5m_tmin_01.tif")
library("raster", lib.loc="N:/Development/R 3.51/Packages")
jan<-raster("N:/GIS/wk3/RProject_wk3/wc2.0_5m_tavg_01.tif")
        
            
install.packages("raster")
install.packages("raster")
#Practical 3
#Unzip data and Loal
library(raster)
jan<-raster("N:/GIS/wk3/RProject_wk3/wc2.0_5m_tavg_01.tif")
#Practical 3
#Unzip data and Loal
library(raster)
jan<-raster("N:/GIS/wk3/wc2.0_5m_tavg.zip/wc2.0_5m_tavg_01.tif")
jan<-raster("wc2.0_5m_tavg_01.tif")
#Practical 3
#Unzip data and Loal
library(raster)
jan<-raster("N:/GIS/wk3/RProject_wk3/wc2.0_5m_tavg_01.tif")
jan<-raster("N:/GIS/wk3/RProject_wk3/wc2.0_5m_tavg_01.tif")
# have a look at the raster layer jan
jan
#the plot the map
plot(jan)
#using Robinson Projection
library(sf)
# set the proj 4 to a new variable
newproj<-"+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
# get the jan raster and give it the new proj4
pr1 <- projectRaster(jan, crs=newproj)
plot(pr1)

#### 3.4.1 Projection
#3.4.1.5 5.	A better and more efficient way is to firstly list all the files stored within our directory
# look in our folder, find the files that end with .tif and
# provide their full filenames
listfiles <- list.files("N:/GIS/wk3/RProject_wk3", ".tif", full.names = TRUE)
#have a look at the file names
listfiles
#have a look at the file names
listfiles

#### 3.4.1 Projection
#3.4.1.5 5.	A better and more efficient way is to firstly list all the files stored within our directory
# look in our folder, find the files that end with .tif and
# provide their full filenames

listfiles <- list.files("N:/GIS/wk3/RProject_wk3/", ".tif", full.names = TRUE)
#have a look at the file names

listfiles

# 6.	Then load all of the data straight into a raster stack. A raster stack is a collection of raster layers with the same spatial extent and resolution.
worldclimtemp <- stack(listfiles)
#have a look at the raster stack
worldclimtemp
#7.	To access single layers within the stack:
# access the january layer
worldclimtemp[[1]]
# access the feb layer
worldclimtemp[[2]]
month <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
names(worldclimtemp) <- month
#access january data by name and not number
worldclimtemp$Jan
worldclimtemp$Aug
site <- c("Brisbane", "Melbourne", "Perth", "Sydney", "Broome", "Darwin", "Orange",
          "Bunbury", "Cairns", "Adelaide", "Gold Coast", "Canberra", "Newcastle",
          "Wollongong", "Logan City" )
lon <- c(153.03, 144.96, 115.86, 151.21, 122.23, 130.84, 149.10, 115.64, 145.77,
         138.6, 153.43, 149.13, 151.78, 150.89, 153.12)
lat <- c(-27.47, -37.91, -31.95, -33.87, 17.96, -12.46, -33.28, -33.33, -16.92,
         -34.93, -28, -35.28, -32.93, -34.42, -27.64)
samples <- data.frame(site, lon, lat, row.names="site")
AUcitytemp<- raster::extract(worldclimtemp, samples)
#11.	Add the city names to the rows of AUcitytemp
row.names(AUcitytemp)<-site
Perthtemp <- subset(AUcitytemp, rownames(AUcitytemp) == "Perth")
Perthtemp <- AUcitytemp[3,]
#3.5.2 we can now make a histogram of Perth Data
hist(Perthtemp)
userbreak<-c(8,10,12,14,16,18,20,22,24,26)
hist(Perthtemp,
     breaks=userbreak,
     col="red",
     main="Histogram of Perth Temperature",
     xlab="Temperature",
     ylab="Frequency")

hist(Perthtemp,
     breaks=userbreak,
     col="blue",
     main="Histogram of Perth Temperature",
     xlab="Temperature",
     ylab="Frequency")

histinfo<-hist(Perthtemp)
histinfo
library(sf)
st_layers("N:/GIS/wk3/gadm36_AUS.gpkg")
Ausoutline <- st_read("N:/GIS/wk3/gadm36_AUS.gpkg", layer='gadm36_AUS_0')
## check the layer by plotting the geometry
plot(Ausoutline$geom)

#set our map extent to the outline of Australia then crop our WorldClim dataset to it
Ausarea <- extent(Ausoutline)

# check the extent
Ausarea
## class      : Extent 
## xmin       : 112.9211 
## xmax       : 159.1092 
## ymin       : -55.11694 
## ymax       : -9.142176

# now crop our temp data to the extent
Austemp <- crop(worldclimtemp, Ausoutline)

# plot the output
Austemp

#need to plot/obtain raster data wthin the outline of the shape 
exactAus=mask(Austemp, Ausoutline, na.rm=TRUE)

#also possible to run this using the original worldclimatetemp
#3.5.2.22.	Let's re-compute our histogram for Australia in March. We could just use hist like we have done before

hist(exactAus[[3]], col="red", main ="April temperature")

#============================
#3.5.4 Histogram with ggplot
#step 1 convert raster information into a data.frame

alldf=as.data.frame(exactAus)
library(ggplot2)

# set up the basic histogram
gghist <- ggplot(alldf, 
                 aes(x=Mar)) + 
  geom_histogram(color="black", 
                 fill="white")+
  labs(title="Ggplot2 histogram of Australian March temperatures", 
       x="Temperature", 
       y="Frequency")

# add a vertical line to the hisogram showing mean tempearture
gghist + geom_vline(aes(xintercept=mean(Mar, 
                                        na.rm=TRUE)),
                    color="blue", 
                    linetype="dashed", 
                    size=1)+
  theme(plot.title = element_text(hjust = 0.5))

#plotting multiple months of temperature data on the same histogram
#24.	As we did in practical 2, we need to put our variaible (months) into a one coloumn using melt. 
#We will do this based on the names of our coloumns in alldf.

library(reshape2)
squishdata <- melt(alldf, measure.vars=names(alldf))

# subset the data, selecting two months
twomonths<-subset(squishdata, variable=="Jan" | variable=="Jun")

#calculate mean values for the months selected - make sure the right libraries are installed

library(plyr)
library(dplyr)

meantwomonths <- ddply(twomonths, 
                       "variable", 
                       summarise, 
                       grp.mean=mean(value, na.rm=TRUE))

colnames(meantwomonths)[colnames(meantwomonths)=="variable"] <- "Month"

#check that the data has been called in correctly

head(meantwomonths)

# 27.	Select the colour (here color in the code - US english) and fill based on the variable (which is our month). 
#The intercept is the mean we just calculated, with the lines also based on the coloumn variable.

colnames(twomonths)[colnames(twomonths)=="variable"] <- "Month"

#the re run the histogram using ggplot

ggplot(twomonths, aes(x=value, color=Month, fill=Month)) +
  geom_histogram(position="identity", alpha=0.5)+
  geom_vline(data=meantwomonths, 
             aes(xintercept=grp.mean, 
                 color=Month),
             linetype="dashed")+
  labs(title="Ggplot2 histogram of Australian Jan and Jun
       temperatures",
       x="Temperature",
       y="Frequency")+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5))

# Remove all NAs
data_complete_cases <- squishdata[complete.cases(squishdata), ]

# How many rows are left
dim(data_complete_cases)



# How many were there to start with
dim(squishdata)



# Plot faceted histogram
ggplot(data_complete_cases, aes(x=value, na.rm=TRUE, color=variable))+
  geom_histogram(color="black", binwidth = 5)+
  labs(title="Ggplot2 faceted histogram of Australian temperatures", 
       x="Temperature",
       y="Frequency")+
  facet_grid(variable ~ .)+
  theme(plot.title = element_text(hjust = 0.5))

#lets make an interactive histogram using plotly

library(plotly)

# split the data for plotly based on month
jan<-subset(squishdata, variable=="Jan", na.rm=TRUE)
jun<-subset(squishdata, variable=="Jun", na.rm=TRUE)

# give axis titles
x <- list (title = "Temperature")
y <- list (title = "Frequency")

# set the bin width
xbinsno<-list(start=0, end=40, size = 2.5)

# plot the histogram calling all the variables we just set
ihist<-plot_ly(alpha = 0.6) %>%
  add_histogram(x = jan$value,
                xbins=xbinsno, name="January") %>%
  add_histogram(x = jun$value,
                xbins=xbinsno, name="June") %>% 
  layout(barmode = "overlay", xaxis=x, yaxis=y)

#remember to plot the histogrammme
ihist

# 3.5.4.30 looking at other descriptive statistics
#remember to load dplyr library

library(dplyr)

# mean per month
meanofall <- ddply(squishdata, "variable", summarise, grp.mean=mean(value, na.rm=TRUE))

# print the top 1
head(meanofall, n=1)

# standard deviation per month
sdofall <- ddply(squishdata, "variable", summarise, grp.sd=sd(value, na.rm=TRUE))

# maximum per month
maxofall <- ddply(squishdata, "variable", summarise, grp.mx=max(value, na.rm=TRUE))
# minimum per month
minofall <- ddply(squishdata, "variable", summarise, grp.min=min(value, na.rm=TRUE))

# Interquartlie range per month
IQRofall <- ddply(squishdata, "variable", summarise, grp.IQR=IQR(value, na.rm=TRUE))

# perhaps you want to store multiple outputs in one list..
lotsofthem <- ddply(squishdata, "variable", 
                    summarise,grp.min=min(value,na.rm=TRUE),
                    grp.mx=max(value, na.rm=TRUE))

# or you want to know the mean (or some other stat) for the whole year as opposed to each month...
meanwholeyear=mean(squishdata$value, na.rm=TRUE)


#3.6 interpolation using raster data
# in this exercise we will take Australian cities as the sample points 
# and estimate data between them using interpolation 
samplestemp<-cbind(AUcitytemp, samples)

#need to tell R that points are spatial points
samplestemp<-as.data.frame(samplestemp)


spatialpt <- SpatialPoints(samplestemp[,c('lon','lat')], proj4string = crs(worldclimtemp))
spatialpt <- SpatialPointsDataFrame(spatialpt, samplestemp)

#plot australian geometry outline
plot(Ausoutline$geom)

#add spatial data on top
plot(spatialpt, col="red", add=TRUE)

#interpolation  using Inverse Distance Weighting (IDW)
# lets get some more meaningful results - run calculations

spatialpt <- st_as_sf(spatialpt)
spatialpt <- st_transform(spatialpt, 3112)
spatialpt<-as(spatialpt, 'Spatial')

Ausoutline<-st_transform(Ausoutline, 3112)
Ausoutline2<-as(Ausoutline, 'Spatial')

#create an empty grid so that cell sie is the spatial resolution
emptygrd <- as.data.frame(spsample(Ausoutline2, n=1000, type="regular", cellsize=200000))

names(emptygrd) <- c("X", "Y")

coordinates(emptygrd) <- c("X", "Y")

gridded(emptygrd) <- TRUE  # Create SpatialPixel object
fullgrid(emptygrd) <- TRUE  # Create SpatialGrid object

# Add the projection to the grid
proj4string(emptygrd) <- proj4string(spatialpt)

# Interpolate the grid cells using a power value of 2 

install.packages("RInside")
library(RInside)
install.packages("gstat")
library(gstat)

interpolate <- gstat::idw(Jan ~ 1, spatialpt, newdata=emptygrd, idp=2.0)


# Convert output to raster object 
ras <- raster(interpolate)

# Clip the raster to Australia outline
rasmask <- mask(ras, Ausoutline)

# Plot the raster
plot(rasmask)

#=============================================
#3.7 AutoData dowloading from WorldClimate and GADM using the getData function 

#WorldClim data has a scale factor of 10 when using getData!
tmean_auto <- getData("worldclim", res=10, var="tmean")
tmean_auto <- tmean_auto/10

# and for GADM
Aus_auto <- getData('GADM', country="AUS", level=0)

#============================================
#3.8 Advanced Analysis 

#.... adding R chunks

install.packages("plotly")
library(plotly)
install.packages("weathermetrics")
library(weathermetrics)
install.packages("flexdashboard")
library(flexdashboard)


```{r}

---
library(plotly)
library(reshape2)
library(raster)
library(weathermetrics)

GB_auto <- raster::getData('GADM', 
                           country="GBR", 
                           level=0, 
                           #set the path to store your data in
                           path='N:/GIS/wk3/', 
                           download=TRUE)

GBclim <- raster::getData("worldclim", 
                          res=5, 
                          var="tmean",
                          #set the path to store your data in
                          path='N:/GIS/wk3/', 
                          download=TRUE)

month <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

names(GBclim) <- month
GBtemp <- crop(GBclim, GB_auto)
exactGB <- mask(GBtemp, GB_auto)

#WorldClim data has a scale factor of 10!
exactGB <- exactGB/10

alldf=as.data.frame(exactGB)
squishdata <- melt(alldf, measure.vars=names(alldf))

# split the data for plotly based on month
jan<-subset(squishdata, variable=="Jan", na.rm=TRUE)
jun<-subset(squishdata, variable=="Jun", na.rm=TRUE)

# give axis titles
x <- list (title = "Temperature")
y <- list (title = "Frequency")

# set the bin width
xbinsno<-list(start=-5, end=20, size = 2.5)

# plot the histogram calling all the variables we just set
ihist<-plot_ly(alpha = 0.6) %>%
        add_histogram(x = jan$value,
        xbins=xbinsno, name="January") %>%
        add_histogram(x = jun$value,
        xbins=xbinsno, name="June") %>% 
        layout(barmode = "overlay", xaxis=x, yaxis=y)

ihist

```
#4.12.2 Flexdashboard
title: "Untitled"
output:
  flexdashboard::flex_dashboard:
  runtime: flexdashboard
  
Column {data-width=600}
-------------------------------------
### Chart 1

```{r}
---
library(plotly)
library(reshape2)
library(raster)
library(weathermetrics)

GB_auto <- raster::getData('GADM', 
                           country="GBR", 
                           level=0, 
                           #set the path to store your data in
                           path='N:/GIS/wk3/', 
                           download=TRUE)

GBclim <- raster::getData("worldclim", 
                          res=5, 
                          var="tmean",
                          #set the path to store your data in
                          path='N:/GIS/wk3/', 
                          download=TRUE)

month <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

names(GBclim) <- month
GBtemp <- crop(GBclim, GB_auto)
exactGB <- mask(GBtemp, GB_auto)

#WorldClim data has a scale factor of 10!
exactGB <- exactGB/10

alldf=as.data.frame(exactGB)
squishdata <- melt(alldf, measure.vars=names(alldf))

# split the data for plotly based on month
jan<-subset(squishdata, variable=="Jan", na.rm=TRUE)
jun<-subset(squishdata, variable=="Jun", na.rm=TRUE)

# give axis titles
x <- list (title = "Temperature")
y <- list (title = "Frequency")

# set the bin width
xbinsno<-list(start=-5, end=20, size = 2.5)

# plot the histogram calling all the variables we just set
ihist<-plot_ly(alpha = 0.6) %>%
        add_histogram(x = jan$value,
        xbins=xbinsno, name="January") %>%
        add_histogram(x = jun$value,
        xbins=xbinsno, name="June") %>% 
        layout(barmode = "overlay", xaxis=x, yaxis=y)

ihist


```
Column {data-width=400}
-------------------------------------

### Chart 3

```{r}

```


knitr::opts_chunk$set(echo=TRUE)
