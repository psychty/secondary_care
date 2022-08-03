
# This shows how to create isochrone maps (time to travel maps), using a blogpost from Tom Jemmett (NHSR)

# https://nhsrcommunity.com/using-sf-to-calculate-catchment-areas/

packages <- c('easypackages', 'tidyverse','readxl', 'readr', 'glue', 'scales', 'sf', 'osrm', 'leaflet', 'leaflet.extras', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'httr', 'rvest', 'stringr', 'rgeos', 'nomisr', 'randomcoloR')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

base_directory <- '~/GitHub/secondary_care'

# Define a directory for working documents/downloads etc
local_store <- paste0(base_directory, '/local')
#local_store <- './secondary_care/local'

# Use dir.exists to see if you have a folder already
# dir.exists(local_store)

# Use an if statement to create the directory if it does not exist
if(dir.exists(local_store) == FALSE) {
  dir.create(local_store)
  print(paste0('The local directory for raw files on your machine (', local_store, ') appears to be missing, it has now been created.'))
}

script_store <- paste0(base_directory, '/R_Scripts')

if(dir.exists(script_store) == FALSE) {
  print(paste0('The directory for R scripts on your machine (', script_store, ') appears to be missing, check or ammend the filepath script_store'))
}

output_store <- paste0(base_directory, '/Outputs')

if(dir.exists(output_store) == FALSE) {
  dir.create(output_store)
  print(paste0('The directory for outputs on your machine (', output_store, ') appears to be missing, it has been created.'))
}

# TODO: update source
# Major Trauma Centres - may require updating/automating ####
# Download a geojson object containing points of major trauma centres in England
major_trauma_centres <- read_sf("https://gist.githubusercontent.com/tomjemmett/ac111a045e1b0a60854d3d2c0fb0baa8/raw/a1a0fb359d1bc764353e8d55c9d804f47a95bfe4/major_trauma_centres.geojson",
                                agr = "identity")

# Population estimates ####
# Get populaiton estimates for LSOAs from the Office for National Statistics NOMIS service. 
# You can use the api call and read_csv() to return data and this works best when filtering a small dataset (e.g. wsx LSOAs), but the row limit returned is 25000
# lsoa_mye <- read_csv('https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1249902593...1249937345&date=latest&gender=0&c_age=200&measures=20100')

# It does require knowing the fields and values to search. 0 is persons, 1 is male, 2 is female
# lsoa geography type is 298
# c_age = 200 is all ages
mye_lsoa <- nomis_get_data(id = 'NM_2010_1',
                      time = 'latest',
                      sex = '0',
                      measures = '20100',
                      c_age = '200',
                      geography = "TYPE298") %>% 
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE)

original_map <- leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(data = major_trauma_centres,
                   color = "black",
                   stroke = TRUE,
                   fillColor = "maroon",
                   weight = 1,
                   radius = 6,
                   opacity = 1,
                   fillOpacity = 1,
                   group = 'Show major trauma centres') 

original_map
  
# Load the lsoa boundaries. You need to use read_sf here rather than geojson_read()
lsoa_clipped_sf <- read_sf('https://opendata.arcgis.com/datasets/e9d10c36ebed4ff3865c4389c2c98827_0.geojson') %>% 
  left_join(mye_lsoa[c('LSOA11CD', 'Population')], by = 'LSOA11CD')

# Take each LSOA and find which point it is closest to using the st_nearest_feature predicate function with st_join. 

# sf knows that when we are summarising a geospatial table we need to combine the geometries somehow. What it will do is call st_union and return us a single geometry per MTC.

# One thing we need to do before joining our data though is to transform our data temporarily to a different CRS. Our data currently is using latitude and longitude in a spherical projection, but st_nearest_points assumes that the points are planar. That is, it assumes that the world is flat. This can lead to incorrect results.

# But, we can transform the data to use the British National Grid. This instead specifies points as how far east and north from an origin. This has a CRS number of 27700. Once we are done summarising our data we can again project back to the previous CRS (4326). 

# If you also use a function to aggregate a value by group of geometries, (group_by() and summarise()), summarise will automatically call st_union on the geometries

MTC_catchment_1 <- lsoa_clipped_sf %>%
  st_transform(crs = 27700) %>% # transform the CRS
  st_join(
    st_transform(major_trauma_centres, crs = 27700),
    join = st_nearest_feature) %>%  # assign each LSOA to a single, closest, MTC
  group_by(name, org_id) %>%
  summarise(across(Population, sum), .groups = "drop") %>%
  st_transform(crs = 4326) # return the CRS to lat long

# NOTE: I tried to do this without summarise function (without population details and just trying to dissolve boundaries). This was impossible and caused R to crash, so you must include a population and summarise for the time being

# MTC_catchment_1 <- MTC_lsoa %>%
#   group_by(name) %>% 
#   st_buffer(0.5) %>% # make a buffer of half a meter around all parts (to avoid slivers)
#   st_union()

length(unique(MTC_catchment_1$name))

randomColor()

