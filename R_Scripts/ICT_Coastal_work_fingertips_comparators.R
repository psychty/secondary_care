packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'nomisr', 'fingertipsR')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# Enable repository from ropensci
# options(repos = c(
 # ropensci = 'https://ropensci.r-universe.dev',
 # CRAN = 'https://cloud.r-project.org'))

# Download and install fingertipsR in R
# install.packages('fingertipsR')

# We can get all the data in one go
OHID_indicators <- c(90832, 90810, 90813, 21001, 92302, 93574, 93573, 22401)

# There are different geographies available for some indicators, but they should all consistently include England.
indicator_df <- fingertips_data(OHID_indicators,
                                # AreaCode = c('E10000032', 'E10000011', 'E06000043', 'E12000008', 'E92000001'),
                                AreaCode = 'E92000001',
                                AreaTypeID = 'All',
                                rank = FALSE,
                                categorytype = FALSE) %>%
  group_by(IndicatorID) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>% 
  filter(Sex == 'Persons') %>% 
  select(IndicatorID, IndicatorName, AreaName, Sex, Age, Timeperiod, Value, Count, Denominator) %>% 
  unique()


# Fingertips uses the ESP 2013 with 90+ age bracket


# Population denominators ####

IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Brighton and Hove', 'Eastbourne', 'Hastings', 'Lewes', 'Rother', 'Wealden', 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

lsoa_mye_2020 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latest',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,186...191',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  mutate(Age_group = ifelse(Age_group %in% c('Age 85', 'Age 86', 'Age 87', 'Age 88', 'Age 89'), 'Aged 85-89', Age_group)) %>% 
  mutate(Age_group = paste0(gsub('Aged ', '', Age_group), ' years')) %>% 
  mutate(Age_group = gsub('Age 0 - 4', '0-4', Age_group)) %>% 
  group_by(Year, LSOA11CD, LSOA11NM, Sex, Age_group) %>% 
  summarise(Population = sum(Population, na.rm = TRUE))

lsoa_mye_2019 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS1',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,186...191',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2018 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS2',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,186...191',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2017 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS3',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,186...191',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_mye_2016 <- nomis_get_data(id = 'NM_2010_1',
                                time = 'latestMINUS4',
                                sex = '1,2',
                                measures = '20100',
                                c_age = '1...18,186...191',
                                geography = "TYPE298") %>%
  select(Year = DATE, LSOA11NM = GEOGRAPHY_NAME, LSOA11CD = GEOGRAPHY_CODE, Age_group = C_AGE_NAME, Sex = GENDER_NAME, Population = OBS_VALUE) %>% 
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)
