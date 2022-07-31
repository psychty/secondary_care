# Code to retrieve publicly available registered population and organisation data 

# Load packages if not already loaded - see Initial_setup_to_query_SID.R for more detail
packages <- c('easypackages', 'tidyverse','readxl', 'readr', 'readODS', 'httr', 'rvest', 'scales')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# Define a directory for working documents/downloads etc
local_store <- '~/GitHub/secondary_care/local'
#local_store <- './secondary_care/local'

# Use dir.exists to see if you have a folder already
# dir.exists(local_store)

# Use an if statement to create the directory if it does not exist
if(dir.exists(local_store) == FALSE) {
  dir.create(local_store)
  print(paste0('The local directory for raw files on your machine (', local_store, ') appears to be missing, it has now been created.'))
}

script_store <- '~/GitHub/secondary_care/R_Scripts'

if(dir.exists(script_store) == FALSE) {
  print(paste0('The directory for R scripts on your machine (', script_store, ') appears to be missing, check or ammend the filepath script_store'))
}

output_store <- '~/GitHub/secondary_care/Outputs'

if(dir.exists(output_store) == FALSE) {
  dir.create(output_store)
  print(paste0('The directory for outputs on your machine (', output_store, ') appears to be missing, it has been created.'))
}

# PCN organisation data ####
# You may not want to download this every time you run the script, but it does get updated quarterly, and I am not sure there is a way to check if you have the latest one (I do not think there is a date as value on the file).
download.file(url = 'https://nhs-prod.global.ssl.fastly.net/binaries/content/assets/website-assets/services/ods/data-downloads-other-nhs-organisations/epcn.zip', 
              destfile = paste0(local_store, '/epcn.zip'), 
              mode = 'wb')
unzip(paste0(local_store, '/epcn.zip'), exdir = local_store)

