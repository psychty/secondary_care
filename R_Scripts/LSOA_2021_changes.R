
# lsoa boundary changes

packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)


# This will read in the boundaries (in a geojson format) from Open Geography Portal
lad_boundaries_sf <- st_read('https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_GB_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson') %>% 
  filter(LAD21NM %in% c('Adur', 'Arun', 'Chichester','Crawley','Horsham','Mid Sussex', 'Worthing')) 

lad_boundaries_spdf <- as_Spatial(lad_boundaries_sf, IDs = lad_boundaries_sf$LAD21NM)

# 2011 lsoas 

IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

lsoa_2011_spdf <- geojson_read("https://opendata.arcgis.com/datasets/8bbadffa6ddc493a94078c195a1e293b_0.geojson",  what = "sp") %>%
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_11_summary <- IMD_2019 %>% 
  group_by(LTLA) %>% 
  summarise(Number_of_LSOAs_in_2011 = n())

# 2021

lsoa_2021 <- st_read('https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LSOA_2021_EW_BFC_V2/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=geojson')

lsoa21_lookup <- read_csv(paste0(local_store, '/OA21_LSOA21_MSOA21_LAD22_EW_LU.csv')) %>% 
  filter(lad22nm %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing')) %>% 
  select(lsoa21cd, lsoa21nm, LTLA = lad22nm) %>% 
  unique()

lsoa_changes <- lsoa21_lookup %>% 
  group_by(LTLA) %>% 
  summarise(Number_of_lsoas_in_2021 = n()) %>% 
  left_join(lsoa_11_summary, by = 'LTLA')

lsoa_2021_spdf <- lsoa_2021 %>% 
  filter(LSOA21CD %in% lsoa21_lookup$lsoa21cd) %>% 
  as_Spatial(., IDs = LSOA21CD)

lsoa_2021_leaflet_map <- leaflet(lsoa_2021_spdf) %>%  
  addControl(paste0("<font size = '1px'><b>West Sussex Lower layer Super Output Area changes 2011-2021</font>"),
             position='topright') %>% 
  addTiles(urlTemplate = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',attribution = '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a><br>Contains Royal Mail data &copy Royal Mail copyright and database right 2022<br>Zoom in/out using your mouse wheel or the plus (+) and minus (-) buttons and click on an dot to find out more.') %>%
  addPolygons(# fill = FALSE,
              stroke = TRUE, 
              color = "maroon",
              popup = paste0('LSOA 2021: ', lsoa_2021_spdf$LSOA21NM, ' (', lsoa_2021_spdf$LSOA21CD, ')'),
              weight = 2,
              group = 'Show 2021 boundaries') %>% 
  addPolygons(data = lsoa_2011_spdf,
              fill = FALSE,
              stroke = TRUE, 
              color = "#000000",
              weight = 2,
              group = 'Show 2011 boundaries') %>% 
  addScaleBar(position = "bottomleft") %>% 
  addLegend(colors = c('#000000', 'maroon'),
            labels = c('2011 LSOAs', '2021 LSOAs'),
            title = 'Boundaries',
            opacity = 1,
            position = 'bottomright') %>%
  addMeasure(position = 'bottomright',
             primaryAreaUnit = 'sqmiles',
             primaryLengthUnit = 'miles') %>% 
  addLayersControl(
    overlayGroups = c('Show 2011 boundaries', 'Show 2021 boundaries'),
    options = layersControlOptions(collapsed = FALSE)) 

htmlwidgets::saveWidget(lsoa_2021_leaflet_map,
                        './lsoa_2021_leaflet_map.html',
                        selfcontained = TRUE)



