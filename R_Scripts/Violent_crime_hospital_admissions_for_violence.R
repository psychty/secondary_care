
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

local_store <- 'https://raw.githubusercontent.com/psychty/secondary_care/main/Data_store'

# LSOA population
IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

lsoa_mye <- read_csv(paste0(local_store, '/lsoa_mye_16_20.csv')) 

wsx_mye <- lsoa_mye %>% 
  group_by(Sex, Age_group) %>% 
  summarise(`2016_20` = sum(`2016_20`, na.rm = TRUE))

# Disclosure control function
source('https://raw.githubusercontent.com/psychty/secondary_care/main/R_Scripts/Disclosure%20control.R')

# Create a dataset for the European Standard Population
esp_2013_21_cat <- data.frame(Age_group = c('0 years', '1-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90-94 years', '95 and over'), Standard_population = c(1000, 4000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 1500, 800, 200), stringsAsFactors = TRUE)

esp_2013_19_cat <- data.frame(Age_group = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85+ years'), Standard_population = c(5000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 2500), stringsAsFactors = TRUE)

# Data dictionary
HES_data_dictionary <- read_csv(paste0(local_store, "/HES_field_metadata.csv"))


# OHID produce some useful HES outputs https://khub.net/group/south-east-public-health-information-group/group-library/-/document_library/Sz8Ah1O1ukgg/view/254524611?_com_liferay_document_library_web_portlet_DLPortlet_INSTANCE_Sz8Ah1O1ukgg_redirect=https%3A%2F%2Fkhub.net%3A443%2Fgroup%2Fsouth-east-public-health-information-group%2Fgroup-library%2F-%2Fdocument_library%2FSz8Ah1O1ukgg%2Fview%2F56035271%3F_com_liferay_document_library_web_portlet_DLPortlet_INSTANCE_Sz8Ah1O1ukgg_redirect%3Dhttps%253A%252F%252Fkhub.net%253A443%252Fgroup%252Fsouth-east-public-health-information-group%252Fgroup-library%253Fp_p_id%253Dcom_liferay_document_library_web_portlet_DLPortlet_INSTANCE_Sz8Ah1O1ukgg%2526p_p_lifecycle%253D0%2526p_p_state%253Dnormal%2526p_p_mode%253Dview 

# This is not public data and so you'll need to log in to Knowledge Hub and download the file yourself.

# Crime data at Community Safety Partnership area level -
if(file.exists('./cspyemar22final.xlsx') != TRUE){
download.file('https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/crimeandjustice/datasets/recordedcrimedatabycommunitysafetypartnershiparea/yearendingmarch2022/cspyemar22final.xlsx', './cspyemar22final.xlsx', mode = 'wb')
}

csp_crime_data_2021 <- read_excel('./cspyemar22final.xlsx',
                                  sheet = "Table C2", 
                                  skip = 6) %>% 
  mutate(Year = '2020/21') %>% 
  filter(`Local Authority\r\n name` %in% wsx_areas)

csp_crime_data_2022 <- read_excel('./cspyemar22final.xlsx',
                                    sheet = "Table C3", 
                                    skip = 6) %>% 
  mutate(Year = '2021/22') %>% 
  filter(`Local Authority\r\n name` %in% wsx_areas)

wsx_recorded_crime <- csp_crime_data_2021 %>% 
  bind_rows(csp_crime_data_2022)

# Grab ALL fingertips indicator IDs
all_fingertip_indicators <- read_csv(url('https://fingertips.phe.org.uk/api/indicator_metadata/csv/all'))%>% 
  rename(ID = 'Indicator ID',
         Indicator_Name = 'Indicator')

violence_indicators <- all_fingertip_indicators %>% 
  filter(str_detect(Indicator_Name, "[Vv]iolen[ct]|[iI]njur"))

# Create a table of metadata for the indicators
violence_metadata <- violence_indicators %>%
  rename(Source = 'Data source') %>%
  select(ID, Indicator_Name, Unit, Definition, Rationale, Methodology, Source) %>% 
  mutate(ID = as.character(ID))

violent_crime_hospital_admissions <- violence_metadata %>% 
  filter(ID == '11201')

# Indicator B12a - Violent Crime hospital admissions for violence (including sexual violence)

# The number of emergency hospital admissions for violence (external causes: ICD-10 codes X85 to Y09). Directly age standardised rate per 100,000 population.

# The number of first finished emergency admission episodes in patients (episode number = 1, admission method starts with 2), with a recording of violent crime classified by diagnosis code (X85 to Y09 occurring in any diagnosis position, primary or secondary) in financial year in which episode ended.

# Regular and day attenders have been excluded. Admissions are only included if they have a valid Local Authority code. Regions are the sum of the Local Authorities. England is the sum of all Local Authorities and admissions coded as U (England NOS).

# 3 year pooled ONS Mid-year population estimates

# HES inpatient data are generally considered to be complete and robust. However, there may be a question regarding the quality of external cause coding and differences in admission thresholds. There may be variation between Trusts in the way hospital admissions are coded. There may be variation in data recording completeness. Information could potentially be missing in the admission episode record but added instead to a subsequent episode record. In addition, some transfers which are also coded as episode order 1 (epiorder 1) and emergency could lead to double counting.

# Notes	Where the observed total number of admissions is less than 10, the rates have been suppressed as there are too few admissions to calculate directly standardised rates reliably. The cut-off has been reduced from 25, following research commissioned by PHE and in preparation for publication which shows DSRs and their confidence intervals are robust whenever the count is at least 10.

# This code will loop through all the alcohol_indicators, and get all the data available from fingertips. If it fails you'll hear the infamous sound of a fall to death scream in almost any tv show/film 

for(i in 1:length(unique(violent_crime_hospital_admissions$ID))){
  
  # If I equals 1 then create an overall data frame (compiled_df) for adding all the individual indicator dataframes to it
  if(i == 1){compiled_df <- data.frame(ID = character(), Area_Name = character(), Type  = character(), Sex  = character(), Age = character(), Category_type = character(), Category  = character(),Period = character(),Value = numeric(),Lower_CI= numeric(), Upper_CI = numeric(),Numerator = numeric(), Denominator  = numeric(), Note = character(), Compared_to_eng = character(),Compared_to_parent = character(), TimeperiodSortable = numeric(), Time_coverage = character())}
                         
id_x <- unique(violent_crime_hospital_admissions$ID)[i]
loopy <- read_csv(url(paste0('https://fingertips.phe.org.uk/api/all_data/csv/for_one_indicator?indicator_id=', id_x))) %>% 
  select(!c('Parent Code', 'Indicator Name', 'Parent Name', 'Lower CI 99.8 limit', 'Upper CI 99.8 limit', 'Recent Trend', 'New data', 'Compared to goal')) %>%
  rename(ID = 'Indicator ID',
         Area_Code = 'Area Code',
         Area_Name = 'Area Name',
         Type = 'Area Type',
         Period = 'Time period',
         Lower_CI = 'Lower CI 95.0 limit',
         Upper_CI = 'Upper CI 95.0 limit',
         Category_type = 'Category Type',
         Numerator = 'Count',
         Note = 'Value note',
         Compared_to_eng = 'Compared to England value or percentiles',
         TimeperiodSortable = 'Time period Sortable',
         Time_coverage = 'Time period range') %>% 
  rename(Compared_to_parent = 17) %>% # Column 17 might be called something different depending on the indicator so we can use the column index (17) 
  mutate(ID = as.character(ID)) %>% 
  mutate(Period = as.character(Period))
                         
compiled_df <- compiled_df %>% 
  bind_rows(loopy)
}

# We can create an object of all the West Sussex areas which can be used throughout the script, rather than typing out all areas each time.
wsx_areas <- c( 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing', 'West Sussex')

latest_df <- compiled_df %>% 
  filter(Type %in% c('UA', 'County', 'England', 'District')) %>% 
  group_by(ID) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>%
  filter(Area_Name %in% wsx_areas) %>%
  unique() %>% 
  left_join(violence_metadata, by = 'ID') 

wsx_violence_admissions <- compiled_df %>% 
  filter(Area_Name %in% wsx_areas) %>% 
  filter(!Period %in% c('2009/10 - 11/12', '2010/11 - 12/13'))

wsx_violence_admissions_count <- wsx_violence_admissions %>% 
  select(Area_Name, Sex, Numerator, Period) %>% 
  pivot_wider(names_from = 'Sex',
              values_from = 'Numerator')


# HES data - can we replicate the numbers ####
HDIS_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/HDIS/Extracts_Rich_Tyler/'

df_raw <- list.files(HDIS_directory)[grepl("West_Sussex_residents_emergency_admissions_violence_", list.files(HDIS_directory)) == TRUE] %>%  map_df(~read_csv(paste0(HDIS_directory,.),
                                                                                                                                                       col_types = cols(ADMIDATE = col_date(format = '%Y-%m-%d')),
                                                                                                                                                       na = "null")) %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', NA)))

df_raw %>% 
  group_by(ETHNICITY) %>% 
  summarise(Patients = n()) %>%
  mutate(Proportion = Patients / sum(Patients))