PCN_metadata <- read_excel(paste0(local_store, "/ePCN.xlsx"),
                       sheet = 'PCNDetails') %>% 
  rename(PCN_Code = 'PCN Code',
         PCN_Name = 'PCN Name',
         Current_sub_ICB_code = 'Current Sub ICB Loc Code',
         Sub_ICB = 'Sub ICB Location',
         Open_date = 'Open Date',
         Close_date = 'Close Date') %>% 
  mutate(Open_date = paste(substr(Open_date, 1,4), substr(Open_date, 5,6), substr(Open_date, 7,8), sep = '-')) %>% 
  mutate(Open_date = as.Date(Open_date)) %>% 
  mutate(Close_date = paste(substr(Close_date, 1,4), substr(Close_date, 5,6), substr(Close_date, 7,8), sep = '-')) %>% 
  mutate(Close_date = as.Date(Close_date)) %>% 
  mutate(Address_label = gsub(', NA','', paste(str_to_title(`Address Line 1`), str_to_title(`Address Line 2`),str_to_title(`Address Line 3`),str_to_title(`Address Line 4`), Postcode, sep = ', '))) %>% 
  filter(Current_sub_ICB_code %in% c('70F', '97R', '09D')) %>%
  mutate(PCN_Name = gsub('\\(Aic\\)', '\\(AIC\\)', gsub('\\(Acf\\)', '\\(ACF\\)', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ',  str_to_title(PCN_Name))))))) %>% 
  select(PCN_Code, PCN_Name, Current_sub_ICB_code, Address_label, Postcode)

PCN_metadata %>% 
  write.csv(., paste0(output_store, '/PCN_metadata.csv'), row.names = FALSE)

# Get a lookup of practices to Sussex ICB PCNs
Practice_to_PCN_lookup <- read_excel(paste0(local_store, "/ePCN.xlsx"), 
                                     sheet = "PCN Core Partner Details") %>%
  rename(Partner_name = 'Partner\r\nName',
         PCN_Code = 'PCN Code',
         PCN_Name = 'PCN Name',
         ODS_Code = 'Partner\r\nOrganisation\r\nCode',
         Partner_Sub_ICB_name = 'Practice\r\nParent\r\nSub ICB Loc Name',
         Partner_Sub_ICB_code = 'Practice\r\nParent\r\nSub ICB Loc Code') %>% 
  mutate(Partner_name = gsub('\\(Aic\\)', '\\(AIC\\)', gsub('\\(Acf\\)', '\\(ACF\\)', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ',  str_to_title(Partner_name))))))) %>% 
  mutate(PCN_Name = gsub('\\(Aic\\)', '\\(AIC\\)', gsub('\\(Acf\\)', '\\(ACF\\)', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ',  str_to_title(PCN_Name))))))) %>% 
  mutate(Partner_Sub_ICB_name = gsub('Nhs', 'NHS', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ',  str_to_title(Partner_Sub_ICB_name)))))) %>%
  filter(PCN_Code %in% PCN_metadata$PCN_Code) 

Practice_to_PCN_lookup %>% 
  write.csv(., paste0(output_store, '/Sussex_practice_to_PCN_lookup.csv'), row.names = FALSE)

# GP Practice registered population ####

# This isn't the exact page we want but it does say what the latest publication date (and subsequent url) is
calls_patient_numbers_webpage <- read_html('https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice') %>%
  html_nodes("a") %>%
  html_attr("href")

# we know the actual page we want has a url which starts with the following string, so reduce the scraped list above to those which include it
calls_patient_numbers_webpage <- unique(grep('/data-and-information/publications/statistical/patients-registered-at-a-gp-practice', calls_patient_numbers_webpage, value = T))

# We also know that the top result will be the latest version (even though the second result is the next upcoming version)
calls_patient_numbers_webpage <- read_html(paste0('https://digital.nhs.uk/',calls_patient_numbers_webpage[1])) %>%
  html_nodes("a") %>%
  html_attr("href")

# Now we know that the file we want contains the string 'gp-reg-pat-prac-quin-age.csv' we can use that in the read_csv call.
# I have also tidied it a little bit by renaming the Sex field and giving R some meta data about the order in which the age groups should be
latest_sussex_gp_practice_numbers <- read_csv(unique(grep('gp-reg-pat-prac-quin-age.csv', calls_patient_numbers_webpage, value = T))) %>% 
  mutate(Sex = factor(ifelse(SEX == 'FEMALE', 'Female', ifelse(SEX == 'MALE', 'Male', ifelse(SEX == 'ALL', 'Persons', NA))), levels = c('Female', 'Male'))) %>%
  mutate(Age_group = factor(paste0(gsub('_', '-', AGE_GROUP_5), ' years'), levels = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90-94 years', '95+ years'))) %>% 
  filter(AGE_GROUP_5 != 'ALL') %>% 
  filter(Sex != 'Persons') %>% 
  rename(ODS_Code = ORG_CODE,
         Patients = NUMBER_OF_PATIENTS) %>% 
  select(EXTRACT_DATE, ODS_Code, Sex, Age_group, Patients) %>% 
  mutate(EXTRACT_DATE = paste0(ordinal(as.numeric(substr(EXTRACT_DATE,1,2))), ' ', substr(EXTRACT_DATE, 3,5), ' ', substr(EXTRACT_DATE, 6,10))) %>%   group_by(ODS_Code) %>% 
  mutate(Proportion = Patients / sum(Patients)) %>%  # We may also want to standardise the pyramid to compare bigger and smaller practices by their age structure
  ungroup() %>% 
  filter(ODS_Code %in% Practice_to_PCN_lookup$ODS_Code) %>% 
  left_join(Practice_to_PCN_lookup[c('ODS_Code', 'PCN_Code', 'PCN_Name')], by = 'ODS_Code')

sussex_practice_list_size_public <- latest_sussex_gp_practice_numbers %>% 
  group_by(ODS_Code, Sex) %>% 
  summarise(Patients = sum(Patients, na.rm = TRUE)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = 'Sex',
              values_from = 'Patients') %>% 
  mutate(Total = Male + Female)

latest_sussex_gp_practice_numbers %>% 
  write.csv(., paste0(output_store, '/latest_sussex_gp_practice_numbers.csv'), row.names = FALSE)

sussex_practice_list_size_public %>% 
  write.csv(., paste0(output_store, '/sussex_practice_list_size_public.csv'), row.names = FALSE)

lastest_sussex_PCN_numbers <- latest_sussex_gp_practice_numbers %>% 
  group_by(PCN_Code, PCN_Name, Sex, Age_group, EXTRACT_DATE) %>% 
  summarise(Patients = sum(Patients, na.rm = TRUE)) %>% 
  group_by(PCN_Code, PCN_Name) %>% 
  mutate(Proportion = Patients / sum(Patients))

sussex_PCN_list_size_public <- lastest_sussex_PCN_numbers %>% 
  group_by(PCN_Code, PCN_Name, Sex) %>% 
  summarise(Patients = sum(Patients, na.rm = TRUE)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = 'Sex',
              values_from = 'Patients') %>% 
  mutate(Total = Male + Female)

lastest_sussex_PCN_numbers %>% 
  write.csv(., paste0(output_store, '/latest_sussex_PCN_numbers.csv'), row.names = FALSE)

sussex_PCN_list_size_public %>% 
  write.csv(., paste0(output_store, '/sussex_PCN_list_size_public.csv'), row.names = FALSE)

# Quarterly publications in January, April, July and October will include Lower Layer Super Output Area (LSOA) populations.

Apr_22_five_year_age_sussex <- read_csv('https://files.digital.nhs.uk/CA/3F03AD/gp-reg-pat-prac-quin-age.csv') %>% 
  mutate(Sex = factor(ifelse(SEX == 'FEMALE', 'Female', ifelse(SEX == 'MALE', 'Male', ifelse(SEX == 'ALL', 'Persons', NA))), levels = c('Female', 'Male'))) %>%
  mutate(Age_group = factor(paste0(gsub('_', '-', AGE_GROUP_5), ' years'), levels = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90-94 years', '95+ years'))) %>% 
  filter(AGE_GROUP_5 != 'ALL') %>% 
  filter(Sex != 'Persons') %>% 
  rename(ODS_Code = ORG_CODE,
         Patients = NUMBER_OF_PATIENTS) %>% 
  select(EXTRACT_DATE, ODS_Code, Sex, Age_group, Patients) %>% 
  mutate(EXTRACT_DATE = paste0(ordinal(as.numeric(substr(EXTRACT_DATE,1,2))), ' ', substr(EXTRACT_DATE, 3,5), ' ', substr(EXTRACT_DATE, 6,10))) %>% 
  group_by(ODS_Code) %>% 
  mutate(Proportion = Patients / sum(Patients)) %>%  # We may also want to standardise the pyramid to compare bigger and smaller practices by their age structure
  ungroup() %>% 
  filter(ODS_Code %in% Practice_to_PCN_lookup$ODS_Code) %>% 
  left_join(Practice_to_PCN_lookup[c('ODS_Code', 'PCN_Code', 'PCN_Name')], by = 'ODS_Code')

Apr_22_practice_list_size_public_sussex <- Apr_22_five_year_age_sussex %>% 
  group_by(ODS_Code, Sex) %>% 
  summarise(Patients = sum(Patients, na.rm = TRUE)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = 'Sex',
              values_from = 'Patients') %>% 
  mutate(Total = Male + Female)

Apr_22_five_year_age_sussex %>% 
  write.csv(., paste0(output_store, '/Apr_22_five_year_age_sussex.csv'), row.names = FALSE)

Apr_22_practice_list_size_public_sussex %>% 
  write.csv(., paste0(output_store, '/Apr_22_practice_list_size_public_sussex.csv'), row.names = FALSE)

Apr_22_sussex_PCN_numbers <- Apr_22_five_year_age_sussex %>% 
  group_by(PCN_Code, PCN_Name, Sex, Age_group, EXTRACT_DATE) %>% 
  summarise(Patients = sum(Patients, na.rm = TRUE)) %>% 
  group_by(PCN_Code, PCN_Name) %>% 
  mutate(Proportion = Patients / sum(Patients))

Apr_22_sussex_PCN_list_size_public <- Apr_22_sussex_PCN_numbers %>% 
  group_by(PCN_Code, PCN_Name, Sex) %>% 
  summarise(Patients = sum(Patients, na.rm = TRUE)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = 'Sex',
              values_from = 'Patients') %>% 
  mutate(Total = Male + Female)

Apr_22_sussex_PCN_numbers %>% 
  write.csv(., paste0(output_store, '/sussex_PCN_numbers_Apr_22.csv'), row.names = FALSE)

Apr_22_sussex_PCN_list_size_public %>% 
  write.csv(., paste0(output_store, '/sussex_PCN_list_size_public_Apr_22.csv'), row.names = FALSE)

# LSOA

# It will be up to us to update the files, moving to July 22, October 22 and so on

# But we won't download the zip file every time, only if it has not been downloaded already
if(file.exists(paste0(local_store, '/April_22_GP_LSOA.zip')) == FALSE){
download.file(url = 'https://files.digital.nhs.uk/20/64261B/gp-reg-pat-prac-lsoa-male-female-April-22.zip',
              destfile = paste0(local_store, '/April_22_GP_LSOA.zip'),
              mode = 'wb')
unzip(paste0(local_store, '/April_22_GP_LSOA.zip'),
      exdir = local_store)  
}  

# Integrated Care Boards ####
download.file(url = 'https://digital.nhs.uk/binaries/content/assets/website-assets/services/ods/data-downloads-other-nhs-organisations/icb-partners-master.xlsx',
              destfile = paste0(local_store, '/ICB_lookup.xlsx'),
              mode = 'wb')

ICB_lookup <- read_excel("integrated_dataset_scripts/local/ICB_lookup.xlsx", 
                         sheet = "ICB Partners", skip = 4)

ICB_df <- ICB_lookup %>% 
  select(ICB_ODS_Code = 'ODS ICB Code', ICB_Boundary_Code = 'ONS ICB Boundary Code', ICB_Name = 'ICB Name') %>% 
  unique() %>% 
  mutate(ICB_Name = gsub('And', 'and',  gsub(' Of ', ' of ', gsub('Nhs ', 'NHS ', str_to_title(ICB_Name))))) %>% 
  add_row(ICB_ODS_Code = 'Q99', ICB_Name = 'Wales')

ICB_df %>% 
  write.csv(., paste0(output_store, '/ICB_metadata.csv'), row.names = FALSE)

# NHS Trusts, sites, and treatment centres ####
download.file(url = 'https://files.digital.nhs.uk/assets/ods/current/etr.zip',
              destfile = paste0(local_store, '/ETR.zip'),
              mode = 'wb')
unzip(paste0(local_store, '/ETR.zip'),
      exdir = local_store)  

trust_df <- read_csv(paste0(local_store, '/etr.csv'),
                     col_names = c('Trust_ODS_Code', 'Trust_Name', 'National_grouping', 'ICB_Code', 'Address_1', 'Address_2', 'Address_3', 'Address_4', 'Address_5', 'Postcode', 'Open_date', 'Close_date', 'NULL_1', 'NULL_2', 'NULL_3', 'NULL_4', 'NULL_5', 'Telephone', 'NULL_6', 'NULL_7', 'NULL_8',  'Ammended_record', 'NULL_9', 'Region', 'NULL_10', 'NULL_11', 'NULL_12')) %>% 
  mutate(Open_date = ifelse(is.na(Open_date), NA, paste(substr(Open_date, 1,4), substr(Open_date, 5,6), substr(Open_date, 7,8), sep = '-'))) %>% 
  mutate(Close_date = ifelse(is.na(Close_date), NA, paste(substr(Close_date, 1,4), substr(Close_date, 5,6), substr(Close_date, 7,8), sep = '-'))) %>%
  mutate(Open_date = as.Date(Open_date)) %>% 
  mutate(Close_date = as.Date(Close_date)) %>% 
  mutate(Address_label = gsub(', NA','', paste(str_to_title(Address_1), str_to_title(Address_2),str_to_title(Address_3),str_to_title(Address_4), str_to_title(Address_5), Postcode, sep = ', '))) %>% 
  mutate(Trust_Name = gsub('Cdc', 'CDC', gsub('Gp', 'GP', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ', gsub('Bdct ', 'BDCT ', gsub(' Eis ', ' EIS ', gsub(' Ld ', ' LD ', gsub(' Nhs', ' NHS', str_to_title(Trust_Name))))))))))) %>% 
  mutate(NHS_region = ifelse(National_grouping == 'Y56', 'London Commissioning Region', ifelse(National_grouping == 'Y58', 'South West Commissioning Region', ifelse(National_grouping == 'Y59', 'South East Commissioning Region', ifelse(National_grouping == 'Y60', 'Midlands Commissioning Region', ifelse(National_grouping == 'Y61', 'East of England Commissioning Region', ifelse(National_grouping == 'Y62', 'North West Commissioning Region', ifelse(National_grouping == 'Y63', 'North East and Yorkshire Commissioning Region', ifelse(National_grouping == 'W00', 'Wales', NA))))))))) %>% 
  left_join(ICB_df, by = c('ICB_Code' = 'ICB_ODS_Code')) %>% 
  select(Trust_ODS_Code, Trust_Name, Address_label, Postcode, National_grouping, NHS_region, ICB_Code, ICB_Name, Open_date, Close_date)

trust_df %>% 
  write.csv(., paste0(output_store, '/NHS_Trust_metadata.csv'), row.names = FALSE)

download.file(url = 'https://files.digital.nhs.uk/assets/ods/current/ets.zip',
              destfile = paste0(local_store, '/ETS.zip'),
              mode = 'wb')
unzip(paste0(local_store, '/ETS.zip'),
      exdir = local_store)  

trust_site_df <- read_csv(paste0(local_store, '/ets.csv'),
                     col_names = c('Site_ODS_Code', 'Site_Name', 'National_grouping', 'Higher_geography', 'Address_1', 'Address_2', 'Address_3', 'Address_4', 'Address_5', 'Postcode', 'Open_date', 'Close_date', 'NULL_1', 'Org_sub_type', 'Parent_NHS_Trust_Code', 'NULL_2', 'NULL_3', 'Telephone', 'NULL_4', 'NULL_5', 'NULL_6',  'Ammended_record', 'NULL_7', 'Region', 'NULL_10', 'NULL_11', 'NULL_12')) %>% 
  mutate(Org_sub_type = ifelse(Org_sub_type == 'M', 'Treatment Centre', ifelse(Org_sub_type == 'X', 'NHS PS Hospital ePACT Site', NA))) %>% 
  mutate(Open_date = ifelse(is.na(Open_date), NA, paste(substr(Open_date, 1,4), substr(Open_date, 5,6), substr(Open_date, 7,8), sep = '-'))) %>% 
  mutate(Close_date = ifelse(is.na(Close_date), NA, paste(substr(Close_date, 1,4), substr(Close_date, 5,6), substr(Close_date, 7,8), sep = '-'))) %>%
  mutate(Open_date = as.Date(Open_date)) %>% 
  mutate(Close_date = as.Date(Close_date)) %>% 
  mutate(Address_label = gsub(', NA','', paste(str_to_title(Address_1), str_to_title(Address_2),str_to_title(Address_3),str_to_title(Address_4), str_to_title(Address_5), Postcode, sep = ', '))) %>% 
  mutate(Site_Name = gsub('Cdc', 'CDC', gsub('Gp', 'GP', gsub('Pcn', 'PCN', gsub('And', 'and',  gsub(' Of ', ' of ', gsub('Bdct ', 'BDCT ', gsub(' Eis ', ' EIS ', gsub(' Ld ', ' LD ',  str_to_title(Site_Name)))))))))) %>% 
  mutate(NHS_region = ifelse(National_grouping == 'Y56', 'London Commissioning Region', ifelse(National_grouping == 'Y58', 'South West Commissioning Region', ifelse(National_grouping == 'Y59', 'South East Commissioning Region', ifelse(National_grouping == 'Y60', 'Midlands Commissioning Region', ifelse(National_grouping == 'Y61', 'East of England Commissioning Region', ifelse(National_grouping == 'Y62', 'North West Commissioning Region', ifelse(National_grouping == 'Y63', 'North East and Yorkshire Commissioning Region', ifelse(National_grouping == 'W00', 'Wales', NA))))))))) %>% 
  left_join(trust_df[c('Trust_ODS_Code', 'Trust_Name', 'ICB_Code', 'ICB_Name')], by = c('Parent_NHS_Trust_Code' = 'Trust_ODS_Code')) %>% 
  select(Site_ODS_Code, Site_Name, Address_label, Postcode, Parent_NHS_Trust_Code, Trust_Name, National_grouping, NHS_region, ICB_Code, ICB_Name, Open_date, Close_date)

trust_site_df %>% 
  write.csv(., paste0(output_store, '/NHS_Trust_Site_metadata.csv'), row.names = FALSE)

# download.file(url = 'https://files.digital.nhs.uk/assets/ods/current/etreat.zip',
#               destfile = paste0(local_store, '/ETREAT.zip'),
#               mode = 'wb')
# unzip(paste0(local_store, '/ETREAT.zip'),
#       exdir = local_store)
# 
# download.file(url = 'https://files.digital.nhs.uk/assets/ods/current/ephp.zip',
#               destfile = paste0(local_store, '/EPHP.zip'),
#               mode = 'wb')
# unzip(paste0(local_store, '/EPHP.zip'),
#       exdir = local_store)  
# 
# download.file(url = 'https://files.digital.nhs.uk/assets/ods/current/enonnhs.zip',
#               destfile = paste0(local_store, '/ENONNHS.zip'),
#               mode = 'wb')
# unzip(paste0(local_store, '/ENONNHS.zip'),
#       exdir = local_store)  
# 
# download.file(url = 'https://files.digital.nhs.uk/assets/ods/current/ephpsite.zip',
#               destfile = paste0(local_store, '/EPHPSITE.zip'),
#               mode = 'wb')
# unzip(paste0(local_store, '/EPHPSITE.zip'),
#       exdir = local_store)  














# From SID we can retrieve data on provider organisations. It appears that the data team have also added some registered population information in addition to aggregating SID data 
# query = "SELECT * \
#   FROM reporting.CCG_PCN_Practices"
# 
# organisation_df <- dbGetQuery(con, query) 


