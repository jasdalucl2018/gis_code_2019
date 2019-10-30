# Code to re-produce ARCGIS & QGIS Maps

#.Load Libraries
# 5.7.1 Static map
##Load all our data
library(sf)
install.packages("tmap")
library(tmap)
library(tmaptools)
library(plyr)
library(tidyverse)

tmap_mode("plot")

OSM <- st_read("N:/GIS/wk5/greater-london-latest-free/gis_osm_pois_a_free_1.shp")

#Read in London Borough Data
Londonborough <- st_read("N:/GIS/wk1/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp")

#Read AirBnB Data 
Airbnb <- read_csv("N:/GIS/wk5/listings.csv/listings.csv")


#Read world cities data - note thge cvs file doesnt work so try shp only 


Worldcities <- st_read("N:/GIS/wk5/Cities/World_Cities.shp")



####  error at this point 

# Reading UK Outline data 
UK_outline <- st_read("N:/GIS/wk5/UK Outline/gadm36_GBR_0.shp")

# plot xy data
Airbnb <- st_as_sf(Airbnb, coords = c("longitude", "latitude"), 
                   crs = 4326)

# reproject
OSM <- st_transform(OSM, 27700)
Worldcities <- st_transform(Worldcities, 27700)
UK_outline <- st_transform(UK_outline, 27700)
Airbnb <- st_transform(Airbnb, 27700)


#####################################################

# we don't need to reproject Londonborough, but it 
# doesn't have a CRS..you could also use set_crs
# it needs to have one for the next step
Londonborough<- st_transform(Londonborough, 27700)

#select Entire Home/apt only only
OSM <- OSM[OSM$fclass == 'hotel',]
Airbnb <- Airbnb[Airbnb$room_type == 'Entire home/apt' &
                   Airbnb$availability_365=='365',]

# make a function for the join
# functions are covered in practical 7
# but see if you can work out what is going on
# hint all you have to do is replace data1 and data2
# with the data you want to use

Joinfun <- function(data1, data2) {
  # join OSM and London boroughs
  joined <- st_join(data1, data2, join = st_within)
  
  # count the number of hotels per borough
  countno <- as.data.frame(plyr::count(joined$GSS_CODE))
  
  # join the count back to the borough layer
  counted <-left_join(data2, countno, by=c("GSS_CODE"="x"))
  
  return(counted)
}

# use the function for hotels
Hotels <- Joinfun(OSM, Londonborough)

# then for airbnb
Airbnb <- Joinfun(Airbnb, Londonborough)

Worldcities2 <- Worldcities[Worldcities$CNTRY_NAME=='United Kingdom'&
                              Worldcities$CITY_NAME=='Birmingham'|
                              Worldcities$CITY_NAME=='London'|
                              Worldcities$CITY_NAME=='Edinburgh',]

newbb <- c(xmin=-296000, ymin=5408, xmax=655696, ymax=1000000)
UK_outlinecrop=st_crop(UK_outline$geometry, newbb)

# now try to arrange the plots with tmap
breaks = c(0, 5, 12, 26, 57, 286) 

#change the column name from freq for the legend
colnames(Hotels)[colnames(Hotels)=="freq"] <- "Accom count"

# plot each map
tm1 <- tm_shape(Hotels) + 
  tm_polygons("Accom count", breaks=breaks)+
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(a)", position=c(0,0.85), size=1.5)

tm2 <- tm_shape(Airbnb) + 
  tm_polygons("freq", breaks=breaks) + 
  tm_legend(show=FALSE)+
  tm_layout(frame=FALSE)+
  tm_credits("(b)", position=c(0,0.85), size=1.5)

tm3 <- tm_shape(UK_outlinecrop)+ 
  tm_polygons(col="darkslategray1")+
  tm_layout(frame=FALSE)+
  tm_shape(Worldcities2) +
  tm_symbols(col = "red", scale = .5)+
  tm_text("CITY_NAME", xmod=-1, ymod=-0.5)

legend <- tm_shape(Hotels) +
  tm_polygons("Accom count") +
  tm_scale_bar(position=c(0.2,0.04), text.size=0.6)+
  tm_compass(north=0, position=c(0.65,0.6))+
  tm_layout(legend.only = TRUE, legend.position=c(0.2,0.25),asp=0.1)+
  tm_credits("(c) OpenStreetMap contrbutors and Air b n b", position=c(0.0,0.0))

t=tmap_arrange(tm1, tm2, tm3, legend, ncol=2)

