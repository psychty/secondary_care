# Alcohol-related hospital admissions ####

# Alcohol-related hospital admissions have been estimated by applying alcohol-attributable fractions (AAFs) to Hospital Episode Statistics (HES) data. AAFs are the proportion of disease cases that can be attributable to alcohol. In 2020 new AAFs were calculated based on updated alcohol consumption rates and the latest evidence linking alcohol consumption to disease outcomes. 

# Alcohol-attributable fractions for England: an update

# Alcohol-related hospital admissions in this report use the new set of AAFs, and so differ from previously published data. Time series comparisons from the Fingertips service are based on the new AAFs but data is only available from 2016/17.

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

# AAF_hes <- read_excel("//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/R/Alcohol/HES_data_dictionary.xlsx",
                        # sheet = "Alcohol fractions ref data", 
                        # skip = 1) %>% 
  # mutate(Sex = ifelse(Sex == 1, 'Male', ifelse(Sex == 2, 'Female', NA)))
# These still look like they are old codes

# England LAPE hospital admission tables Feb 22
if(file.exists(paste0(local_store, '/LAPE_tables_England_22.xlsx')) != TRUE){
  download.file('https://fingertips.phe.org.uk/documents/LAPE_Statistical_Tables_for_England_2022.xlsx', paste0(local_store, '/LAPE_tables_England_22.xlsx'), mode = 'wb')
}

