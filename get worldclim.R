##Set working directory!

#install.packages("raster")
#install.packages("devtools")
#install.packages("tigris")
#library("devtools")
#install_github("kapitzas/WorldClimTiles")
#install.packages("sf")
#install.packages("terra")

##load the libraries

library(raster)
require("WorldClimTiles")
library(WorldClimTiles)
library(tigris)
library(sf)
library(terra)

##get an outline of the US states

usa_states <- states(cb = TRUE)

##subset it to TX

tx <- usa_states[which(usa_states$NAME == "Texas"),]

##transform it to the projection being used by the much larger
##bioclim raster layers (lat/long WGS84)

tx2 <- st_transform(tx, crs = 4326)

##change the format of the R object from "sf" to "sp"
##these are two different spatial data formats, kind of like
##VHS versus Betamax for cassette tapes. Anyway, the "tile_name"
##function requires "sp" format for the R objects rather than "sf."

tx3 <- as_Spatial(tx2)

##now use the "tile_name" function to find the worldclim tiles that
##overlap with Texas

tilenames <- tile_name(tx3)

##now get the worldclim bioclimatic data for the tiles you found above

tiles <- tile_get(tilenames, "bio")

##merge the data for the different tiles together

merged <- tile_merge(tiles)

##now we will crop the bioclimatic data to only Texas.
##for this, we go back to using the R object tx2, because
##the "crop" function of the terra package requires the "sf" file format.

merged.tx <- terra::crop(merged, tx2)

##let's look at the first bioclimatic variable as an example:

plot(merged.tx[[1]])

##you can see it's rectangular! Not yet the shape of Texas
##(although the proper spatial extent). 

##We need to "mask" the
##data to snip out the bits that shouldn't be there within the spatial extent.

merged.tx.mask <- terra::mask(merged.tx, tx2)

##now let's plot it:

plot(merged.tx.mask)

##it worked!

##now let's save each raster layer from the raster brick
##out to a separate file in the ascii raster format

## Get the number of raster layers in the raster object
##(it's a raster brick, which contains multiple rasters -- each
##one is a separate bioclimatic layer)

num_layers <- length(as.list(merged.tx.mask))

## Iterate over each layer
for (layer in 1:num_layers) {
  ##Extract the layer
  layer_data <- merged.tx.mask[[layer]]
  
  ##Convert the layer to an ASCII raster
  ascii_raster <- terra::writeRaster(layer_data, 
                                     filename = paste0
                                     ("layer_tx_", layer, ".asc"), 
                                     NAflag = -9999, overwrite = TRUE)
  
  ##Print a message indicating the saved file
  print(paste0("Layer ", layer, " saved as ASCII file."))
}

##done!