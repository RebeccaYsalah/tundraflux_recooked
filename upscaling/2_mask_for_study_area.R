# creates masks for the study area
# contact: matti.kummu@aalto.fi

library(terra)
library(tidyverse)


### ----------------------------------------------------------------------------
# CHANGES: Setting working directory and find data
library(here)
source(here("config.R"))
### ----------------------------------------------------------------------------



### ----------------------------------------------------------------------------
# CHANGES: Use our dirs instead to find fies

# set working directory the path that this script is located in
# setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# soil
# https://apgc.awi.de/collection/ncscdv2 (Northern Circumpolar Soil Carbon Database, Circum-Arctic Region, geotiff-files -> 1.0 deg, geotiff, circumpolar NCSCDv2)
# https://apgc.awi.de/dataset/ncscdv2-circumarctic-geotiff/resource/92c980f8-ac16-4795-bc36-f91273d65b10

# NCSCDv2_Circumpolar_WGS84_SOCC30_1deg.tif  -> SOCC30_circumpolar_crs3995.tif (name in the script)

#SOC_crs3995 <- rast("data_in/SOCC30_circumpolar_crs3995.tif")
SOC_crs3995 <- rast(file.path(data_dir, "SOCC30_circumpolar_crs3995.tif")) # we don't have that file. Would have to download it from SoilGrids and do some preprocessing that is not given.

# set soil to 3995
crs3995 <- "EPSG:3995"
SOC_crs3995 <- project(SOC_crs3995, crs3995, method = "bilinear")
# ------------------------------------------------------------------------------

# permafrost area
# https://apgc.awi.de/dataset/pex/resource/18fe2e48-fe60-4b0b-9469-7cb361542f61

pf_prob_crs3995 <-  project(rast(file.path(data_dir, "UiO_PEX_PERPROB_5.0_20181128_2000_2016_NH/UiO_PEX_PERPROB_5.0_20181128_2000_2016_NH.tif")), 
                            crs3995)
# extend soil extent

SOC_crs3995_ext <- extend(SOC_crs3995,pf_prob_crs3995)
writeRaster(x = SOC_crs3995_ext, filename = file.path(output_data_dir,"SOC_crs3995_ext.tif"), gdal="COMPRESS=LZW",overwrite=T) # CHANGED to match our structure


#-------------------------------------------------------------------------------
# CHANGES: line doesnt work. Claude thinks its because of "project"
# pf_prob_crs3995_soil <-  project(rast(file.path(data_dir,"UiO_PEX_PERPROB_5.0_20181128_2000_2016_NH/UiO_PEX_PERPROB_5.0_20181128_2000_2016_NH.tif")), SOC_crs3995_ext)

pf_prob_crs3995_soil <- resample(
  pf_prob_crs3995,
  SOC_crs3995_ext,
  method   = "bilinear",
  filename = file.path(output_data_dir, "pf_prob_crs3995_soil.tif"),
  gdal     = "COMPRESS=LZW",
  overwrite = TRUE
)

# Plot to see if it makes sense
plot(pf_prob_crs3995_soil, main = "Permafrost probability (resampled to soil grid)")
#-------------------------------------------------------------------------------

pf_prob_crs3995_soil[pf_prob_crs3995_soil>0] = 1
writeRaster(x = pf_prob_crs3995_soil, filename = file.path(output_data_dir, "pf_prob_crs3995.tif"), gdal="COMPRESS=LZW",overwrite=T) # CHANGED to match our structure
pf_prob_crs3995 <- rast(file.path(output_data_dir, "pf_prob_crs3995.tif"))

# land mask

land_mask <- !is.na(rast("data_in/UiO_PEX_PERPROB_5.0_20181128_2000_2016_NH/UiO_PEX_PERPROB_5.0_20181128_2000_2016_NH.tif"))
land_mask_crs3995 <-  project(land_mask, SOC_crs3995_ext)

# tundra mask

# http://137.229.50.172/geodata/arcticAtlasMaster.gdb

maskTundra <- vect("data_in/cp_veg_la_shp/cp_veg_la.shp") %>% 
  project(land_mask_crs3995) %>% 
  terra::rasterize(land_mask_crs3995,"PHYSIOG", na.rm =T) 

# alpine mask
# source: https://onlinelibrary.wiley.com/doi/full/10.1111/ecog.05012
# https://figshare.com/articles/dataset/Global_distribution_and_bioclimatic_characterization_of_alpine_biomes/11710002

zonesAlpine <- vect('data_in/alpine_clusters/alpine_clusters.shp')
r_zonesAlpine <- rasterize(zonesAlpine,SOC_wgs84,field='cluster')
r_zonesAlpine[r_zonesAlpine > 0] <- 10
r_zonesAlpine_crs3995 <- project(x=r_zonesAlpine,SOC_crs3995_ext)

writeRaster(x = r_zonesAlpine_crs3995, filename = "data_out/alpine_zones.tif", gdal="COMPRESS=LZW",overwrite=T)

maskTundraAlpine <- maskAlpine
maskTundraAlpine[maskTundra > 0] = 1
maskTundraAlpine[maskTundraAlpine > 0] = 1

plot(maskTundraAlpine)

writeRaster(x = maskTundraAlpine,
            filename = "data_out/maskTundraAlpine_crsEPSG3995.tif", gdal="COMPRESS=LZW",overwrite=T)

# project to wgs84

maskTundraAlpine_crsWGS84 <- project(maskTundraAlpine, "EPSG:4326")

writeRaster(x = maskTundraAlpine_crsWGS84,
            filename = "data_out/maskTundraAlpine_crsEPSG4326.tif", gdal="COMPRESS=LZW",overwrite=T)


