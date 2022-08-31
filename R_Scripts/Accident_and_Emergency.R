# A&E data exploration ####


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

# Create a dataset for the European Standard Population
esp_2013_21_cat <- data.frame(Age_group = c('0 years', '1-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90-94 years', '95 and over'), Standard_population = c(1000, 4000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 1500, 800, 200), stringsAsFactors = TRUE)

esp_2013_19_cat <- data.frame(Age_group = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85+ years'), Standard_population = c(5000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 2500), stringsAsFactors = TRUE)

# Data dictionary
HES_data_dictionary <- read_csv(paste0(local_store, "/HES_field_metadata.csv"))

# A&E Attendances -

# There has been a signicant reduction in overall attendances throughout the financial year of 2020-21, starting from March 2020, which was the period of the COVID-19 outbreak.

# Load data ####
HDIS_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/HDIS/Extracts_Rich_Tyler/'

df_raw <- list.files(HDIS_directory)[grepl("West_Sussex_residents_A&E_attendances", list.files(HDIS_directory)) == TRUE] %>%  map_df(~read_csv(paste0(HDIS_directory,.),
        col_types = cols(ARRIVALDATE = col_date(format = '%Y-%m-%d')),
        na = "null")) %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', 'Unknown')))

df_processed <- df_raw %>% 
  mutate(Arrival_mode = ifelse(AEARRIVALMODE == 1, 'Ambulance (including air ambulance)', ifelse(AEARRIVALMODE == 2, 'Other', ifelse(AEARRIVALMODE == 9, 'Unknown', NA)))) %>% 
  mutate(Attendance_category = ifelse(AEATTENDCAT == 1, 'First A&E attendance', ifelse(AEATTENDCAT == 2, 'Planned follow-up A&E attendance', ifelse(AEATTENDCAT == 3, 'Unplanned follow-up A&E attendance', ifelse(AEATTENDCAT == 9, 'Unknown', NA))))) %>% 
  mutate(Attendance_disposal = ifelse(AEATTENDDISP == '01', 'Admitted or became a lodged patient', ifelse(AEATTENDDISP == '02', 'Discharged with follow up at GP', ifelse(AEATTENDDISP == '03', 'Discharged with no follow up required', ifelse(AEATTENDDISP == '04', 'Referred to A&E clinic', ifelse(AEATTENDDISP == '05', 'Referred to fracture clinic', ifelse(AEATTENDDISP == '06', 'Referred to other outpatient clinic', ifelse(AEATTENDDISP == '07', 'Transferred to other provider', ifelse(AEATTENDDISP == '10', 'Deceased', ifelse(AEATTENDDISP == '11', 'Referred to other healthcare professional', ifelse(AEATTENDDISP == '12', 'Left department prior to treatment', ifelse(AEATTENDDISP == '14', 'Other', ifelse(AEATTENDDISP == '99', 'Unknown', NA))))))))))))) %>% 
  mutate(Type_of_department = ifelse(AEDEPTTYPE == '01', 'Consultant-led emergency deptartment with full resuscitation facilities', ifelse(AEDEPTTYPE == '02', 'Consultant-led speciality A&E service', ifelse(AEDEPTTYPE == '03', 'Other type of A&E/minor injury department', ifelse(AEDEPTTYPE == '04', 'NHS Walk-in centre', ifelse(AEDEPTTYPE == '99', 'Unknown', NA)))))) %>% 
  mutate(Incident_location = ifelse(AEINCLOCTYPE == '10', 'Home', ifelse(AEINCLOCTYPE == '40', 'Workplace', ifelse(AEINCLOCTYPE == '50', 'Education setting', ifelse(AEINCLOCTYPE == '60', 'Public place', ifelse(AEINCLOCTYPE == '91', 'Other', ifelse(AEINCLOCTYPE == '99', 'Unknown', NA))))))) %>% 
  mutate(Patient_group = ifelse(AEPATGROUP == '10', 'Road Traffic Accident', ifelse(AEPATGROUP == '20', 'Assault', ifelse(AEPATGROUP == '30', 'Deliberate self-harm', ifelse(AEPATGROUP == '40', 'Sporting injury', ifelse(AEPATGROUP == '50', 'Firework injury', ifelse(AEPATGROUP == '60', 'Other accident', ifelse(AEPATGROUP == '70', 'Brought in deceased', ifelse(AEPATGROUP == '80', 'Other', ifelse(AEPATGROUP == '99', 'Unknown', NA))))))))))
  
field_x <- HES_data_dictionary %>% 
  filter(str_detect(Field, regex('patgroup', ignore_case = TRUE)))

field_x$Name
field_x$Description
unique(field_x$Values)

df_processed %>% 
  group_by(Patient_group, AEPATGROUP) %>% 
  summarise(n())

# Look to the future - ECDS 

# From NHS England
# The A&E data provides a simplistic picture of why people attend A&E and the treatment they receive. It was developed in the 1980s and since then the number of people, and their health needs, have changed.

# THE Emergency Care Dataset will improve patient care through better and more consistent information to allow better planning of healthcare services; and improve communication between health professionals.

# The better data we can capture, the more we can understand and commission services that improve care for patients and reduce pressure for staff.

# The ECDS contains 108 data items - Patient demographics (gender, ethnicity, age at activity date), episode information (including arrival and conclusion dates, source of referral and attendance category type), clinical information (chief complaint, acuity, diagnosis, investigations and treatments), injury information (data/time of injury, place type, activity and mechanism) and referred services and discharge information (onward referral for treatment, treatment complete, streaming, follow-up treatment and safeguarding concerns).