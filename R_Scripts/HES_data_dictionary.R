
# Data Dictionary ####

packages <- c('easypackages', 'tidyverse','readxl', 'readr')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# Define a directory for working documents/downloads etc
local_store <- '~/GitHub/secondary_care/local'
# Use dir.exists to see if you have a folder already
dir.exists(local_store)

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
if(file.exists(paste0(local_store, '/HES_data_dictionary.xlsx')) != TRUE){
  download.file('https://digital.nhs.uk/binaries/content/assets/website-assets/data-and-information/data-tools-and-services/data-services/hospital-episode-statistics/hes-data-dictionary/hes-tos-v1.8---published-m12.xlsx', destfile = paste0(local_store, '/HES_data_dictionary.xlsx'), mode = 'wb')
}

HES_AE_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                     sheet = "HES AE TOS",
                                     skip = 1)

HES_inpatient_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                     sheet = "HES APC TOS",
                                     skip = 1)

HES_inpatient_critical_care_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                     sheet = "HES CC TOS",
                                     skip = 2)

HES_outpatient_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                     sheet = "HES OP TOS",
                                     skip = 1)

HES_mortality_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                             sheet = "HES ONS TOS",
                                             skip = 1)


HES_processing_rules <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                             sheet = "Processing Rules",
                                             skip = 1)

HES_alcohol_fractions_reference <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                              sheet = "Alcohol fractions ref data",
                                              skip = 1)

HES_outpatient_data_dictionary <- read_excel(paste0(local_store, "/HES_data_dictionary.xlsx"),
                                             sheet = "HES OP TOS",
                                             skip = 1)

HES_combined_df <- HES_AE_data_dictionary %>% 
  bind_rows(HES_inpatient_data_dictionary) %>% 
  bind_rows(HES_inpatient_critical_care_data_dictionary) %>% 
  bind_rows(HES_outpatient_data_dictionary) %>% 
  bind_rows(HES_mortality_data_dictionary) %>% 
  select(Field, Name = 'Field name', Format, Description, Values, Cleaning, Derivations, Notes = 'DQ Notes') %>% 
  unique()

HES_combined_df %>% 
  write.csv(., paste0(output_store, '/HES_field_metadata.csv'), row.names = FALSE)

# HES_AE_data_dictionary %>%
  # filter(str_detect(pattern = 'ccg|CCG|cCg', string = Field))

# HES_AE_data_dictionary %>%
  # filter(str_detect(pattern = regex('ccg', ignore_case = TRUE), string = Field))

# ATENTYPE_vals <- HES_outpatient_data_dictionary %>%
  # filter(Field == 'ATENTYPE') %>%
  # select(Value) %>%
  # as.character()


