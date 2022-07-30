
packages <- c('easypackages', 'tidyverse','readxl', 'readr', 'readODS')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

getwd()

local_store <- './local'


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

