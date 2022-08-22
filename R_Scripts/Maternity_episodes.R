# https://digital.nhs.uk/data-and-information/publications/statistical/nhs-maternity-statistics/2020-21

packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'PHEindicatormethods', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'ggpol', 'magick', 'officer', 'leaflet', 'leaflet.extras')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

local_store <- 'C:/Users/ASUS/OneDrive/Documents/GitHub/secondary_care/local'

# LSOA population ####
IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

download.file('https://files.digital.nhs.uk/32/C86925/hosp-epis-stat-mat-hespla-2020-21.xlsx', paste0(local_store, '/HES_Mat_2020_21.xlsx'), mode = 'wb')

mat_nhs_gestation_at_delivery_df <- read_excel(paste0(local_store, '/HES_Mat_2020_21.xlsx'),
                                               sheet = "TB2021", col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
                                               skip = 9) %>% 
  rename(Trust_name = Description) %>% 
  filter(str_detect(Trust_name, regex('sussex|brighton', ignore_case = TRUE)))

mat_nhs_method_of_delivery <- read_excel(paste0(local_store, '/HES_Mat_2020_21.xlsx'),
                                         sheet = "TC2021", 
                                         col_types = c("text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",  "numeric", "numeric", "text", "text", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"), 
                                         skip = 10) %>% 
  filter(str_detect(Trust_name, regex('sussex', ignore_case = TRUE)))

download.file('https://files.digital.nhs.uk/66/82FFFF/hosp-epis-stat-mat-hesmeta-2020-21.xlsx', paste0(local_store, '/HES_metadata_maternity.xlsx'), mode = 'wb')

 # This publication shows the number of HES delivery episodes during the period, with a number of breakdowns including by method of onset of labour, delivery method and place of delivery.