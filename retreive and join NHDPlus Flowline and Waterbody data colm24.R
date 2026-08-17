##set your working directory!

##If you're having trouble with the geometry, try: st_make_valid()

##Uncomment to install!
install.packages("nhdplusTools", dependencies = TRUE)
#install.packages("sf", dependencies = TRUE)
#install.packages("tigris", dependencies = TRUE)
#install.packages("caret")

library(nhdplusTools)
library(sf)
library(dplyr)
library(caret)
##Choose the HU4 subregion to download.
##Visit https://usgs.maps.arcgis.com/apps/MapTools/index.html?appid=41a5c2ca49bd4a83b239450e61022d53
##and then click on an area to see the code for the subregion.
##Make sure you higlight an HU4 subregion! Use that code only.
which_one <- "1207"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1207 <- flowline_waterbody_join

##Let's look at it
#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)












#for layer 1210

which_one <- "1210"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1210 <- flowline_waterbody_join

##Let's look at it
#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)








# layer 1203

which_one <- "1203"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1203 <- flowline_waterbody_join

##Let's look at it
#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)











#layer 1206


which_one <- "1206"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1206 <- flowline_waterbody_join

##Let's look at it
#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)








#layer 1209

which_one <- "1209"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1209 <- flowline_waterbody_join

##Let's look at it
#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)





#layer 1211


which_one <- "1211"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1211 <- flowline_waterbody_join

##Let's look at it
#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)








#layer 1204

which_one <- "1204"
dir.create("data",showWarnings = FALSE)

##Download the NHDPlus HR data
options(timeout=1000000)
nhd_dir <- paste0(getwd(), "/data")
download_nhdplushr(nhd_dir, which_one) 
##Note: You have to be on a very fast internet connection or this will stall out with an error.

##Pull up the flowline data:
flowline <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDFlowline"))

##Let's look at it
#plot(st_geometry(flowline))

##Write to file so you don't lose your work
st_write(flowline, paste0("flowline_", which_one, ".gpkg"), append = FALSE)

