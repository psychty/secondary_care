
packages <- c('easypackages', 'tidyverse','readxl', 'readr', 'readODS')
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

output_store <- paste0(base_directory, '/Data_store')

if(dir.exists(output_store) == FALSE) {
  dir.create(output_store)
  print(paste0('The directory for outputs on your machine (', output_store, ') appears to be missing, it has been created.'))
}

# readmissions ####

# Now we need a dataframe that tells us the patient journey and each time they are discharged and admitted again.

# Extract 14 months

# all information needed should be in the FAE episode for the financial year



# Admissions - these are records which are designated as admission episodes (FAE, Finished Admission Episode)
Admissions <- subset(HES, FAE == 1 &  CLASSPAT_125 == "Ordinary admissions")
Admissions <- droplevels(Admissions)

# In theory these should all be unique spells as an fae should only be assigned to one spell.
# Check the number of unique spells
length(unique(Admissions$SUSSPELLID)) # Great, there are some duplicate spell IDs in there!

Admissions <- subset(Admissions, is.na(FLAGS_AHOY))



ds <- data.table(Admissions[c("PatientID","ADMIMETH","ADMIAGE","QUINARY_ADMIAGE","FAE","FCE","FDE","ADMIDATE","DISDATE","DISDEST","GPPRAC","EPIORDER","EPISTAT", "SEX","SPELDUR","CAUSE", "Elective", "Emergency")])

stays <- as.data.frame(table(ds$PatientID))

# This is the number of discharge episodes (discharges)
nrow(subset(HES, FDE == "Finished In-Year Discharge Episode"))

# This is the number of patients represented in 2014/15 - it is the number of patients admitted 
length(unique(HES$PatientID))

length(unique(Admissions$PatientID))

# This is a datase of patients who had 
Readmissions <- Admissions[as.numeric(ave(Admissions$PatientID, Admissions$PatientID, FUN=length)) >= 2, ]

# This is the number of patients who had more than one admission in 2014/15
length(unique(Readmissions$PatientID))


setkey(ds, PatientID, ADMIDATE)
ds <- ds[ , Daydiff := as.numeric(difftime(shift(ADMIDATE, n = 1L, fill = 999, type = "lead"), DISDATE)), 
          by = "PatientID"][ ,':='(Readmit30 = ifelse(abs(Daydiff) <= 30, 1, 0), 
                                   Readmit180= ifelse(abs(Daydiff) <= 180, 1, 0),
                                   Daydiff   = NULL)]