t

We can also arrage our maps using the grid package.
library(grid)
grid.newpage()

pushViewport(viewport(layout=grid.layout(2,2)))
print(tm1, vp=viewport(layout.pos.col=1, layout.pos.row=1, height=5))
print(tm2, vp=viewport(layout.pos.col=2, layout.pos.row=1, height=5))
print(tm3, vp=viewport(layout.pos.col=1, layout.pos.row=2, height=5))
print(legend, vp=viewport(layout.pos.col=2, layout.pos.row=2, height=5))

5.7.2 Export
So how do we output our map then.
tmap_save(t, 'hotelsandairbnbR.png')
5.7.3 Basic interactive map
But could we not also make an interactive map like we did in practical 2?
  tmap_mode("view")

tm_shape(Airbnb) + 
  tm_polygons("freq", breaks=breaks) 

+???
freq
0 to 5
5 to 12
12 to 26
26 to 57
57 to 286
Missing
Leaflet | Tiles © Esri - Esri, DeLorme, NAVTEQ
5.7.4 Advanced interactive map
But let's take it a bit further so we can select our layers on an interactive map..
# library for pop up boxes
library(leafpop)
library(leaflet)

#join data
ti<-st_join(Airbnb, Hotels, join = st_equals)
ti<-st_transform(ti,crs = 4326)

#remove the geometry for our pop up boxes to avoid
#the geometry field 
ti2 <- ti
st_geometry(ti2) <- NULL
popairbnb <- popupTable(ti2, zcol=c("NAME.x", "GSS_CODE.x", "freq"))
pophotels <- popupTable(ti2, zcol=c("NAME.x", "GSS_CODE.x", "Accom count"))

# set the colour palettes using our previously defined breaks
# the colour palettes are the same using the same breaks
# but different data
pal <- colorBin(palette = "YlOrRd", domain=ti2$freq, bins=breaks)
pal2 <- colorBin(palette = "YlOrRd", domain=ti2$`Accom count`, bins=breaks)

map<- leaflet(ti) %>%
  
  # add basemap options
  addTiles(group = "OSM (default)") %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addProviderTiles(providers$CartoDB.Positron, group = "CartoDB")%>%
  
  #add our polygons, linking to the tables we just made
  addPolygons(color="white", 
              weight = 2,
              opacity = 1,
              dashArray = "3",
              popup = popairbnb,
              fillOpacity = 0.7,
              fillColor = ~pal(freq),
              group = "Airbnb")%>%
  
  addPolygons(fillColor = ~pal(`Accom count`), 
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              popup = pophotels,
              fillOpacity = 0.7,group = "Hotels")%>%
  # add a legend
  addLegend(pal = pal2, values = ~`Accom count`, group = c("Airbnb","Hotel"), 
            position ="bottomleft") %>%
  # specify layers control
  addLayersControl(
    baseGroups = c("OSM (default)", "Toner", "Toner Lite", "CartoDB"),
    overlayGroups = c("Airbnb", "Hotels"),
    options = layersControlOptions(collapsed = FALSE)
  )

# plot the map
map

+???
Top of Form
OSM (default)
Toner
Toner Lite
CartoDB
Airbnb
Hotels
Bottom of Form
Accom count
0 - 5
5 - 12
12 - 26
26 - 57
57 - 286
NA
Leaflet | © OpenStreetMap contributors, CC-BY-SA
If you want to explore Leaflet more have a look at this website
5.8 Bad maps
What makes a bad map then. and what should you avoid:
  .	Poor labeling - don't present something as an output with the file name (e.g. layer_1_osm) in the legend - name your layers properly, it's really easy to do and makes a big difference to the quality of the map.
.	No legend
.	Screenshot of the map - export it properly, we've been doing this a while and can tell
.	Change the values in the legend . what is aesthetically more pleasing 31.99999 or 32?. Make it as easy as possible to interpret your map.
.	Too much data presented on one map - be selective or plot multiple maps
.	Presented data is too small or too big - be critical about what you produce, it should be easy to read and understand
.	A map or figure without enough detail - A reader should be able to understand a map or figure using the graphic in the figure/map and the caption alone! A long caption is fine assuming it's all relevant information.
For more cartography ideas/advice have a look at this blog post, consult axis map catography guide and check out the data is beautiful reddit.
5.9 Feedback
Was anything that we explained unclear this week or was something really clear.let us know here. It's anonymous and we'll use the responses to clear any issues up in the future / adapt the material.

######################################################




