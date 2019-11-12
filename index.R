rm(list = ls())

library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(htmltools)
library(sf)
library(rgdal)

iDir <- "D:/OneDrive - CGIAR/Dev/mkn_restoration"

study_area <- readOGR(paste0(iDir, "/data/", "aoi.shp"))

primary_schools <- readOGR(paste0(iDir, "/data/", "primary_schools.shp"))

village_boundaries <- readOGR(paste0(iDir, "/data/", "village_boundaries.shp"))

micro_catchments <- readOGR(paste0(iDir, "/data/", "micro_catchments.shp"))

ps_labels <- paste("Primary School: ", primary_schools$Name_of_Sc)
vi_labels <- paste("Village Name: ", village_boundaries$village_n)
mi_labels <- micro_catchments$Subbasin

map.ll <- leaflet() %>% 
  addProviderTiles(providers$Esri.WorldImagery, group = "Esri.WorldImagery (default)") %>% 
  
  addProviderTiles(providers$Esri.WorldStreetMap, group = "Esri.WorldStreetMap") %>% 
  
  addProviderTiles(providers$OpenTopoMap, group = "Esri.WorldShadedRelief") %>% 
  
  addMiniMap(tiles = providers$Esri.NatGeoWorldMap, toggleDisplay = TRUE, 
             position = "bottomright") %>% 
  
  setView(37.322, -1.824, zoom = 12) %>% 
  
  addPolygons(data = study_area, weight = 5, color = "red", fill = FALSE, 
              stroke = TRUE, group = "Study area") %>% 
  
  addCircleMarkers(data = primary_schools, weight = 5, color = "black", opacity = 0.5, 
                   radius = 5, group = "Primary schools", label = ps_labels, 
                   
                   labelOptions = labelOptions(style = list(`font-weight` = "normal", 
                                                            padding = "3px 8px"), textsize = "15px", direction = "auto")) %>% 
  
  addPolygons(data = village_boundaries, weight = 2, color = "yellow", dashArray = "3", 
              fillOpacity = 0.2, group = "Village boundaries", highlight = highlightOptions(weight = 5, 
                                                                                            dashArray = "", fillOpacity = 0, bringToFront = TRUE), label = vi_labels, 
              labelOptions = labelOptions(style = list(`font-weight` = "normal", 
                                                       padding = "3px 8px"), textsize = "15px", direction = "auto")) %>% 
  
  addPolygons(data = micro_catchments, weight = 3, color = "blue", fill = FALSE, stroke = TRUE, group = "Micro-catchments", label = mi_labels, 
              labelOptions = labelOptions(noHide = T, textOnly = TRUE, textsize = "20px", style = list('color' = "red"))) %>% 
  
  addMeasure(position = "bottomleft", primaryLengthUnit = "meters", primaryAreaUnit = "hectares") %>% 
  
  addLayersControl(baseGroups = c("Esri.WorldImagery (default)", "Esri.WorldShadedRelief", "Esri.WorldStreetMap"), 
                   overlayGroups = c("Primary schools", "Study area", "Village boundaries", 
                                     "Micro-catchments"), options = layersControlOptions(collapsed = FALSE))


saveWidget(map.ll, file = paste0(getwd(), "/", "index", 
                                 ".html", sep = ""))
