packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'nomisr')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Brighton and Hove', 'Eastbourne', 'Hastings', 'Lewes', 'Rother', 'Wealden', 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

lsoa_mye_2020 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latest',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2020_clean <- lsoa_mye_2020 %>% 
  mutate(Age_group = paste0(gsub('Aged ', '', Age_group), ' years')) %>% 
  mutate(Age_group = gsub('Age 0 - 4', '0-4', Age_group)) 

lsoa_mye_2019 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS1',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2018 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS2',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2017 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS3',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2016 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS4',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2015 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS5',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2014 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS6',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2013 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS7',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2012 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS8',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2011 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS9',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,210',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye <- lsoa_mye_2011 %>% 
  bind_rows(lsoa_mye_2012) %>% 
  bind_rows(lsoa_mye_2013) %>% 
  bind_rows(lsoa_mye_2014) %>% 
  bind_rows(lsoa_mye_2015) %>% 
  bind_rows(lsoa_mye_2016) %>% 
  bind_rows(lsoa_mye_2017) %>% 
  bind_rows(lsoa_mye_2018) %>% 
  bind_rows(lsoa_mye_2019) %>% 
  bind_rows(lsoa_mye_2020) %>% 
  mutate(Age_group = paste0(gsub('Aged ', '', Age_group), ' years')) %>% 
  mutate(Age_group = gsub('Age 0 - 4', '0-4', Age_group)) 

local_store <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/R/Population'

lsoa_mye %>% 
  write.csv(., paste0(local_store, '/lsoa_mye_1120.csv'), row.names = FALSE)

lsoa_mye %>% 
  filter(Year %in% c(2011,2012,2013,2014,2015)) %>% 
  write.csv(., paste0(local_store, '/lsoa_mye_1115.csv'), row.names = FALSE)

lsoa_mye %>% 
  filter(Year %in% c(2016,2017,2018,2019,2020)) %>% 
  write.csv(., paste0(local_store, '/lsoa_mye_1620.csv'), row.names = FALSE)