map_2 <- original_map %>% 
  addPolygons(data = MTC_catchment_1,
              fillColor = randomColor(length(unique(MTC_catchment_1$name))),
              weight = 1,
              fillOpacity = .9,
              popup = paste0('Closest MTC: ', MTC_catchment_1$name),
              group = 'Show catchment version 1') %>% 
  addLayersControl(
    # baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
    overlayGroups = c("Show major trauma centres", "Show catchment version 1"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  hideGroup('Show major trauma centres')
  
# This is assigning LSOAs to their closest (as the crow flies) major trauma centre. As you can see in South Wales, the University Hospital Wales is closest for those on the South Coast of England (if they could travel across the channel)

# Instead we'll use the road network to establish closest MTC

# Calculate travel time from each LSOA to the MTC’s using the osrm package. An isochrone is an area of equal travel time from a point. So, if we calculate isochrone’s for each of the MTC’s, then join to the LSOA’s, we can assign our LSOA’s to the MTC’s.

# This code will calculate the isochrone’s for our MTC’s, in 30 minute travel time increments, from 0 to 150 minutes. This is calculated as per usual car travel times, and not for ambulance travel times. Note, this can take a few minutes to run.

#Lets look at a single MTC, Southampton General as its my own local.

MTC_SG <- major_trauma_centres %>% 
  filter(name == 'SOUTHAMPTON GENERAL HOSPITAL')

MTC_SG_iso_10_minute <- MTC_SG %>%
  mutate(iso = map(geometry,
                   osrmIsochrone,
                   breaks = seq(0, 80, by = 10),
                   res = 60,
                   returnclass = "sf")) %>%
  st_drop_geometry() %>%
  unnest(iso) %>%
  st_set_geometry("geometry")

leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(data = MTC_SG,
                   color = "black",
                   stroke = TRUE,
                   fillColor = "maroon",
                   weight = 1,
                   radius = 6,
                   opacity = 1,
                   fillOpacity = 1,
                   group = 'Show Southampton General Hospital') %>% 
  addPolygons(data = MTC_SG_iso_10_minute,
              fillColor = viridis::viridis(length(unique(MTC_SG_iso_10_minute$max))),
              weight = 1,
              fillOpacity = .6,
              popup = paste0('Drive time ', MTC_SG_iso_10_minute$min, '-', MTC_SG_iso_10_minute$max, ' minutes'),
              group = 'Show drive time isochrone') 


# You may have noticed from the first isochrone map, that some small pockets show as different times (a 40-50 minute box within an area denoted 30-40). This is likely down to the resolution we have computed our polygons at. Probably a safer way to remove the noise is to ensure an LSOA is assigned to the drive time isochrone.

# If an LSOA is matched by two isochrones of the same time for two different MTC’s then our filter will find both! In these cases we select the closest MTC based on straight line distance. This can be quite slow, so to reduce the computational burden I split my data into two groups: those that have more than 1 match (which we apply the closest distance filter to) and those that have just 1 match.

# MTC_SG_iso_10_minute_transformed <- MTC_SG_iso_10_minute %>% 
#   st_transform(crs = 27700) 
# 
# LSOAs_in_MTC_SG_80_min <- lsoa_clipped_sf %>%
#     st_transform(crs = 27700) %>%
#     st_join(MTC_SG_iso_10_minute_transformed) %>% 
#   filter(name == MTC_SG$name) %>% 
#   group_by(name, org_id, max) %>%
#   summarise(.groups = "drop") %>%
#   st_transform(4326)

leaflet() %>%
  addTiles() %>% 
  addCircleMarkers(data = MTC_SG,
                   color = "black",
                   stroke = TRUE,
                   fillColor = "maroon",
                   weight = 1,
                   radius = 6,
                   opacity = 1,
                   fillOpacity = 1,
                   group = 'Show Southampton General Hospital') %>% 
  addPolygons(data = MTC_SG_iso_10_minute,
              fillColor = viridis::viridis(length(unique(MTC_SG_iso_10_minute$max))),
              weight = 1,
              fillOpacity = .6,
              popup = paste0('Drive time ', MTC_SG_iso_10_minute$min, '-', MTC_SG_iso_10_minute$max, ' minutes'),
              group = 'Show drive time isochrone') %>% 
  # addPolygons(data = LSOAs_in_MTC_SG_80_min,
  #             fillColor = viridis::magma(length(unique(LSOAs_in_MTC_SG_80_min$max))),
  #             weight = 1,
  #             fillOpacity = 1,
  #             popup = paste0('Drive time ', LSOAs_in_MTC_SG_80_min$max - 9, '-', LSOAs_in_MTC_SG_80_min$max, ' minutes'),
  #             group = 'Show LSOA drive time isochrone') %>% 
  addLayersControl(
    baseGroups = c("Show drive time isochrone", "Show LSOA drive time isochrone"),
    overlayGroups = c("Show major trauma centres"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  hideGroup('Show major trauma centres')

# This mapping analysis could be used for other provider services such as stop smoking clinics or smaller treatment centres locally.