##Pull up the waterbody data:
waterbody <- st_zm(st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDWaterbody"))

##Let's look at it
#plot(st_geometry(waterbody))

##Write to file so you don't lose your work
st_write(waterbody, paste0("waterbody_", which_one, ".gpkg"), append = FALSE)

##If you want to see the available layers and databases within the
##geodatabase, you would use this code:
st_layers(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"))

##Import the databases:
DivFracMP <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusDivFracMP", as.is = TRUE)
EROMMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMMA", as.is = TRUE)
EROMQAMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusEROMQAMA", as.is = TRUE)
FlowlineVAA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusFlowlineVAA", as.is = TRUE)
IncrLat <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrLat", as.is = TRUE)
IncrPrecipMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM01", as.is = TRUE)
IncrPrecipMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM02", as.is = TRUE)
IncrPrecipMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM03", as.is = TRUE)
IncrPrecipMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM04", as.is = TRUE)
IncrPrecipMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM05", as.is = TRUE)
IncrPrecipMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM06", as.is = TRUE)
IncrPrecipMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM07", as.is = TRUE)
IncrPrecipMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM08", as.is = TRUE)
IncrPrecipMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM09", as.is = TRUE)
IncrPrecipMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM10", as.is = TRUE)
IncrPrecipMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM11", as.is = TRUE)
IncrPrecipMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrPrecipMM12", as.is = TRUE)
IncrROMA <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrROMA", as.is = TRUE)
IncrTempMM01 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM01", as.is = TRUE)
IncrTempMM02 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM02", as.is = TRUE)
IncrTempMM03 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM03", as.is = TRUE)
IncrTempMM04 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM04", as.is = TRUE)
IncrTempMM05 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM05", as.is = TRUE)
IncrTempMM06 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM06", as.is = TRUE)
IncrTempMM07 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM07", as.is = TRUE)
IncrTempMM08 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM08", as.is = TRUE)
IncrTempMM09 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM09", as.is = TRUE)
IncrTempMM10 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM10", as.is = TRUE)
IncrTempMM11 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM11", as.is = TRUE)
IncrTempMM12 <- st_read(paste0(getwd(), "/data/", substr(which_one, 1, 2), "/NHDPLUS_H_", which_one, "_HU4_GDB.gdb"), layer = "NHDPlusIncrTempMM12", as.is = TRUE)

##Now merge the databases with NHDFlowline
flowline_merge1 <- merge(flowline, DivFracMP, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge2 <- merge(flowline_merge1, EROMMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge3 <- merge(flowline_merge2, EROMQAMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge4 <- merge(flowline_merge3, FlowlineVAA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge5 <- merge(flowline_merge4, IncrLat, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge6 <- merge(flowline_merge5, IncrPrecipMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge7 <- merge(flowline_merge6, IncrPrecipMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge8 <- merge(flowline_merge7, IncrPrecipMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge9 <- merge(flowline_merge8, IncrPrecipMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge10 <- merge(flowline_merge9, IncrPrecipMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge11 <- merge(flowline_merge10, IncrPrecipMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge12 <- merge(flowline_merge11, IncrPrecipMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge13 <- merge(flowline_merge12, IncrPrecipMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge14 <- merge(flowline_merge13, IncrPrecipMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge15 <- merge(flowline_merge14, IncrPrecipMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge16 <- merge(flowline_merge15, IncrPrecipMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge17 <- merge(flowline_merge16, IncrPrecipMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge18 <- merge(flowline_merge17, IncrROMA, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge19 <- merge(flowline_merge18, IncrTempMM01, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge20 <- merge(flowline_merge19, IncrTempMM02, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge21 <- merge(flowline_merge20, IncrTempMM03, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge22 <- merge(flowline_merge21, IncrTempMM04, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge23 <- merge(flowline_merge22, IncrTempMM05, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge24 <- merge(flowline_merge23, IncrTempMM06, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge25 <- merge(flowline_merge24, IncrTempMM07, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge26 <- merge(flowline_merge25, IncrTempMM08, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge27 <- merge(flowline_merge26, IncrTempMM09, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge28 <- merge(flowline_merge27, IncrTempMM10, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge29 <- merge(flowline_merge28, IncrTempMM11, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)
flowline_merge30 <- merge(flowline_merge29, IncrTempMM12, by.x = "NHDPlusID", by.y = "NHDPlusID", all.x = TRUE)

##Write to file so you don't lose your work
st_write(flowline_merge30, paste0("flowline_", which_one, "_merged.gpkg"), append = FALSE)

##Transform flowline and waterbody to a geographic coordinate system (optional)
##In our case, we will use:
##UTM zone 14 North (EPSG code 26914)
##This projection uses meters as the units. This is important!
##Best to use a projection that has meters as units.
##Projections are beyond the scope of this tutorial, but you can find the EPSG code
##for your projection by starting here: https://guides.library.duke.edu/r-geospatial/CRS
##and clicking on the tab "EPSG codes for CRS's"
##Anyway, back to our example. 
##We are transforming our data into UTM zone 14 North (EPSG code 26914)
flowline_transform <- st_transform(flowline_merge30, 26914)
waterbody_transform <- st_transform(waterbody, 26914)

##But the NHDFlowline data is only found along one-dimensional lines that go through 
##the centers of the streams!
##Let's buffer the NHDFlowline data to 100 meters to encompass the stream channel
##and the floodplain. You could instead use a different buffering distance if desired.
flowline_transform_buffer <- st_buffer(flowline_transform, dist = 100)

##Let's look at it
#plot(st_geometry(flowline_transform_buffer))

##Write to file so you don't lose your work
st_write(flowline_transform_buffer, paste0("flowline_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Now let's buffer the waterbodies (although this is optional since they're already
##two-dimensional polygons)
waterbody_transform_buffer <- st_buffer(waterbody_transform, dist = 100)

##Let's look at it
#plot(st_geometry(waterbody_transform_buffer))

##Write to file so you don't lose your work
st_write(waterbody_transform_buffer, paste0("waterbody_transform_buffer_", which_one, ".gpkg"), append = FALSE)

##Next we will join the waterbody geometry to the merged shape file (this is optional).
##We will use the buffered data.
colnames(waterbody_transform_buffer)[which(colnames(waterbody_transform_buffer) == "geom")] <- "geometry"
st_geometry(waterbody_transform_buffer) <- "geometry"
coladd1 <- setdiff(colnames(flowline_transform_buffer), colnames(waterbody_transform_buffer))
waterbody_coladd <- matrix(NA, nrow = nrow(waterbody_transform_buffer), ncol = length(coladd1))
colnames(waterbody_coladd) <- coladd1
waterbody2 <- cbind(waterbody_coladd, waterbody_transform_buffer)
coladd2 <- setdiff(colnames(waterbody_transform_buffer), colnames(flowline_transform_buffer))
flowline_coladd <- matrix(NA, nrow = nrow(flowline_transform_buffer), ncol = length(coladd2))
colnames(flowline_coladd) <- coladd2
flowline2 <- cbind(flowline_coladd, flowline_transform_buffer)
flowline2 <- flowline2[,colnames(waterbody2)]
flowline_waterbody_join <- rbind(flowline2, waterbody2)
fwj1204 <- flowline_waterbody_join


#plot(st_geometry(flowline_waterbody_join))

##Write to file so you don't lose your work
st_write(flowline_waterbody_join, paste0("flowline_waterbody_join_", which_one, ".gpkg"), append = FALSE)
#########################
#fwj1 <- rbind(fwj1204,fwj1211)
#fwj2 <- rbind(fwj1, fwj1209)
#fwj3 <- rbind(fwj2, fwj1206)
#fwj4 <- (fwj3, fwj1203)
#fwj5 <- (fwj4, fwj1210)
#fwj6 <- (fwj5, fwj1207)

# List of GeoPackage objects in your R workspace
#gpkg_objects <- list(fwj1203,fwj1204,fwj1206,fwj1207,fwj1209,fwj1210,fwj1211)
# Replace gpkg_object1, gpkg_object2, etc., with the actual objects in your workspace

# Initialize an empty list to store the data frames
#data_list <- list()

# Extract the data frames from each GeoPackage object and store them in the list
#for (obj in gpkg_objects) {
  #data <- st_read(obj)
 # data_list <- c(data_list, list(data))
#}

# Combine the data frames into a single data frame
#merged_data <- do.call(rbind, data_list)

# Write the merged data frame to a new GeoPackage file
#st_write(merged_data, "flowline_waterbodies.gpkg", layer = "merged_layer", driver = "GPKG")
############################

fwj <- rbind(fwj1203,fwj1204,fwj1206,fwj1207,fwj1209,fwj1210,fwj1211)



st_write(fwj, "flowline_waterbodies.gpkg", append = FALSE)

fwj <- st_read("flowline_waterbodies.gpkg")

hydrovar1 <-  subset(fwj, select = 88:95)
hydrovar2 <- subset(fwj, select = 209)
hydrovartot <- cbind(hydrovar1,hydrovar2)

# Remove the "geom" column
hydro.data <- as.data.frame(hydrovartot)
hydro.spat <- subset(hydro.data, select = -geom.1)
hydro.vars <- subset(hydro.spat, select = -geom)
hydro.spat.sf <- subset(hydrovartot, select = -geom.1)
#correlation using only the full objects
hydro.cor <- cor(hydro.vars, use = "complete.obs")
print(hydro.cor)
write.csv(hydro.cor, file = "hydrology_cor_result.csv")

#non correlated layers subseted from spatial data via removal of correlated vars
var.1 <- subset(hydro.spat.sf , select = -2)
var.1 <- subset(var.1, select = -3)
var.1 <- subset(var.1, select = -3)