LTLA_related_broad <- read_excel("//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/R/Alcohol/LAPE_tables_England_22.xlsx", 
                              sheet = "1.3",
                              skip = 1) %>% 
  filter(`Region and LA Name` %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing', 'West Sussex')) %>% 
  pivot_longer(cols = 3:ncol(.)) %>% 
  mutate(Sex = ifelse(str_detect(name, '[Pp]ersons'), 'Persons', ifelse(str_detect(name, '[Ff]emale'), 'Female', ifelse(str_detect(name, '[Mm]ale'), 'Male', NA)))) %>% 
  mutate(Measure = ifelse(str_detect(name, '100,000'), 'Rate', ifelse(str_detect(name, '[Aa]dmissions 2'), 'Count (rounded)', NA))) %>%
  mutate(Year = substr(name, nchar(name)- 6, nchar(name))) %>% 
  select(Code = 'ONS code', Area = 'Region and LA Name', Sex, Measure, Year, value) %>%
  mutate(value = as.numeric(value)) %>% 
  pivot_wider(names_from = 'Measure',
              values_from = 'value')

LTLA_related_narrow <- read_excel("//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/R/Alcohol/LAPE_tables_England_22.xlsx", 
                                 sheet = "1.6",
                                 skip = 1) %>% 
  filter(`Region and LA Name` %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing', 'West Sussex')) %>% 
  pivot_longer(cols = 3:ncol(.)) %>% 
  mutate(Sex = ifelse(str_detect(name, '[Pp]ersons'), 'Persons', ifelse(str_detect(name, '[Ff]emale'), 'Female', ifelse(str_detect(name, '[Mm]ale'), 'Male', NA)))) %>% 
  mutate(Measure = ifelse(str_detect(name, '100,000'), 'Rate', ifelse(str_detect(name, '[Aa]dmissions 2'), 'Count (rounded)', NA))) %>%
  mutate(Year = substr(name, nchar(name)- 6, nchar(name))) %>% 
  select(Code = 'ONS code', Area = 'Region and LA Name', Sex, Measure, Year, value) %>%
  mutate(value = as.numeric(value)) %>% 
  pivot_wider(names_from = 'Measure',
              values_from = 'value')

# Disclosure control function
source('https://raw.githubusercontent.com/psychty/secondary_care/main/R_Scripts/Disclosure%20control.R')

# Alcohol Attributable Fractions 

# Tom Jemmett in the NHS R community gave me access to a machine readable file of AAF he's working on
# aaf <- read_csv('https://gist.githubusercontent.com/tomjemmett/2ce79350de2308b631f87a5ee0937a9f/raw/9aa4ae4e3a02cc2c813668f6a2166d6ccd747943/aaf.csv')

# I used this and the PDF updated AAFs to create a machine readable file to join
local_aaf <- read_csv(paste0(local_store, '/Alcohol_attributable_fractions_2019.csv')) 

# Under 16s are incuded only for wholly alcohol attributable conditions
condition_fractions <- local_aaf %>% 
  arrange(ICD10_Code) %>% 
  select(Group, Condition_name, Sex, Age_group, Fraction) %>% 
  filter(Fraction > 0) %>% # Those conditions with a negative (protective) Alcohol Attributable fraction are excluded
  unique() 

condition_fractions_excluded <- local_aaf %>%  
  select(Group, Condition_name, Sex, Age_group, Fraction) %>% 
  filter(Fraction <= 0) %>% 
  unique()

conditions <- condition_fractions %>% 
  select(Condition_name) %>% 
  unique()

# Load data ####
HDIS_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/HDIS/Extracts_Rich_Tyler/'

# list.files(HDIS_directory)
df_raw <- list.files(HDIS_directory)[grepl("West_Sussex_residents_alcohol_related_conditions_", list.files(HDIS_directory)) == TRUE] %>%  map_df(~read_csv(paste0(HDIS_directory,.),
                    col_types = cols(ADMIDATE = col_date(format = '%Y-%m-%d')),
                    na = "null")) %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', NA))) %>% 
  filter(Age_group != 'Unknown') %>%
  mutate(FYEAR = factor(paste0('20',substr(FYEAR, 1,2), '/', substr(FYEAR, 3,4)), levels = c('2011/12', '2012/13', '2013/14', '2014/15', '2015/16', '2016/17', '2017/18', '2018/19', '2019/20', '2020/21', '2021/22')))
  # mutate(EPI_fyear_a = format(EPIEND, '%Y')) %>% 
  # mutate(EPI_fyear_b = format(EPIEND, '%B')) %>% 
  # mutate(EPI_fyear = ifelse(EPI_fyear_b %in% c('January', 'February', 'March'), paste0(as.numeric(EPI_fyear_a) - 1, '/',  substr(EPI_fyear_a, 3, 4)), paste0(as.numeric(EPI_fyear_a), '/', substr(as.numeric(EPI_fyear_a) + 1, 3,4)))) 

# we checked to see that FYEAR was the year in which the episode ended using EPI_fyear

# Broad definition alcohol-related hospital admissions ####

# The "broad" measure of alcohol-related hospital admissions is more dependent on the use of secondary diagnoses than the "narrow" measure. Consequently increases for the "broad" measure may be due to improvements in the recording of secondary diagnoses and therefore "narrow" measure is a better indicator of changes over time which consistently focuses on the single primary diagnosis field.

# Since every hospital admission must have a primary diagnosis the narrow definition is less sensitive to coding practices but may also understate the part alcohol plays in the admission.

# We need to create a field for each condition (conditions defined as groups of ICD10 codes with distinct Alcohol Attributable Fraction values).

# The new field checks if the alc related codes appear in the concat field (for some conditions we can just search the three character concat field but others need the four character field), and if a code does appear then the field returns the index of the first appearance (we should be able to use this to determine which value to present first).

# Test the function
# df_processed_test <- df_raw %>% 
#   filter(str_detect(DIAG_3_CONCAT, 'F10')) %>% # do the codes appear
#   mutate(string_before = substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'F10') -1)) %>% # grab everything up to the position of the code list
#   mutate(how_many_commas = str_count(string_before, ',')) %>% # count how many commas before the string position (this will be 0 if the appropriate code is first)
#   mutate(`Mental and behavioural disorders due to use of alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'F10'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'F10') - 1), ',') +1, NA)) # All in one place

# Conditions where low levels of alcohol consumption are protective (have a negative alcohol-attributable fraction) are not included in the calculation of the indicator. 

# The broad definition for this indicator is - Admissions to hospital where the primary diagnosis or any of the secondary diagnoses are an alcohol-attributable code.

# More specifically, hospital admissions records are identified where the admission is a finished episode [epistat = 3]; the admission is an ordinary admission, day case or maternity [classpat = 1, 2 or 5]; it is an admission episode [epiorder = 1]; the sex of the patient is valid [sex = 1 or 2]; there is a valid age at start of episode [startage between 0 and 150 or between 7001 and 7007]; the region of residence is one of the English regions, no fixed abode or unknown [resgor<= K or U or Y]; the episode end date [epiend] falls within the financial year, and an alcohol-attributable ICD10 code appears in the primary diagnosis field [diag_01] or in any diagnosis field [diag_nn].

# For each episode identified, an alcohol-attributable fraction is applied based on the diagnostic codes, age group, and sex of the patient.  Where there is more than one alcohol-related ICD10 code among the 20 possible diagnostic codes the codes with the largest alcohol attributable fraction is selected; in the event of there being two or more codes with the same alcohol-attributable fraction within the same episode, the one from the lowest diagnostic position is selected. For a detailed list of all alcohol attributable diseases, including ICD 10 codes and relative risks see  'Alcohol-attributable fractions for England: an update' 

df_broad <- df_raw %>% 
  mutate(`Mental and behavioural disorders due to use of alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'F10'),  str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'F10') -1), ',') +1, NA)) %>%
  mutate(`Alcoholic liver disease` = ifelse(str_detect(DIAG_3_CONCAT, 'K70'),str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'K70')- 1), ',') +1 , NA)) %>% 
  mutate(`Ethanol poisoning` = ifelse(str_detect(DIAG_4_CONCAT, 'T510'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT,'T510')- 1), ',') +1 , NA)) %>% 
  mutate(`Methanol poisoning` = ifelse(str_detect(DIAG_4_CONCAT, 'T511'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'T511')- 1), ',') +1 , NA)) %>% 
  mutate(`Toxic effect of alcohol, unspecified` = ifelse(str_detect(DIAG_4_CONCAT, 'T519'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'T519')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcohol-induced pseudo-Cushings syndrome` = ifelse(str_detect(DIAG_4_CONCAT, 'E244'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'E244')- 1), ',') +1 , NA)) %>% 
  mutate(`Degeneration of nervous system due to alcohol` = ifelse(str_detect(DIAG_4_CONCAT, 'G312'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'G312')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic polyneuropathy` = ifelse(str_detect(DIAG_4_CONCAT, 'G621'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'G621')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic myopathy` = ifelse(str_detect(DIAG_4_CONCAT, 'G721'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'G721')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic cardiomyopathy` = ifelse(str_detect(DIAG_4_CONCAT, 'I426'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'I426')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic gastritis` = ifelse(str_detect(DIAG_4_CONCAT, 'K292'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K292')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcohol-induced acute pancreatitis` = ifelse(str_detect(DIAG_4_CONCAT, 'K852'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K852')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcohol-induced chronic pancreatitis` = ifelse(str_detect(DIAG_4_CONCAT, 'K860'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K860')- 1), ',') +1 , NA)) %>% 
  mutate(`Fetal alcohol syndrome (dysmorphic)` = ifelse(str_detect(DIAG_4_CONCAT, 'Q860'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'Q860')- 1), ',') +1 , NA)) %>% 
  mutate(`Excess alcohol blood levels` = ifelse(str_detect(DIAG_4_CONCAT, 'R780'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'R780')- 1), ',') +1 , NA)) %>% 
  mutate(`Accidental poisoning by and exposure to alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'X45'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X45')- 1), ',') +1 , NA)) %>% 
  mutate(`Intentional self-poisoning by and exposure to alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'X65'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X65')- 1), ',') +1 , NA)) %>% 
  mutate(`Poisoning by and exposure to alcohol, undetermined intent` = ifelse(str_detect(DIAG_3_CONCAT, 'Y15'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y15')- 1), ',') +1 , NA)) %>% 
  mutate(`Evidence of alcohol involvement determined by blood alcohol level` = ifelse(str_detect(DIAG_3_CONCAT, 'Y90'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y90')- 1), ',') +1 , NA)) %>% 
  mutate(`Evidence of alcohol involvement determined by level of intoxication` = ifelse(str_detect(DIAG_3_CONCAT, 'Y91'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y91')- 1), ',') +1 , NA)) %>% 
  mutate(Tuberculosis = ifelse(str_detect(DIAG_3_CONCAT, 'A1[56789]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'A1[56789]')- 1), ',') +1 , NA)) %>% 
  mutate(`Lip, oral cavity and pharynx` = ifelse(str_detect(DIAG_3_CONCAT, 'C0[0-9]|C1[0-4]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C0[0-9]|C1[0-4]')- 1), ',') +1 , NA)) %>% 
  mutate(Oesophagus = ifelse(str_detect(DIAG_3_CONCAT, 'C15'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C15')- 1), ',') +1 , NA)) %>% 
  mutate(Colon = ifelse(str_detect(DIAG_3_CONCAT, 'C18'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C18')- 1), ',') +1 , NA)) %>% 
  mutate(Rectum = ifelse(str_detect(DIAG_3_CONCAT, 'C20'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C20')- 1), ',') +1 , NA)) %>% 
  mutate(`Liver and intrahepatic bile ducts` = ifelse(str_detect(DIAG_3_CONCAT, 'C22'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C22')- 1), ',') +1 , NA)) %>% 
  mutate(Larynx = ifelse(str_detect(DIAG_3_CONCAT, 'C32'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C32')- 1), ',') +1 , NA)) %>% 
  mutate(Breast = ifelse(str_detect(DIAG_3_CONCAT, 'C50'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'C50')- 1), ',') +1 , NA)) %>% 
 # mutate(`Type 2 diabetes mellitus` = ifelse(str_detect(DIAG_3_CONCAT, 'E11'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'E11')- 1), ',') +1 , NA)) %>% 
  mutate(`Epilepsy and Status epilepticus` = ifelse(str_detect(DIAG_3_CONCAT, 'G4[01]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'G4[01]')- 1), ',') +1 , NA)) %>% 
  mutate(`Hypertensive diseases` = ifelse(str_detect(DIAG_3_CONCAT, 'I1[0-5]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'I1[0-5]')- 1), ',') +1 , NA)) %>% 
 # mutate(`Ischaemic heart disease` = ifelse(str_detect(DIAG_3_CONCAT, 'I2[0-5]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'I2[0-5]')- 1), ',') +1 , NA)) %>% 
  mutate(`Cardiac arrhythmias` = ifelse(str_detect(DIAG_3_CONCAT, 'I4[78]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'I4[78]')- 1), ',') +1 , NA)) %>% 
  mutate(`Heart failure` = ifelse(str_detect(DIAG_3_CONCAT, 'I5[01]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'I5[01]')- 1), ',') +1 , NA)) %>% 
 mutate(`Ischaemic stroke` = ifelse(str_detect(DIAG_4_CONCAT, 'I6[3-6]|I69[34]'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'I6[3-6]|I69[34]')- 1), ',') +1 , NA)) %>% 
  mutate(`Haemorrhagic stroke` = ifelse(str_detect(DIAG_4_CONCAT, 'I6[0-2]|I69[0-2]'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'I6[0-2]|I69[0-2]')- 1), ',') +1 , NA)) %>% 
  mutate(`Oesophageal varices` = ifelse(str_detect(DIAG_3_CONCAT, 'I85'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'I85')- 1), ',') +1 , NA)) %>% 
  mutate(Pneumonia = ifelse(str_detect(DIAG_4_CONCAT, 'J1[01]0|J1[2-5]|J18'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'J1[01]0|J1[2-5]|J18')- 1), ',') +1 , NA)) %>% 
  mutate(`Unspecified liver disease` = ifelse(str_detect(DIAG_3_CONCAT, 'K7[34]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'K7[34]')- 1), ',') +1 , NA)) %>% 
 # mutate(`Cholelithiasis (gall stones)` = ifelse(str_detect(DIAG_3_CONCAT, 'K80'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'K80')- 1), ',') +1 , NA)) %>% # negative AAFs
  mutate(`Acute and chronic pancreatitis` = ifelse(str_detect(DIAG_4_CONCAT, 'K85[01]|K85[3-9]|K861'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K85[01]|K85[3-9]|K861')- 1), ',') +1 , NA)) %>% 
  mutate(`Spontaneous abortion` = ifelse(str_detect(DIAG_3_CONCAT, 'O03'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'O03')- 1), ',') +1 , NA)) %>% 
  mutate(`Low birth weight` = ifelse(str_detect(DIAG_3_CONCAT, 'P0[5-7]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'P0[5-7]')- 1), ',') +1 , NA)) %>% 
  mutate(`Road/pedestrian traffic accidents` = ifelse(str_detect(DIAG_4_CONCAT, 'V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')- 1), ',') +1 , NA))  %>% 
  mutate(Poisoning = ifelse(str_detect(DIAG_3_CONCAT, 'X4[0-4]|X4[6-9]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X4[0-4]|X4[6-9]') - 1), ',') +1,  NA)) %>% 
  mutate(`Falls` = ifelse(str_detect(DIAG_3_CONCAT, 'W[01][0-9]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'W[01][0-9]')- 1), ',') +1 , NA)) %>% 
  mutate(Fires = ifelse(str_detect(DIAG_3_CONCAT, 'X0[0-9]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X0[0-9]')- 1), ',') +1 , NA)) %>%   
  mutate(Drowning = ifelse(str_detect(DIAG_3_CONCAT, 'W6[5-9]|W7[0-4]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'W6[5-9]|W7[0-4]')- 1), ',') +1 , NA)) %>%   
  mutate(`Other unintentional injuries` = ifelse(str_detect(DIAG_4_CONCAT, 'V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')- 1), ',') +1 , NA)) %>%   
  mutate(`Intentional self-harm` = ifelse(str_detect(DIAG_4_CONCAT, 'X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')- 1), ',') +1 , NA)) %>%   
  mutate(`Event of undetermined intent` = ifelse(str_detect(DIAG_4_CONCAT, 'Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')- 1), ',') +1 , NA)) %>%   
  mutate(Assault = ifelse(str_detect(DIAG_4_CONCAT, 'X8[5-9]|X9|Y0|Y871'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'X8[5-9]|X9|Y0|Y871')- 1), ',') +1 , NA)) 

# We have added booleen fields for each alcohol attributable condition

# We can take the derived booleen fields, pivot the table to show one row per episode (epikey) and condition.
# Position will be blank if it wasn't flagged and will have a number between 1 and 20 if it appeared which denotes the diagnoses field position.
# We will then delete the blank position values
# There are almost 90000 Alcohol related Condition codes which were protective (negative AAF), these are excluded from the condition list because they do not count towards summing the admissions. However the ICD-10 codes for these conditions are included in the query so once we left join the condition list to the table, we need to filter out where the Fraction is blank (which means we excluded it from the condition list)
# From the number of records left for each episode, we can then compute the number of, and order by which the *ALCOHOL RELATED CONDIDITIONS* appear in the diagnosis fields - this excludes non alcohol related and alcohol related condition codes which were protective (negative AAF)
df_processed_broad <- df_broad %>% 
  select(EPIKEY, Sex = SEX, Age_group, `Mental and behavioural disorders due to use of alcohol`:Assault) %>% 
  pivot_longer(cols = `Mental and behavioural disorders due to use of alcohol`:Assault,
               names_to = 'Condition_name',
               values_to = 'Position') %>% # Position will be blank if it wasn't flagged and will have a number between 1 and 20 if it appeared which denotes the diagnoses field position.
  filter(!is.na(Position)) %>% 
  left_join(condition_fractions, by = c('Sex', 'Age_group', 'Condition_name')) %>% 
  filter(!is.na(Fraction)) %>% # There are almost 90000 Alcohol related Condition codes which were protective (negative AAF), these are excluded
  group_by(EPIKEY) %>% 
  arrange(Position) %>% 
  mutate(Number_of_alc_related_conditions = n(),
         Alcohol_condition_order_number = row_number()) %>% # compute the number of, and order by which the *ALCOHOL RELATED CONDIDITIONS* appear in the diagnosis fields - this excludes non alcohol related and alcohol related condition codes which were protective (negative AAF)
  arrange(Alcohol_condition_order_number) %>% 
  mutate(Highest_fraction = max(Fraction)) # What is the highest fraction for each episode

# Table of number of alcohol related diagnosis codes (positive AAF only)
number_of_alc_conditions_broad_by_episode <- df_processed_broad %>% 
  select(EPIKEY, Number_of_alc_related_conditions) %>% 
  unique() %>% 
  group_by(Number_of_alc_related_conditions) %>% 
  summarise(Episodes = n())

# We could (and should) stop at highest fraction as that is all we need to calculate the small area alcohol related admissions
df_processed_broad_to_join <- df_processed_broad %>% 
  select(EPIKEY, Highest_fraction, Number_of_alc_related_conditions) %>% 
  unique()

broad_final_df <- df_raw %>% 
  select(EPIKEY, PSEUDO_HESID, Sex = SEX, Age = STARTAGE_CALC, FYEAR, ADMIDATE, EPIEND, EPIDUR, LSOA11CD = LSOA11, GP = GPPRAC) %>% 
  mutate(Age_group = ifelse(Age <= 4, "0-4 years", ifelse(Age <= 9, "5-9 years", ifelse(Age <= 14, "10-14 years", ifelse(Age <= 19, "15-19 years", ifelse(Age <= 24, "20-24 years", ifelse(Age <= 29, "25-29 years",ifelse(Age <= 34, "30-34 years", ifelse(Age <= 39, "35-39 years",ifelse(Age <= 44, "40-44 years", ifelse(Age <= 49, "45-49 years",ifelse(Age <= 54, "50-54 years", ifelse(Age <= 59, "55-59 years",ifelse(Age <= 64, "60-64 years", ifelse(Age <= 69, "65-69 years",ifelse(Age <= 74, "70-74 years", ifelse(Age <= 79, "75-79 years",ifelse(Age <= 84, "80-84 years", "85+ years")))))))))))))))))) %>% 
  left_join(df_processed_broad_to_join, by = 'EPIKEY') %>% 
  filter(!is.na(Number_of_alc_related_conditions)) %>% 
  group_by(PSEUDO_HESID, FYEAR) %>% 
  mutate(Number_of_alc_related_episodes_in_year = n())

# df_raw %>% filter(EPIKEY == '701165064053') %>% View()

# Some patients have hundreds of alcohol related admission episodes
broad_text_1 <- paste0('From 2011/12 to 2021/22 (provisionally and subject to change) there were ', format(length(unique(broad_final_df$EPIKEY)), big.mark = ','), ' episodes with at least one alcohol attributable condition among ', format(length(unique(broad_final_df$PSEUDO_HESID)), big.mark = ','), ' uniquely identified patients. Some patients have hundreds of alcohol attributable admissions over this 10 year period although on average patients have ', round(nrow(broad_final_df) / length(unique(broad_final_df$PSEUDO_HESID)), 1), ' episodes.')

by_person_broad_admission_episodes <- broad_final_df %>% 
  group_by(PSEUDO_HESID, FYEAR) %>% 
  summarise(Episodes = n()) %>% 
  mutate(All_time = sum(Episodes, na.rm = TRUE)) %>% 
  ungroup() %>% 
  arrange(FYEAR) %>% 
  pivot_wider(names_from = FYEAR,
              values_from = Episodes) %>% 
  arrange(desc(All_time)) %>% 
  mutate_at(vars(3:ncol(.)), ~replacings_the_nas(.))

rm(df_processed_broad, df_processed_broad_to_join, df_broad)

# Narrow definition alcohol-related hospital admissions ####

# Admissions to hospital where the primary diagnosis is an alcohol-attributable code or a secondary diagnosis is an alcohol-attributable external cause code. 

# External causes are anything with an ICD code starting with S, T, V, X , or Y
external_aaf <- local_aaf %>%
  filter(str_detect(ICD10_Code, '[STVXY]'))

# Search only DIAG_3_01 or DIAG_4_01 for internal cause codes
df_narrow <- df_raw %>% 
  mutate(`Mental and behavioural disorders due to use of alcohol` = ifelse(str_detect(DIAG_3_01, 'F10'), 1, NA)) %>%
  mutate(`Alcoholic liver disease` = ifelse(str_detect(DIAG_3_01, 'K70'), 1, NA)) %>% 
  mutate(`Alcohol-induced pseudo-Cushings syndrome` = ifelse(str_detect(DIAG_4_01, 'E244'), 1 , NA)) %>% 
  mutate(`Degeneration of nervous system due to alcohol` = ifelse(str_detect(DIAG_4_01, 'G312'), 1 , NA)) %>% 
  mutate(`Alcoholic polyneuropathy` = ifelse(str_detect(DIAG_4_01, 'G621'), 1 , NA)) %>% 
  mutate(`Alcoholic myopathy` = ifelse(str_detect(DIAG_4_01, 'G721'),1 , NA)) %>% 
  mutate(`Alcoholic cardiomyopathy` = ifelse(str_detect(DIAG_4_01, 'I426'), 1 , NA)) %>% 
  mutate(`Alcoholic gastritis` = ifelse(str_detect(DIAG_4_01, 'K292'),1 , NA)) %>% 
  mutate(`Alcohol-induced acute pancreatitis` = ifelse(str_detect(DIAG_4_01, 'K852'), 1 , NA)) %>%
  mutate(`Alcohol-induced chronic pancreatitis` = ifelse(str_detect(DIAG_4_01, 'K860'),1 , NA)) %>% 
  mutate(`Fetal alcohol syndrome (dysmorphic)` = ifelse(str_detect(DIAG_4_01, 'Q860'), 1 , NA)) %>% 
  mutate(`Excess alcohol blood levels` = ifelse(str_detect(DIAG_4_01, 'R780'), 1 , NA)) %>% 
  mutate(Tuberculosis = ifelse(str_detect(DIAG_3_01, 'A1[56789]'),1 , NA)) %>%   mutate(`Lip, oral cavity and pharynx` = ifelse(str_detect(DIAG_3_01, 'C0[0-9]|C1[0-4]'), 1 , NA)) %>% 
  mutate(Oesophagus = ifelse(str_detect(DIAG_3_01, 'C15'), 1 , NA)) %>% 
  mutate(Colon = ifelse(str_detect(DIAG_3_01, 'C18'), 1 , NA)) %>% 
  mutate(Rectum = ifelse(str_detect(DIAG_3_01, 'C20'), 1 , NA)) %>% 
  mutate(`Liver and intrahepatic bile ducts` = ifelse(str_detect(DIAG_3_01, 'C22'), 1 , NA)) %>% 
  mutate(Larynx = ifelse(str_detect(DIAG_3_01, 'C32'), 1 , NA)) %>% 
  mutate(Breast = ifelse(str_detect(DIAG_3_01, 'C50'), 1 , NA)) %>% 
  # mutate(`Type 2 diabetes mellitus` = ifelse(str_detect(DIAG_3_01, 'E11'),1 , NA)) %>% 
  mutate(`Epilepsy and Status epilepticus` = ifelse(str_detect(DIAG_3_01, 'G4[01]'), 1, NA)) %>% 
  mutate(`Hypertensive diseases` = ifelse(str_detect(DIAG_3_01, 'I1[0-5]'), 1, NA)) %>% 
  # mutate(`Ischaemic heart disease` = ifelse(str_detect(DIAG_3_01, 'I2[0-5]'), 1 , NA)) %>% 
  mutate(`Cardiac arrhythmias` = ifelse(str_detect(DIAG_3_01, 'I4[78]'), 1, NA)) %>% 
  mutate(`Heart failure` = ifelse(str_detect(DIAG_3_01, 'I5[01]'), 1, NA)) %>%   mutate(`Ischaemic stroke` = ifelse(str_detect(DIAG_4_01, 'I6[3-6]|I69[34]'), 1, NA)) %>% 
  mutate(`Haemorrhagic stroke` = ifelse(str_detect(DIAG_4_01, 'I6[0-2]|I69[0-2]'), 1 , NA)) %>% 
  mutate(`Oesophageal varices` = ifelse(str_detect(DIAG_3_01, 'I85'), 1, NA)) %>% 
  mutate(Pneumonia = ifelse(str_detect(DIAG_4_01, 'J1[01]0|J1[2-5]|J18'), 1, NA)) %>% 
  mutate(`Unspecified liver disease` = ifelse(str_detect(DIAG_3_01, 'K7[34]'), 1, NA)) %>% 
  # mutate(`Cholelithiasis (gall stones)` = ifelse(str_detect(DIAG_3_01, 'K80'), 1, NA)) %>% # negative AAFs
  mutate(`Acute and chronic pancreatitis` = ifelse(str_detect(DIAG_4_01, 'K85[01]|K85[3-9]|K861'), 1 , NA)) %>% 
  mutate(`Spontaneous abortion` = ifelse(str_detect(DIAG_3_01, 'O03'), 1, NA)) %>% 
  mutate(`Low birth weight` = ifelse(str_detect(DIAG_3_01, 'P0[5-7]'), 1, NA)) %>% 
  # Search anywhere for STVXY codes 
  mutate(`Ethanol poisoning` = ifelse(str_detect(DIAG_4_CONCAT, 'T510'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT,'T510')- 1), ',') +1 , NA)) %>% 
  mutate(`Methanol poisoning` = ifelse(str_detect(DIAG_4_CONCAT, 'T511'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'T511')- 1), ',') +1 , NA)) %>% 
  mutate(`Toxic effect of alcohol, unspecified` = ifelse(str_detect(DIAG_4_CONCAT, 'T519'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'T519')- 1), ',') +1 , NA)) %>% 
  mutate(`Accidental poisoning by and exposure to alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'X45'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X45')- 1), ',') +1 , NA)) %>% 
  mutate(`Intentional self-poisoning by and exposure to alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'X65'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X65')- 1), ',') +1 , NA)) %>% 
  mutate(`Poisoning by and exposure to alcohol, undetermined intent` = ifelse(str_detect(DIAG_3_CONCAT, 'Y15'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y15')- 1), ',') +1 , NA)) %>% 
  mutate(`Evidence of alcohol involvement determined by blood alcohol level` = ifelse(str_detect(DIAG_3_CONCAT, 'Y90'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y90')- 1), ',') +1 , NA)) %>% 
  mutate(`Evidence of alcohol involvement determined by level of intoxication` = ifelse(str_detect(DIAG_3_CONCAT, 'Y91'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y91')- 1), ',') +1 , NA)) %>% 
  mutate(`Road/pedestrian traffic accidents` = ifelse(str_detect(DIAG_4_CONCAT, 'V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')- 1), ',') +1 , NA))  %>% 
  mutate(Poisoning = ifelse(str_detect(DIAG_3_CONCAT, 'X4[0-4]|X4[6-9]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X4[0-4]|X4[6-9]') - 1), ',') +1,  NA)) %>% 
  mutate(`Falls` = ifelse(str_detect(DIAG_3_CONCAT, 'W[01][0-9]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'W[01][0-9]')- 1), ',') +1 , NA)) %>% 
  mutate(Fires = ifelse(str_detect(DIAG_3_CONCAT, 'X0[0-9]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X0[0-9]')- 1), ',') +1 , NA)) %>%   
  mutate(Drowning = ifelse(str_detect(DIAG_3_CONCAT, 'W6[5-9]|W7[0-4]'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'W6[5-9]|W7[0-4]')- 1), ',') +1 , NA)) %>%   
  mutate(`Other unintentional injuries` = ifelse(str_detect(DIAG_4_CONCAT, 'V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')- 1), ',') +1 , NA)) %>%   
  mutate(`Intentional self-harm` = ifelse(str_detect(DIAG_4_CONCAT, 'X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')- 1), ',') +1 , NA)) %>%   
  mutate(`Event of undetermined intent` = ifelse(str_detect(DIAG_4_CONCAT, 'Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')- 1), ',') +1 , NA)) %>%   
  mutate(Assault = ifelse(str_detect(DIAG_4_CONCAT, 'X8[5-9]|X9|Y0|Y871'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'X8[5-9]|X9|Y0|Y871')- 1), ',') +1 , NA)) 

df_processed_narrow <- df_narrow %>% 
  select(EPIKEY, Sex = SEX, Age_group, `Mental and behavioural disorders due to use of alcohol`:Assault) %>% 
  pivot_longer(cols = `Mental and behavioural disorders due to use of alcohol`:Assault,
               names_to = 'Condition_name',
               values_to = 'Position') %>% # Position will be blank if it wasn't flagged and will have a number between 1 and 20 if it appeared which denotes the diagnoses field position.
  filter(!is.na(Position)) %>% 
  left_join(condition_fractions, by = c('Sex', 'Age_group', 'Condition_name')) %>% 
  filter(!is.na(Fraction)) %>% # There are almost 90000 Alcohol related Condition codes which were protective (negative AAF), these are excluded
  group_by(EPIKEY) %>% 
  arrange(Position) %>% 
  mutate(Number_of_alc_related_conditions = n(),
         Alcohol_condition_order_number = row_number()) %>% # compute the number of, and order by which the *ALCOHOL RELATED CONDIDITIONS* appear in the diagnosis fields - this excludes non alcohol related and alcohol related condition codes which were protective (negative AAF)
  arrange(Alcohol_condition_order_number) %>% 
  mutate(Highest_fraction = max(Fraction)) # What is the highest fraction for each episode

# Table of number of alcohol related diagnosis codes (positive AAF only)
number_of_alc_conditions_narrow_by_episode <- df_processed_narrow %>% 
  select(EPIKEY, Number_of_alc_related_conditions) %>% 
  unique() %>% 
  group_by(Number_of_alc_related_conditions) %>% 
  summarise(Episodes = n())

# We could (and should) stop at highest fraction as that is all we need to calculate the small area alcohol related admissions
df_processed_narrow_to_join <- df_processed_narrow %>% 
  select(EPIKEY, Highest_fraction, Number_of_alc_related_conditions) %>% 
  unique()

narrow_final_df <- df_raw %>% 
  select(EPIKEY, PSEUDO_HESID, Sex = SEX, Age = STARTAGE_CALC, FYEAR, ADMIDATE, EPIEND, EPIDUR, LSOA11CD = LSOA11, GP = GPPRAC) %>% 
  mutate(Age_group = ifelse(Age <= 4, "0-4 years", ifelse(Age <= 9, "5-9 years", ifelse(Age <= 14, "10-14 years", ifelse(Age <= 19, "15-19 years", ifelse(Age <= 24, "20-24 years", ifelse(Age <= 29, "25-29 years",ifelse(Age <= 34, "30-34 years", ifelse(Age <= 39, "35-39 years",ifelse(Age <= 44, "40-44 years", ifelse(Age <= 49, "45-49 years",ifelse(Age <= 54, "50-54 years", ifelse(Age <= 59, "55-59 years",ifelse(Age <= 64, "60-64 years", ifelse(Age <= 69, "65-69 years",ifelse(Age <= 74, "70-74 years", ifelse(Age <= 79, "75-79 years",ifelse(Age <= 84, "80-84 years", "85+ years")))))))))))))))))) %>% 
  left_join(df_processed_narrow_to_join, by = 'EPIKEY') %>% 
  filter(!is.na(Number_of_alc_related_conditions)) %>% 
  group_by(PSEUDO_HESID, FYEAR) %>% 
  mutate(Number_of_alc_related_episodes_in_year = n())

# Some patients have hundreds of alcohol related admission episodes
narrow_text_1 <- paste0('From 2011/12 to 2021/22 (provisionally and subject to change) there were ', format(length(unique(narrow_final_df$EPIKEY)), big.mark = ','), ' episodes with at least one alcohol attributable condition among ', format(length(unique(narrow_final_df$PSEUDO_HESID)), big.mark = ','), ' uniquely identified patients. Some patients have hundreds of alcohol attributable admissions over this 10 year period although on average patients have ', round(nrow(narrow_final_df) / length(unique(narrow_final_df$PSEUDO_HESID)), 1), ' episodes.')

by_person_narrow_admission_episodes <- narrow_final_df %>% 
  group_by(PSEUDO_HESID, FYEAR) %>% 
  summarise(Episodes = n()) %>% 
  mutate(All_time = sum(Episodes, na.rm = TRUE)) %>% 
  ungroup() %>% 
  arrange(FYEAR) %>% 
  pivot_wider(names_from = FYEAR,
              values_from = Episodes) %>% 
  arrange(desc(All_time)) %>% 
  mutate_at(vars(3:ncol(.)), ~replacings_the_nas(.))

rm(df_narrow, df_processed_narrow, df_processed_narrow_to_join)

# Alcohol-specific hospital admissions (wholly attributable conditions) ####
alcohol_specific_aaf <- local_aaf %>%
  filter(Fraction == 1) %>% 
  select(Group, Condition_name, ICD10_Code, Fraction) %>% 
  unique()

df_specific <- df_raw %>% 
  mutate(`Mental and behavioural disorders due to use of alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'F10'),  str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'F10') -1), ',') +1, NA)) %>%
  mutate(`Alcoholic liver disease` = ifelse(str_detect(DIAG_3_CONCAT, 'K70'),str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'K70')- 1), ',') +1 , NA)) %>% 
  mutate(`Ethanol poisoning` = ifelse(str_detect(DIAG_4_CONCAT, 'T510'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT,'T510')- 1), ',') +1 , NA)) %>% 
  mutate(`Methanol poisoning` = ifelse(str_detect(DIAG_4_CONCAT, 'T511'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'T511')- 1), ',') +1 , NA)) %>% 
  mutate(`Toxic effect of alcohol, unspecified` = ifelse(str_detect(DIAG_4_CONCAT, 'T519'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'T519')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcohol-induced pseudo-Cushings syndrome` = ifelse(str_detect(DIAG_4_CONCAT, 'E244'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'E244')- 1), ',') +1 , NA)) %>% 
  mutate(`Degeneration of nervous system due to alcohol` = ifelse(str_detect(DIAG_4_CONCAT, 'G312'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'G312')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic polyneuropathy` = ifelse(str_detect(DIAG_4_CONCAT, 'G621'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'G621')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic myopathy` = ifelse(str_detect(DIAG_4_CONCAT, 'G721'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'G721')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic cardiomyopathy` = ifelse(str_detect(DIAG_4_CONCAT, 'I426'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'I426')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcoholic gastritis` = ifelse(str_detect(DIAG_4_CONCAT, 'K292'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K292')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcohol-induced acute pancreatitis` = ifelse(str_detect(DIAG_4_CONCAT, 'K852'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K852')- 1), ',') +1 , NA)) %>% 
  mutate(`Alcohol-induced chronic pancreatitis` = ifelse(str_detect(DIAG_4_CONCAT, 'K860'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'K860')- 1), ',') +1 , NA)) %>% 
  mutate(`Fetal alcohol syndrome (dysmorphic)` = ifelse(str_detect(DIAG_4_CONCAT, 'Q860'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'Q860')- 1), ',') +1 , NA)) %>% 
  mutate(`Excess alcohol blood levels` = ifelse(str_detect(DIAG_4_CONCAT, 'R780'), str_count(substr(DIAG_4_CONCAT, 1, str_locate(DIAG_4_CONCAT, 'R780')- 1), ',') +1 , NA)) %>% 
  mutate(`Accidental poisoning by and exposure to alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'X45'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X45')- 1), ',') +1 , NA)) %>% 
  mutate(`Intentional self-poisoning by and exposure to alcohol` = ifelse(str_detect(DIAG_3_CONCAT, 'X65'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'X65')- 1), ',') +1 , NA)) %>% 
  mutate(`Poisoning by and exposure to alcohol, undetermined intent` = ifelse(str_detect(DIAG_3_CONCAT, 'Y15'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y15')- 1), ',') +1 , NA)) %>% 
  mutate(`Evidence of alcohol involvement determined by blood alcohol level` = ifelse(str_detect(DIAG_3_CONCAT, 'Y90'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y90')- 1), ',') +1 , NA)) %>% 
  mutate(`Evidence of alcohol involvement determined by level of intoxication` = ifelse(str_detect(DIAG_3_CONCAT, 'Y91'), str_count(substr(DIAG_3_CONCAT, 1, str_locate(DIAG_3_CONCAT, 'Y91')- 1), ',') +1 , NA))

df_processed_specific <- df_specific %>% 
  select(EPIKEY, Sex = SEX, Age_group, `Mental and behavioural disorders due to use of alcohol`:`Evidence of alcohol involvement determined by level of intoxication`) %>% 
  pivot_longer(cols = `Mental and behavioural disorders due to use of alcohol`:`Evidence of alcohol involvement determined by level of intoxication`,
               names_to = 'Condition_name',
               values_to = 'Position') %>% # Position will be blank if it wasn't flagged and will have a number between 1 and 20 if it appeared which denotes the diagnoses field position.
  filter(!is.na(Position)) %>% 
  left_join(condition_fractions, by = c('Sex', 'Age_group', 'Condition_name')) %>% 
  filter(!is.na(Fraction)) %>% # There are almost 90000 Alcohol related Condition codes which were protective (negative AAF), these are excluded
  group_by(EPIKEY) %>% 
  arrange(Position) %>% 
  mutate(Number_of_alc_specific_conditions = n(),
         Alcohol_condition_order_number = row_number()) %>% # compute the number of, and order by which the *ALCOHOL RELATED CONDIDITIONS* appear in the diagnosis fields - this excludes non alcohol related and alcohol related condition codes which were protective (negative AAF)
  arrange(Alcohol_condition_order_number) %>% 
  mutate(Highest_fraction = max(Fraction)) # What is the highest fraction for each episode

# Table of number of alcohol related diagnosis codes (positive AAF only)
number_of_alc_specific_conditions_by_episode <- df_processed_specific %>% 
  select(EPIKEY, Number_of_alc_specific_conditions) %>% 
  unique() %>% 
  group_by(Number_of_alc_specific_conditions) %>% 
  summarise(Episodes = n())

# We could (and should) stop at highest fraction as that is all we need to calculate the small area alcohol related admissions
df_processed_specific_to_join <- df_processed_specific %>% 
  select(EPIKEY, Number_of_alc_specific_conditions) %>% 
  unique()

specific_final_df <- df_raw %>% 
  select(EPIKEY, PSEUDO_HESID, Sex = SEX, Age = STARTAGE_CALC, FYEAR, ADMIDATE, EPIEND, EPIDUR, LSOA11CD = LSOA11, GP = GPPRAC) %>% 
  mutate(Age_group = ifelse(Age <= 4, "0-4 years", ifelse(Age <= 9, "5-9 years", ifelse(Age <= 14, "10-14 years", ifelse(Age <= 19, "15-19 years", ifelse(Age <= 24, "20-24 years", ifelse(Age <= 29, "25-29 years",ifelse(Age <= 34, "30-34 years", ifelse(Age <= 39, "35-39 years",ifelse(Age <= 44, "40-44 years", ifelse(Age <= 49, "45-49 years",ifelse(Age <= 54, "50-54 years", ifelse(Age <= 59, "55-59 years",ifelse(Age <= 64, "60-64 years", ifelse(Age <= 69, "65-69 years",ifelse(Age <= 74, "70-74 years", ifelse(Age <= 79, "75-79 years",ifelse(Age <= 84, "80-84 years", "85+ years")))))))))))))))))) %>% 
  left_join(df_processed_specific_to_join, by = 'EPIKEY') %>% 
  filter(!is.na(Number_of_alc_specific_conditions)) %>% 
  group_by(PSEUDO_HESID, FYEAR) %>% 
  mutate(Number_of_alc_specific_episodes_in_year = n())

# Some patients have hundreds of alcohol related admission episodes
specific_text_1 <- paste0('From 2011/12 to 2021/22 (provisionally and subject to change) there were ', format(length(unique(specific_final_df$EPIKEY)), big.mark = ','), ' episodes with at least one alcohol specific attributable condition among ', format(length(unique(specific_final_df$PSEUDO_HESID)), big.mark = ','), ' uniquely identified patients. Some patients have hundreds of alcohol attributable specific admissions over this 10 year period although on average patients have ', round(nrow(specific_final_df) / length(unique(specific_final_df$PSEUDO_HESID)), 1), ' episodes.')

rm(df_specific, df_processed_specific, df_processed_specific_to_join)

# We have our three record level datasets ####
specific_final_df
narrow_final_df
broad_final_df

specific_final_df %>% 
  filter(FYEAR == '2020/21') %>% 
  nrow()
# This matches counts from Fingertips

narrow_final_df %>% 
  ungroup() %>% 
  filter(FYEAR == '2020/21') %>% 
  summarise(Admissions = sum(Highest_fraction))

# Aggregated outputs

Wsx_alc_broad_by_FYEAR <- read_excel(paste0(local_store, 'LAPE_tables_England_22.xlsx'), 
                                     sheet = '1.3',
                                     skip = 1) %>% 
  select(Area_Name = `Region and LA Name`, `1617` = `All Persons Admissions 2016/17`, `1718` = `All Persons Admissions 2017/18`, `1819` = `All Persons Admissions 2018/19`, `1920` = `All Persons Admissions 2019/20`, `2021` = `All Persons Admissions 2020/21`) %>% 
  filter(Area_Name == 'West Sussex') %>% 
  pivot_longer(cols = 2:ncol(.),
               values_to = 'Official',
               names_to = 'FYEAR')

Admissions_by_FYEAR <- broad_final_df %>% 
  group_by(FYEAR) %>% 
  summarise(Alcohol_related_episodes = sum(Highest_fraction, na.rm = TRUE)) %>% 
  mutate(Alcohol_related_episodes = disclosure_control(Alcohol_related_episodes)) %>%
  mutate(FYEAR = as.character(FYEAR)) %>% 
  left_join(Wsx_alc_broad_by_FYEAR, by = 'FYEAR')

Admissions_by_FYEAR %>% 
  write.csv(., paste0(local_store, '/West_Sussex_201620_Alc_related_admissions.csv'), row.names = FALSE)

WSx_admissions_alc_broad_by_age_sex <- broad_final_df %>% 
  mutate(Sex = factor(Sex, levels = c('Male', 'Female'))) %>% 
  mutate(Age_group = factor(Age_group, levels = c('0-4 years', '5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'))) %>% 
  group_by(Sex, Age_group) %>% 
  summarise(Alcohol_related_episodes = sum(Highest_fraction, na.rm = TRUE)) %>% 
  complete(Age_group, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s for the DSR (or at least there needs to be the same number of records for each group later)
  complete(Sex, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s
  unique() %>% 
  left_join(wsx_mye, by = c('Sex', 'Age_group')) %>% 
  left_join(esp_2013_19_cat, by = 'Age_group')

# Small area outputs

LSOA_admissions_alc_broad <- broad_final_df %>% 
  group_by(LSOA11CD) %>% 
  summarise(Alcohol_related_episodes = sum(Highest_fraction, na.rm = TRUE))

LSOA_admissions_alc_broad_by_age_sex <- broad_final_df %>% 
  mutate(Sex = factor(Sex, levels = c('Male', 'Female'))) %>% 
  mutate(Age_group = factor(Age_group, levels = c('0-4 years', '5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'))) %>% 
  group_by(LSOA11CD, Sex, Age_group) %>% 
  summarise(Alcohol_related_episodes = sum(Highest_fraction, na.rm = TRUE)) %>% 
  complete(Age_group, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s for the DSR (or at least there needs to be the same number of records for each group later)
  complete(Sex, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s
  unique() %>% 
  left_join(lsoa_mye[c('LSOA11CD', 'LSOA11NM', 'Sex', 'Age_group', '2016_20')], by = c('LSOA11CD', 'Sex', 'Age_group')) %>% 
  left_join(IMD_2019, by = 'LSOA11CD') %>% # It might be good to add LTLA and deprivation data 
  left_join(esp_2013_19_cat, by = 'Age_group')

# LSOA_admissions_alc_broad_by_age_sex %>% 
#   group_by(LSOA11CD) %>% 
#   summarise(n())

Wards_admissions_alc_broad_by_age_sex <- broad_final_df %>% 
  mutate(Sex = factor(Sex, levels = c('Male', 'Female'))) %>% 
  mutate(Age_group = factor(Age_group, levels = c('0-4 years', '5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'))) %>% 
  group_by(LSOA11CD, Sex, Age_group) %>% 
  summarise(Alcohol_related_episodes = sum(Highest_fraction, na.rm = TRUE)) %>% 
  complete(Age_group, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s
  complete(Sex, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s
  unique() %>% 
  ungroup() %>% 
  left_join(lsoa_mye[c('LSOA11CD', 'Sex', 'Age_group', '2016_20')], by = c('LSOA11CD', 'Sex', 'Age_group')) %>%
  left_join(LSOA11_WD21, by = 'LSOA11CD') %>% 
  group_by(WD21CD, WD21NM, LTLA, Sex, Age_group) %>% 
  summarise(Alcohol_related_episodes = sum(Alcohol_related_episodes, na.rm = TRUE),
            `2016_20` = sum(`2016_20`, na.rm = TRUE)) %>% 
  left_join(esp_2013_19_cat, by = 'Age_group')

LTLA_admissions_alc_broad_by_age_sex <- broad_final_df %>% 
  mutate(Sex = factor(Sex, levels = c('Male', 'Female'))) %>% 
  mutate(Age_group = factor(Age_group, levels = c('0-4 years', '5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85+ years'))) %>% 
  group_by(LSOA11CD, Sex, Age_group) %>% 
  summarise(Alcohol_related_episodes = sum(Highest_fraction, na.rm = TRUE)) %>% 
  complete(Age_group, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s
  complete(Sex, fill = list(Alcohol_related_episodes = 0)) %>% # we need to preserve the 0s
  unique() %>% 
  ungroup() %>% 
  left_join(lsoa_mye[c('LSOA11CD', 'Sex', 'Age_group', '2016_20')], by = c('LSOA11CD', 'Sex', 'Age_group')) %>%
  left_join(LSOA11_WD21, by = 'LSOA11CD') %>% 
  group_by(LTLA, Sex, Age_group) %>% 
  summarise(Alcohol_related_episodes = sum(Alcohol_related_episodes, na.rm = TRUE),
            `2016_20` = sum(`2016_20`, na.rm = TRUE)) %>% 
  left_join(esp_2013_19_cat, by = 'Age_group')

# Standardising outputs

# MYE data from nomis is at 5 year age bands but aggregates 85+, and as such I have had to aggregate the ESP for 85-89, 90-94 and 95+. I could get SYOA tables from ONS

dsrs_wsx = WSx_admissions_alc_broad_by_age_sex %>% 
  ungroup() %>% 
  phe_dsr(., 
          x = Alcohol_related_episodes,
          n = `2016_20`,
          stdpop = Standard_population,
          stdpoptype = "field", 
          confidence = 0.95, 
          multiplier = 100000, 
          type = "full") %>% 
  mutate(Year = '2016/17 to 2020/21',
         Area_Name = 'West Sussex') %>%
  rename(wsx_dsr = value,
         wsx_lci = lowercl,
         wsx_uci = uppercl)

dsrs_wsx_ltlas = LTLA_admissions_alc_broad_by_age_sex %>% 
  group_by(LTLA) %>% 
  phe_dsr(., 
          x = Alcohol_related_episodes,
          n = `2016_20`,
          stdpop = Standard_population,
          stdpoptype = "field", 
          confidence = 0.95, 
          multiplier = 100000, 
          type = "full") %>% 
  mutate(Year = '2016/17 to 2020/21',
         Area_Name = 'West Sussex') %>%
  rename(wsx_dsr = value,
         wsx_lci = lowercl,
         wsx_uci = uppercl)

# dsrs_wsx %>% 
  # write.csv(., './old_dsrs_wsx.csv', row.names = FALSE)

dsrs_lsoa <- LSOA_admissions_alc_broad_by_age_sex %>% 
  group_by(LSOA11CD, LSOA11NM, LTLA, IMD_Decile) %>%
  phe_dsr(., 
          x = Alcohol_related_episodes,
          n = `2016_20`,
          stdpop = Standard_population,
          stdpoptype = "field", 
          confidence = 0.95, 
          multiplier = 100000, 
          type = "full") %>% 
  mutate(Year = '2016/17 to 2020/21') %>% 
  bind_cols(dsrs_wsx[c('wsx_dsr', 'wsx_lci', 'wsx_uci')]) %>% 
  mutate(Alcohol_related_episodes = disclosure_control(total_count)) %>% 
  mutate(Significance = ifelse(lowercl > wsx_uci, 'Significantly higher', ifelse(uppercl < wsx_lci, 'Significantly lower', 'Similar'))) %>% 
  select(LSOA11CD, LSOA11NM, LTLA, IMD_Decile, Alcohol_related_episodes, Rate = value, Lower_CI = lowercl, Upper_CI = uppercl, Significance)

dsrs_wards <- Wards_admissions_alc_broad_by_age_sex %>% 
  group_by(WD21CD, WD21NM, LTLA) %>%
  phe_dsr(., 
          x = Alcohol_related_episodes,
          n = `2016_20`,
          stdpop = Standard_population,
          stdpoptype = "field", 
          confidence = 0.95, 
          multiplier = 100000, 
          type = "full") %>% 
  mutate(Year = '2016/17 to 2020/21') %>% 
  bind_cols(dsrs_wsx[c('wsx_dsr', 'wsx_lci', 'wsx_uci')]) %>% 
  mutate(Alcohol_related_episodes = disclosure_control(total_count)) %>% 
  mutate(Significance = ifelse(lowercl > wsx_uci, 'Significantly higher', ifelse(uppercl < wsx_lci, 'Significantly lower', 'Similar'))) %>% 
  select(WD21CD, WD21NM, LTLA, Alcohol_related_episodes, Rate = value, Lower_CI = lowercl, Upper_CI = uppercl, Significance)

dsrs_wards %>% 
  arrange(Rate) %>% 
  View()

# dsrs_wards %>% 
#   write.csv(., './old_dsrs_wsxwards.csv', row.names = FALSE)

# visualising outputs
map_theme = function(){
  theme( 
    legend.position = "bottom", 
    legend.key.size = unit(.75,"line"),
    legend.title = element_text(size = 8, face = 'bold'),
    plot.background = element_blank(), 
    plot.title.position = "plot",
    panel.background = element_blank(),  
    panel.border = element_blank(),
    axis.text = element_blank(), 
    plot.title = element_text(colour = "#000000", face = "bold", size = 11), 
    plot.subtitle = element_text(colour = "#000000", size = 10), 
    axis.title = element_blank(),     
    panel.grid.major.x = element_blank(), 
    panel.grid.minor.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(), 
    strip.text = element_text(colour = "white"), 
    strip.background = element_rect(fill = "#ffffff"), 
    axis.ticks = element_blank()
  ) 
} 

# This will read in the boundaries (in a geojson format) from Open Geography Portal
query <- 'https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_GB_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson'

lad_boundaries_sf <- st_read(query) %>% 
  filter(LAD21NM %in% c('Adur', 'Arun', 'Chichester','Crawley','Horsham','Mid Sussex', 'Worthing')) 

lad_boundaries_spdf <- as_Spatial(lad_boundaries_sf, IDs = lad_boundaries_sf$LAD21NM)

lad_boundary_ggplot <- lad_boundaries_spdf %>%   
  fortify(region = "LAD21NM") %>% 
  rename(LAD19NM = id) 

ggplot()+
  geom_polygon(data = lad_boundary_ggplot,
               aes(x = long,  y = lat, group = group, fill = LAD19NM),
               size = 0.25,
               show.legend = TRUE,
               colour = "lightgrey") +
  map_theme() +
  coord_fixed(1.5)

lsoa_spdf <- geojson_read("https://opendata.arcgis.com/datasets/8bbadffa6ddc493a94078c195a1e293b_0.geojson",  what = "sp") %>%
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_boundary_ggplot <- lsoa_spdf %>%   
  fortify(region = "LSOA11CD") %>% 
  rename(LSOA11CD = id) %>% 
  left_join(dsrs_lsoa, by = 'LSOA11CD')

ggplot()+
  geom_polygon(data = lsoa_boundary_ggplot,
               aes(x = long, 
                   y = lat,
                   group = group, 
                   fill = Significance),
               show.legend = TRUE,
               colour = NA) +
  labs(title = "Age-standardised rate of alcohol-related admissions; West Sussex LSOAs",
     subtitle =  "(2016/17 to 2020/21 aggregated data)",
     fill = "Sig vs. West Sussex:") +
  scale_fill_manual(values = c("Significantly higher" = "#EA4335", "Similar" = "#FFBB00", "Significantly lower" = "#7CBB00"), 
                    na.value = "grey", 
                    drop = FALSE) +
  geom_polygon(data = lad_boundary_ggplot, 
               aes(x = long, 
                   y = lat, 
                   group = group), 
               colour = "#000000", 
               fill = NA, 
               size = 0.5, 
               show.legend = FALSE) +
  coord_fixed(1.5) +
  map_theme()

# Wards 
query <- 'https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2021_GB_BSC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson'

ward_boundaries_sf <- st_read(query) %>% 
  filter(WD21CD %in% Wards_admissions_alc_broad_by_age_sex$WD21CD)

ward_boundaries_spdf <- as_Spatial(ward_boundaries_sf, IDs = ward_boundaries_sf$WD21CD)

ward_boundary_ggplot <- ward_boundaries_spdf %>%   
  fortify(region = "WD21CD") %>% 
  rename(WD21CD = id) %>% 
  left_join(dsrs_wards, by = 'WD21CD')

ward_broad_1 <- ggplot()+
  geom_polygon(data = ward_boundary_ggplot,
               aes(x = long, 
                   y = lat,
                   group = group, 
                   fill = Significance),
               show.legend = TRUE,
               colour = '#c9c9c9') +
  labs(title = "Age-standardised rate of alcohol-related admissions (broad definition);\nWest Sussex Wards (2021 boundaries)",
       subtitle =  "(2016/17 to 2020/21 aggregated data)",
       fill = "Rate compared to\nWest Sussex\noverall:") +
  scale_fill_manual(values = c("Significantly higher" = "#EA4335", "Similar" = "#FFBB00", "Significantly lower" = "#7CBB00"), 
                    na.value = "grey", 
                    drop = FALSE) +
  geom_polygon(data = lad_boundary_ggplot, 
               aes(x = long, 
                   y = lat, 
                   group = group), 
               colour = "#000000", 
               fill = NA, 
               size = 0.5, 
               show.legend = FALSE) +
  coord_fixed(1.5) +
  map_theme()

png(paste0(local_store,'/West_Sussex_overall_alc_related_admissions_broad_wards_2016_2022.png'),
    width = 1480,
    height = 1080,
    res = 190)
print(ward_broad_1)
dev.off()

# You can use the average lat/lng to create centroids for label positions
ward_boundary_centroids <- ward_boundary_ggplot %>% 
  group_by(WD21CD, WD21NM, LTLA, Significance) %>% 
  summarise(Longitude = mean(long, na.rm = TRUE),
            Latitude = mean(lat, na.rm = TRUE)) %>% 
  mutate(WD21NM_label = gsub('&', '&\n', WD21NM))

Crawley_wards_table <- dsrs_wards %>% 
  ungroup() %>% 
  filter(LTLA == 'Crawley') %>% 
  arrange(Rate) %>% 
  mutate(Rate_label = paste0(format(round(Rate, 0), big.mark = ','), ' (', format(round(Lower_CI,0), big.mark = ','), '-', format(round(Upper_CI,0), big.mark = ','), ')')) %>% 
  select(Ward = WD21NM, Code = WD21CD, 'Number of alcohol related episodes' = Alcohol_related_episodes, Rate = Rate_label, 'Compared to West Sussex'= Significance)

Crawley_wards_table %>% 
  write.csv(., paste0(local_store, '/Crawley_wards_table_alc_broad_2016_20.csv'), row.names = FALSE)

areas <- c('Adur', 'Arun', 'Crawley', '', 'Worthing')

Crawley_ward_broad_1 <- ggplot()+
  geom_polygon(data = subset(ward_boundary_ggplot, LTLA == areas[i]),
               aes(x = long, 
                   y = lat,
                   group = group, 
                   fill = Significance),
               show.legend = TRUE,
               colour = '#c9c9c9') +
  labs(title = paste0("Age-standardised rate of alcohol-related admissions (broad definition);\n", areas[i], ' Wards (2021 boundaries)'),
       subtitle =  "(2016/17 to 2020/21 aggregated data)",
       fill = "Rate compared to\nWest Sussex\noverall:") +
  scale_fill_manual(values = c("Significantly higher" = "#EA4335", "Similar" = "#FFBB00", "Significantly lower" = "#7CBB00"), 
                    na.value = "grey", 
                    drop = FALSE) +
  coord_fixed(1.5) +
  map_theme()

png(paste0(local_store,'/Crawley_overall_alc_related_admissions_broad_wards_2016_2022.png'),
    width = 1480,
    height = 1080,
    res = 190)
print(Crawley_ward_broad_1)
dev.off()

# TODO by age
# TODO conditions table 
# TODO by deprivation decile/quintile