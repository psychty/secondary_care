
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# Grab ALL fingertips indicator IDs
all_fingertip_indicators <- read_csv(url('https://fingertips.phe.org.uk/api/indicator_metadata/csv/all'))%>% 
  rename(ID = 'Indicator ID',
         Indicator_Name = 'Indicator')

violence_indicators <- all_fingertip_indicators %>% 
  filter(str_detect(Indicator_Name, "[Vv]iolen[ct]"))

# Indicator B12a - Violent Crime hospital admissions for violence (including sexual violence)

# The number of emergency hospital admissions for violence (external causes: ICD-10 codes X85 to Y09). Directly age standardised rate per 100,000 population.

# The number of first finished emergency admission episodes in patients (episode number = 1, admission method starts with 2), with a recording of violent crime classified by diagnosis code (X85 to Y09 occurring in any diagnosis position, primary or secondary) in financial year in which episode ended.

# Regular and day attenders have been excluded. Admissions are only included if they have a valid Local Authority code. Regions are the sum of the Local Authorities. England is the sum of all Local Authorities and admissions coded as U (England NOS).

# 3 year pooled ONS Mid-year population estimates

# HES inpatient data are generally considered to be complete and robust. However, there may be a question regarding the quality of external cause coding and differences in admission thresholds. There may be variation between Trusts in the way hospital admissions are coded. There may be variation in data recording completeness. Information could potentially be missing in the admission episode record but added instead to a subsequent episode record. In addition, some transfers which are also coded as episode order 1 (epiorder 1) and emergency could lead to double counting.

# Notes	Where the observed total number of admissions is less than 10, the rates have been suppressed as there are too few admissions to calculate directly standardised rates reliably. The cut-off has been reduced from 25, following research commissioned by PHE and in preparation for publication which shows DSRs and their confidence intervals are robust whenever the count is at least 10.

# This code will loop through all the alcohol_indicators, and get all the data available from fingertips. If it fails you'll hear the infamous sound of a fall to death scream in almost any tv show/film 

beepr::beep_on_error(sound = 'wilhelm',
                    { 
for(i in 1:length(unique(violence_indicators$ID))){
# If I equals 1 then create an overall data frame (compiled_df) for adding all the individual indicator dataframes to it
 if(i == 1){compiled_df <- data.frame(ID = character(), Area_Name = character(), Type  = character(), Sex  = character(), Age = character(), Category_type = character(), Category  = character(),Period = character(),Value = numeric(),Lower_CI= numeric(), Upper_CI = numeric(),Numerator = numeric(), Denominator  = numeric(), Note = character(), Compared_to_eng = character(),Compared_to_parent = character(), TimeperiodSortable = numeric(), Time_coverage = character())}
                         
id_x <- unique(violence_indicators$ID)[i]
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
 })

# Create a table of metadata for the indicators
violence_metadata <- violence_indicators %>%
  rename(Source = 'Data source') %>%
  select(ID, Indicator_Name, Unit, Definition, Rationale, Methodology, Source) %>% 
  mutate(ID = as.character(ID))

# We can create an object of all the West Sussex areas which can be used throughout the script, rather than typing out all areas each time.
wsx_areas <- c( 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing', 'West Sussex')

latest_df <- compiled_df %>% 
  filter(Type %in% c('UA', 'County', 'England', 'District')) %>% 
  group_by(ID) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable)) %>%
  filter(Area_Name %in% wsx_areas) %>%
  unique() %>% 
  left_join(violence_metadata, by = 'ID') 



# Crime data at Community Safety Partnership area level -

# https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/crimeandjustice/datasets/recordedcrimedatabycommunitysafetypartnershiparea/yearendingmarch2022/cspyemar22final.xlsx