

packages <- c('easypackages', 'tidyverse','readxl', 'readr')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

base_directory <- '~/GitHub/secondary_care'

# Define a directory for working documents/downloads etc
local_store <- paste0(base_directory, '/local')
#local_store <- './secondary_care/local'

# Use dir.exists to see if you have a folder already
# dir.exists(local_store)

# Use an if statement to create the directory if it does not exist
if(dir.exists(local_store) == FALSE) {
  dir.create(local_store)
  print(paste0('The local directory for raw files on your machine (', local_store, ') appears to be missing, it has now been created.'))
}

script_store <- paste0(base_directory, '/R_Scripts')

if(dir.exists(script_store) == FALSE) {
  print(paste0('The directory for R scripts on your machine (', script_store, ') appears to be missing, check or ammend the filepath script_store'))
}

output_store <- paste0(base_directory, '/Outputs')

if(dir.exists(output_store) == FALSE) {
  dir.create(output_store)
  print(paste0('The directory for outputs on your machine (', output_store, ') appears to be missing, it has been created.'))
}

HES_metadata <- read_csv(paste0(output_store, '/HES_field_metadata.csv'))

# Search for a field
HES_metadata %>%
  filter(str_detect(pattern = regex("startage", ignore_case = TRUE), string = Field)) %>% 
  view()
