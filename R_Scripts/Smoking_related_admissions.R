packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'PHEindicatormethods', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'ggpol', 'magick', 'officer', 'leaflet', 'leaflet.extras', 'zoo')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

replacings_the_nas <- function(x)replace_na(x, 0)

data_store <- 'https://raw.githubusercontent.com/psychty/secondary_care/main/Data_store'

local_store <- '\\\\chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/R/Alcohol'

# LSOA population
IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

lsoa_mye <- read_csv(url(paste0(data_store, '/lsoa_mye_1120.csv'))) 

rolling_mye <- lsoa_mye %>% 
  group_by(LSOA11CD, LSOA11NM, Sex, Age_group) %>% 
  arrange(LSOA11CD, Sex, Age_group) %>% 
  mutate(Rolling_year = ifelse(is.na(lag(Year, 2)), NA, paste0(lag(Year, 2), '-' , Year))) %>% 
  mutate(Three_year_population = ifelse(is.na(Rolling_year),
                                        NA,
                                        rollapplyr(Population,
                                                   width = 3,
                                                   FUN = sum, 
                                                   align = 'right', 
                                                   partial = TRUE)))

# Lookup from LSOA to Ward
LSOA11_WD21 <- read_excel(paste0(local_store, '/LSOA11_WD21_LAD21_EW_LU_V2.xlsx')) %>% 
  select(LSOA11CD, WD21CD, WD21NM, LTLA = LAD21NM)

# Create a dataset for the European Standard Population
esp_2013_19_cat <- data.frame(Age_group = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85+ years'), Standard_population = c(5000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 2500), stringsAsFactors = TRUE)

# Data dictionary
if(file.exists(paste0(local_store, '/HES_data_dictionary.xlsx')) != TRUE){
  download.file('https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.8---published-m12.xlsx', destfile = paste0(local_store, '/HES_data_dictionary.xlsx'), mode = 'wb')
}

HES_inpatient_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                            sheet = "HES APC TOS",
                                            skip = 1)


# https://www.gov.uk/government/consultations/proposed-changes-to-how-smoking-attributable-risk-is-calculated

# Load data ####
HDIS_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/HDIS/Extracts_Rich_Tyler/'

# list.files(HDIS_directory)
df_raw <- list.files(HDIS_directory)[grepl("West_Sussex_residents_finished_admission_episodes_", list.files(HDIS_directory)) == TRUE] %>%  map_df(~read_csv(paste0(HDIS_directory,.),
                                                                                                                                                           col_types = cols(ADMIDATE = col_date(format = '%Y-%m-%d'),
                                                                                                                                                                            DISDATE = col_date(format = '%Y-%m-%d')),
                                                                                                                                                           na = "null")) %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', NA))) %>% 
  filter(Age_group != 'Unknown') %>%
  mutate(FYEAR = factor(paste0('20',substr(FYEAR, 1,2), '/', substr(FYEAR, 3,4)), levels = c('2011/12', '2012/13', '2013/14', '2014/15', '2015/16', '2016/17', '2017/18', '2018/19', '2019/20', '2020/21', '2021/22')))


# Hospital admissions data is taken from HES (Hospital Episode Statistics) and includes all admissions to hospital with the following smoking attributable diagnosis as the primary diagnosis:
  
  # • Malignant neoplasms: Lung(C33-C34), Nasal synuses & nasopharynx(C11,C30-C31), Oral cavity(C10), Pharynx (C14), Larynx(C32), Oesophagus (C15), Stomach (C16), Pancreas (C25), Liver (C22), Colorectal (C18-C20), Kidney (C64), Lower urinary tract (C65-C66), Bladder (C67), Breast (C50), Cervix (C53), Acute myeloid leukaemia (C92), Malignant melanoma (C43-C44), • Cardiovascular Diseases: Ischemic heart disease (I20-I25), Stroke (I60-I67), Peripheral arterial disease (I73.9), Abdominal aortic aneurysm (I71), Venous thromboembolism (I26, I80-I82) • Respiratory Diseases: COPD (J40-J44, J47), Asthma (J45-J46), TB (A15-A19), Pneumonia (J12-J18), Influenza (J09-J10,J11), Pulmonary fibrosis (J84.1), Obstructive sleep apnoea (G47.3) • Other diseases: Age related cataract (H25), Hip fracture (S72.0-S72.2), maternal and pregnancy outcomes (O03-O45,O00,O42), mental health (G30,F01-F03,F20-F25,F28-F29,F32-F33,F50.2,F50.81), arthritis (M05-M06), Chronic kidney and renal disease (N18), lupus erythematosus (M32), Diabetes (E11), Psoriasis (L40), Macular degeneration (H35.3-H52.4), Low back pain (M54.5), Crohn’s disease (K50), Barrett’s oesophagus (K22.7), Hearing loss (H90-H91), surgical complications (Y83, T81.4, Q79.0).