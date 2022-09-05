 # A&E data exploration ####

packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras', 'lubridate')
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

# Lookup tables 
Diagnosis_condition_lookup <- data.frame(Code = c('01','02','03', '04', '05', '06', '07', '08', '09', '10','11','12','13', '14', '15', '16', '17', '18', '19', '20','21','22','23', '24', '25', '26', '27', '28', '29', '30','31','32','33', '34', '35', '36', '37', '38', '39'), Diagnosis_condition = c('Laceration', 'Contusion/abrasion', 'Soft tissue inflammation', 'Head injury', 'Dislocation/fracture/joint injury/amputation', 'Sprain/ligament injury', 'Muscle/tendon injury', 'Nerve injury', 'Vascular injury', 'Burns and scalds', 'Electric shock', 'Foreign body', 'Bites/stings', 'Poisoning (inc overdose)', 'Near drowning', 'Visceral injury', 'Infectious disease', 'Local infection', 'Septicaemia', 'Cardiac conditions', 'Cerebro-vascular conditions', 'Other vascular conditions', 'Haematological conditions', 'Central nervous system conditions (exc stroke)', 'Respiratory conditions', 'Gastrointestinal conditions', 'Urological conditions (inc cystitis)', 'Obstetric conditions', 'Gynaecological conditions', 'Diabetes and other endocrinological conditions', 'Dermatological conditions', 'Allergy (inc anaphylaxis)', 'Facio-maxillary conditions', 'ENT conditions', 'Psychiatric conditions', 'Ophthalmological  conditions', 'Social problems (inc chronic alcoholism and homelessness)', 'Diagnosis not classifiable', 'Nothing abnormal detected'))

Diagnosis_condition_lookup_three <- data.frame(Code = c('01','021','022','03','041', '042', '051','052','053','054', '055', '06', '07', '08', '09', '101', '102', '103', '104', '11','12', '13', '141', '142', '143', '144', '15', '16', '171', '172','18','19','201','202','21','22','23', '241', '242', '251', '252', '261', '262', '263', '27', '28', '29', '301','302', '31', '32', '33', '34', '35', '36','37', '38','39'), Diagnosis_condition = c('Laceration','Contusion','Abrasion','Soft tissue inflammation','Concussion','Other head injury','Dislocation','Open fracture','Closed fracture','Joint injury','Amputation','Sprain/ligament injury','Muscle/tendon injury','Nerve injury','Vascular injury','Burns and scalds - electric','Burns and scalds - thermal','Burns and scalds - chemical','Burns and scalds - radiation','Electric shock','Foreign body','Bites/stings','Poisoning (inc overdose) - prescriptive drugs','Poisoning (inc overdose) - proprietary drugs','Poisoning (inc overdose) - controlled drugs','Poisoning (inc overdose) - other, inc alcohol','Near drowning','Visceral injury','Infectious disease - notifiable','Infectious disease - non-notifiable','Local infection','Septicaemia','Cardiac conditions - myocardial ischaemia & infarction','Cardiac conditions - other non-ischaemia','Cerebro-vascular conditions','Other vascular conditions','Haematological conditions','Central nervous system conditions - epilepsy','Central nervous system conditions - other non-epilepsy','Respiratory conditions - bronchial asthma','Respiratory conditions - other non-asthma','Gastrointestinal conditions - haemorrhage','Gastrointestinal conditions - acute abdominal pain','Gastrointestinal conditions - other', 'Urological conditions (inc cystitis)','Obstetric conditions','Gynaecological conditions','Diabetes and other endocrinological conditions - diabetic','Diabetes and other endocrinological conditions - other non-diabetic','Dermatological conditions','Allergy (inc anaphylaxis)','Facio-maxillary conditions','ENT conditions','Psychiatric conditions','Ophthalmological  conditions','Social problems (inc chronic alcoholism and homelessness)','Diagnosis not classifiable','Nothing abnormal detected'))

Diagnosis_anatomical_area_lookup <- data.frame(Code = c('01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36'), Anatomical_area = c('Brain','Head','Face','Eye','Ear','Nose','Mouth,Jaw,Teeth','Throat','Neck','Shoulder','Axilla','Upper Arm','Elbow','Forearm','Wrist','Hand','Digit','Cervical spine','Thoracic','Lumbosacral spine','Pelvis','Chest','Breast','Abdomen','Back/buttocks','Ano/rectal','Genitalia','Hip','Groin','Thigh','Knee','Lower leg','Ankle','Foot','Toe','Multiple site'))

Investigation_lookup <- data.frame(Code = c('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '99'), Investigation = c('X-ray plain film', 'Electrocardiogram', 'Haematology', 'Cross match blood/group & save serum for later cross match','Biochemistry','Urinalysis','Bacteriology','Histology','Computerised tomography','Ultrasound','Magnetic resonance imaging','Computerised tomography (exc genito urinary contrast examination/tomography)','Genito urinary contrast examination/tomography','Clotting studies','Immunology','Cardiac enzymes','Arterial/capillary blood gas','Toxicology','Blood culture','Serology','Pregnancy test','Dental investigation','Refraction, orthoptic tests and computerised visual fields','None','Other'))

Treatment_lookup <- data.frame(Code = c('01','02','03','04','05','06','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','99'), Treatment = c('Dressing','Bandage/support','Sutures','Wound closure (exc sutures)','Plaster of Paris','Splint','Removal foreign body','Physiotherapy','Manipulation','Incision and drainage','Intravenous cannula','Central line','Lavage/emesis/charcoal/eye irrigation','Intubation & Endotracheal tubes/laryngeal mask airways/rapid sequence induction','Chest drain','Urinary catheter/suprapubic','Defibrillation/pacing','Resuscitation/cardiopulmonary resuscitation','Minor surgery','Observation/electrocardiogram,pulse oximetry/head injury/trends','Guidance/advice only','Anaesthesia','Tetanus','Nebulise/spacer','Other (consider alternatives)','Parenteral thrombolysis','Other parenteral drugs','Recording vital signs','Burns review','Recall/x-ray review','Fracture review','Wound cleaning','Dressing/wound review','Sling/collar cuff/broad arm sling','Epistaxis control','Nasal airway','Oral airway','Supplemental oxygen','Continuous positive airways pressure/nasal intermittent positive pressure ventilation/bag valve mask','Arterial line','Infusion fluids','Blood product transfusion','Pericardiocentesis','Lumbar puncture','Joint aspiration','Minor plastic procedure/splint skin graft','Active rewarming of the hypothermic patient','Cooling - control body temperature','Medication administered','Occupational therapy','Loan of walking aid (crutches)','Social worker intervention','Eye','Dental treatment','Prescription/medicines prepared to take away','None (consider guidance/advice option)'))

Treatment_lookup_three <- data.frame(Code = c('011', '012', '02', '31', '32', '33', '041', '042', '043', '051', '052', '06', '08', '091', '092', '101', '102', '103', '11', '12', '13', '14','15', '16', '17', '181','182', '19', '20', '21', '221', '222', '231', '232', '233', '234', '235', '236', '241', '242', '243', '244', '245', '246', '25', '27', '281', '282', '291', '292', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43','44', '45', '46', '47', '48', '49', '50', '511', '512', '513', '514', '515', '516', '517', '518', '519', '521', '522', '53', '54', '551', '552', '553', '554', '555', '56', '57', '99'), Treatment = c('Dressing minor wound/burn/eye', 'Dressing major wound/burn', 'Bandage/support', 'Primary sutures', 'Secondary/complex suture', 'Removal of sutures/clips', 'Wound closure - steristrips', 'Wound closure - wound glue', 'Wound closure - other (eg clips)', 'Plaster of Paris - application', 'Plaster of Paris - removal', 'Splint', 'Removal foreign body',  'Physiotherapy - strapping, ultra sound treatment, short wave diathermy,manipulation',  'Physiotherapy - gait re-education, falls prevention', 'Manipulation of upper limb fracture',  'Manipulation of lower limb fracture', 'Manipulation of dislocation', 'Incision and drainage', 'Intravenous cannula', 'Central line', 'Lavage/emesis/charcoal/eye irrigation', 'Intubation & Endotracheal tubes/laryngeal mask airways/rapid sequence induction', 'Chest drain', 'Urinary catheter/suprapubic', 'Defibrillation', 'External pacing', 'Resuscitation/cardiopulmonary resuscitation', 'Minor surgery', 'Observation/electrocardiogram,pulse oximetry/head injury/trends', 'Guidance/advice only - written', 'Guidance/advice only - verbal', 'Anaesthesia - general', 'Anaesthesia - local', 'Anaesthesia - regional block', 'Anaesthesia - etonox', 'Anaesthesia - sedation', 'Anaesthesia - other', 'Tetanus - immune', 'Tetanus - tetanus toxoid course', 'Tetanus - tetanus toxoid booster', 'Tetanus - human immunoglobin', 'Tetanus - combined tetanus/diphtheria course', 'Tetanus - combined tetanus/diphtheria booster', 'Nebulise/spacer', 'Other (consider alternatives)', 'Parenteral thrombolysis - streptokinase parenteral thrombolysis', 'Parenteral thrombolysis - recombinant - plasminogen activator', 'Other parenteral drugs - intravenous drug eg stat/bolus', 'Other parenteral drugs - intravenous infusion', 'Recording vital signs', 'Burns review', 'Recall/x-ray review', 'Fracture review', 'Wound cleaning', 'Dressing/wound review', 'Sling/collar cuff/broad arm sling', 'Epistaxis control', 'Nasal airway',  'Oral airway', 'Supplemental oxygen', 'Continuous positive airways pressure/nasal intermittent positive pressure ventilation/bag valve mask', 'Arterial line', 'Infusion fluids', 'Blood product transfusion', 'Pericardiocentesis', 'Lumbar puncture', 'Joint aspiration', 'Minor plastic procedure/splint skin graft', 'Active rewarming of the hypothermic patient', 'Cooling - control body temperature', 'Medication administered - oral', 'Medication administered - intra-muscular', 'Medication administered - subcutaneous', 'Medication administered - per rectum', 'Medication administered - sublingual', 'Medication administered - intra-nasal', 'Medication administered - eye drops', 'Medication administered - ear drops', 'Medication administered - topical skin cream', 'Occupational therapy functional assessments', 'Occupational therapy activities of daily living equipment provision', 'Loan of walking aid (crutches)', 'Social worker intervention', 'Eye - orthoptic exercises', 'Eye - laser of retina/iris or posterior capsule', 'Eye - retrobulbar injection', 'Eye - epilation of lashes', 'Eye - subconjunctival injection', 'Dental treatment', 'Prescription/medicines prepared to take away', 'None (consider guidance/advice option)'))

Diagnosis_anatomical_side_lookup <- data.frame(Code = c('L','R','B','8'))

# Load data ####
HDIS_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/HDIS/Extracts_Rich_Tyler/'

df_raw <- list.files(HDIS_directory)[grepl("West_Sussex_residents_A&E_attendances", list.files(HDIS_directory)) == TRUE] %>%  map_df(~read_csv(paste0(HDIS_directory,.),
        col_types = cols(ARRIVALDATE = col_date(format = '%Y-%m-%d'),
                         DIAGS_01 = col_character(),
                         DIAGS_02 = col_character(),
                         DIAGS_03 = col_character(),
                         DIAGS_04 = col_character(),
                         DIAGS_05 = col_character(),
                         DIAGS_06 = col_character(),
                         DIAGS_07 = col_character(),
                         DIAGS_08 = col_character(),
                         DIAGS_09 = col_character(),
                         DIAGS_10 = col_character(),
                         DIAGS_11 = col_character(),
                         DIAGS_12 = col_character(),
                         DIAG2_01 = col_character(),
                         DIAG2_02 = col_character(),
                         DIAG2_03 = col_character(),
                         DIAG2_04 = col_character(),
                         DIAG2_05 = col_character(),
                         DIAG2_06 = col_character(),
                         DIAG2_07 = col_character(),
                         DIAG2_08 = col_character(),
                         DIAG2_09 = col_character(),
                         DIAG2_10 = col_character(),
                         DIAG2_11 = col_character(),
                         DIAG2_12 = col_character(),
                         DIAG3_01 = col_character(),
                         DIAG3_02 = col_character(),
                         DIAG3_03 = col_character(),
                         DIAG3_04 = col_character(),
                         DIAG3_05 = col_character(),
                         DIAG3_06 = col_character(),
                         DIAG3_07 = col_character(),
                         DIAG3_08 = col_character(),
                         DIAG3_09 = col_character(),
                         DIAG3_10 = col_character(),
                         DIAG3_11 = col_character(),
                         DIAG3_12 = col_character(),
                         DIAGA_01 = col_character(),
                         DIAGA_02 = col_character(),
                         DIAGA_03 = col_character(),
                         DIAGA_04 = col_character(),
                         DIAGA_05 = col_character(),
                         DIAGA_06 = col_character(),
                         DIAGA_07 = col_character(),
                         DIAGA_08 = col_character(),
                         DIAGA_09 = col_character(),
                         DIAGA_10 = col_character(),
                         DIAGA_11 = col_character(),
                         DIAGA_12 = col_character(),
                         TREAT2_01 = col_character(),
                         TREAT2_02 = col_character(),
                         TREAT2_03 = col_character(),
                         TREAT2_04 = col_character(),
                         TREAT2_05 = col_character(),
                         TREAT2_06 = col_character(),
                         TREAT2_07 = col_character(),
                         TREAT2_08 = col_character(),
                         TREAT2_09 = col_character(),
                         TREAT2_10 = col_character(),
                         TREAT2_11 = col_character(),
                         TREAT2_12 = col_character(),
                         TREAT3_01 = col_character(),
                         TREAT3_02 = col_character(),
                         TREAT3_03 = col_character(),
                         TREAT3_04 = col_character(),
                         TREAT3_05 = col_character(),
                         TREAT3_06 = col_character(),
                         TREAT3_07 = col_character(),
                         TREAT3_08 = col_character(),
                         TREAT3_09 = col_character(),
                         TREAT3_10 = col_character(),
                         TREAT3_11 = col_character(),
                         TREAT3_12 = col_character()),
        na = "null"))

df_processed <- df_raw %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', 'Unknown'))) %>% 
  mutate(Arrival_mode = ifelse(AEARRIVALMODE == 1, 'Ambulance (including air ambulance)', ifelse(AEARRIVALMODE == 2, 'Other', ifelse(AEARRIVALMODE == 9, 'Unknown', NA)))) %>% 
  mutate(Attendance_category = ifelse(AEATTENDCAT == 1, 'First A&E attendance', ifelse(AEATTENDCAT == 2, 'Planned follow-up A&E attendance', ifelse(AEATTENDCAT == 3, 'Unplanned follow-up A&E attendance', ifelse(AEATTENDCAT == 9, 'Unknown', NA))))) %>% 
  mutate(Attendance_disposal = ifelse(AEATTENDDISP == '01', 'Admitted or became a lodged patient', ifelse(AEATTENDDISP == '02', 'Discharged with follow up at GP', ifelse(AEATTENDDISP == '03', 'Discharged with no follow up required', ifelse(AEATTENDDISP == '04', 'Referred to A&E clinic', ifelse(AEATTENDDISP == '05', 'Referred to fracture clinic', ifelse(AEATTENDDISP == '06', 'Referred to other outpatient clinic', ifelse(AEATTENDDISP == '07', 'Transferred to other provider', ifelse(AEATTENDDISP == '10', 'Deceased', ifelse(AEATTENDDISP == '11', 'Referred to other healthcare professional', ifelse(AEATTENDDISP == '12', 'Left department prior to treatment', ifelse(AEATTENDDISP == '14', 'Other', ifelse(AEATTENDDISP == '99', 'Unknown', NA))))))))))))) %>% 
  mutate(Type_of_department = ifelse(AEDEPTTYPE == '01', 'Consultant-led emergency deptartment with full resuscitation facilities', ifelse(AEDEPTTYPE == '02', 'Consultant-led speciality A&E service', ifelse(AEDEPTTYPE == '03', 'Other type of A&E/minor injury department', ifelse(AEDEPTTYPE == '04', 'NHS Walk-in centre', ifelse(AEDEPTTYPE == '99', 'Unknown', NA)))))) %>% 
  mutate(Incident_location = ifelse(AEINCLOCTYPE == '10', 'Home', ifelse(AEINCLOCTYPE == '40', 'Workplace', ifelse(AEINCLOCTYPE == '50', 'Education setting', ifelse(AEINCLOCTYPE == '60', 'Public place', ifelse(AEINCLOCTYPE == '91', 'Other', ifelse(AEINCLOCTYPE == '99', 'Unknown', NA))))))) %>% 
  mutate(Patient_group = ifelse(AEPATGROUP == '10', 'Road Traffic Accident', ifelse(AEPATGROUP == '20', 'Assault', ifelse(AEPATGROUP == '30', 'Deliberate self-harm', ifelse(AEPATGROUP == '40', 'Sporting injury', ifelse(AEPATGROUP == '50', 'Firework injury', ifelse(AEPATGROUP == '60', 'Other accident', ifelse(AEPATGROUP == '70', 'Brought in deceased', ifelse(AEPATGROUP == '80', 'Other', ifelse(AEPATGROUP == '99', 'Unknown', NA)))))))))) %>% 
  mutate(AE_referral_source = ifelse(AEREFSOURCE == '00', 'GP', ifelse(AEREFSOURCE == '01', 'Self-referral', ifelse(AEREFSOURCE == '02', 'Social Services (LA)', ifelse(AEREFSOURCE == '03', 'Emergency services', ifelse(AEREFSOURCE == '04', 'Workplace', ifelse(AEREFSOURCE == '05', 'Education setting', ifelse(AEREFSOURCE == '06', 'Police', ifelse(AEREFSOURCE == '07', 'Healthcare provider', ifelse(AEREFSOURCE == '08', 'Other', ifelse(AEREFSOURCE == '92', 'Dental practitioner (general)', ifelse(AEREFSOURCE == '93', 'Dental practitioner (community)', ifelse(AEREFSOURCE == '99', 'Unknown', NA))))))))))))) %>%
  mutate(Arrival_age_band_five = factor(ifelse(is.na(ARRIVALAGE_CALC), 'Unknown', ifelse(ARRIVALAGE_CALC <= 4, "0-4 years", ifelse(ARRIVALAGE_CALC <= 9, "5-9 years", ifelse(ARRIVALAGE_CALC <= 14, "10-14 years", ifelse(ARRIVALAGE_CALC <= 19, "15-19 years", ifelse(ARRIVALAGE_CALC <= 24, "20-24 years", ifelse(ARRIVALAGE_CALC <= 29, "25-29 years",ifelse(ARRIVALAGE_CALC <= 34, "30-34 years", ifelse(ARRIVALAGE_CALC <= 39, "35-39 years",ifelse(ARRIVALAGE_CALC <= 44, "40-44 years", ifelse(ARRIVALAGE_CALC <= 49, "45-49 years",ifelse(ARRIVALAGE_CALC <= 54, "50-54 years", ifelse(ARRIVALAGE_CALC <= 59, "55-59 years",ifelse(ARRIVALAGE_CALC <= 64, "60-64 years", ifelse(ARRIVALAGE_CALC <= 69, "65-69 years",ifelse(ARRIVALAGE_CALC <= 74, "70-74 years", ifelse(ARRIVALAGE_CALC <= 79, "75-79 years", ifelse(ARRIVALAGE_CALC <= 84, "80-84 years", ifelse(ARRIVALAGE_CALC <= 89, "85-89 years", ifelse(ARRIVALAGE_CALC <= 94, "90-94 years",  "95+ years")))))))))))))))))))), levels = c('0-4 years', '5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85-89 years', '90-94 years', '95+ years', 'Unknown'))) %>% 
  mutate(Arrival_age_band_five_neonatal = factor(ifelse(is.na(ARRIVALAGE_CALC), 'Unknown', ifelse(ARRIVALAGE_CALC == 0.002, 'Less than one day', ifelse(ARRIVALAGE_CALC == 0.010, 'One to six days', ifelse(ARRIVALAGE_CALC == 0.048, 'Seven to 28 days', ifelse(ARRIVALAGE_CALC == 0.167, '29-90 days (under three months)', ifelse(ARRIVALAGE_CALC == 0.375, '91-181 days (three to six months)', ifelse(ARRIVALAGE_CALC == 0.625, '182-272 days (six to nine months)', ifelse(ARRIVALAGE_CALC == 0.875, '273 days to one year', ifelse(ARRIVALAGE_CALC <= 4, "1-4 years", ifelse(ARRIVALAGE_CALC <= 9, "5-9 years", ifelse(ARRIVALAGE_CALC <= 14, "10-14 years", ifelse(ARRIVALAGE_CALC <= 19, "15-19 years", ifelse(ARRIVALAGE_CALC <= 24, "20-24 years", ifelse(ARRIVALAGE_CALC <= 29, "25-29 years",ifelse(ARRIVALAGE_CALC <= 34, "30-34 years", ifelse(ARRIVALAGE_CALC <= 39, "35-39 years",ifelse(ARRIVALAGE_CALC <= 44, "40-44 years", ifelse(ARRIVALAGE_CALC <= 49, "45-49 years",ifelse(ARRIVALAGE_CALC <= 54, "50-54 years", ifelse(ARRIVALAGE_CALC <= 59, "55-59 years",ifelse(ARRIVALAGE_CALC <= 64, "60-64 years", ifelse(ARRIVALAGE_CALC <= 69, "65-69 years",ifelse(ARRIVALAGE_CALC <= 74, "70-74 years", ifelse(ARRIVALAGE_CALC <= 79, "75-79 years", ifelse(ARRIVALAGE_CALC <= 84, "80-84 years", ifelse(ARRIVALAGE_CALC <= 89, "85-89 years", ifelse(ARRIVALAGE_CALC <= 94, "90-94 years",  "95+ years"))))))))))))))))))))))))))), levels = c('Less than one day', 'One to six days', 'Seven to 28 days', '29-90 days (under three months)', '91-181 days (three to six months)', '182-272 days (six to nine months)', '273 days to one year', '1-4 years', '5-9 years','10-14 years','15-19 years','20-24 years','25-29 years','30-34 years','35-39 years','40-44 years','45-49 years','50-54 years','55-59 years','60-64 years','65-69 years','70-74 years','75-79 years','80-84 years','85-89 years', '90-94 years', '95+ years', 'Unknown'))) %>% 
  mutate(Arrival_month_year = format(ARRIVALDATE, '%B %Y'),
         Arrival_month = factor(format(ARRIVALDATE, '%B'), levels = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')),
         Arrival_year = format(ARRIVALDATE, '%Y')) %>% 
  mutate(Arrival_quarter_calendar = ifelse(Arrival_month %in% c('January', 'February', 'March'), 'Quarter 1', ifelse(Arrival_month %in% c('April', 'May', 'June'), 'Quarter 2', ifelse(Arrival_month %in% c('July', 'August', 'September'), 'Quarter 3',  ifelse(Arrival_month %in% c('October', 'November', 'December'), 'Quarter 4'), NA)))) %>% 
  mutate(Arrival_quarter_financial = ifelse(Arrival_month %in% c('April', 'May', 'June'), 'Quarter 1', ifelse(Arrival_month %in% c('July', 'August', 'September'), 'Quarter 2',  ifelse(Arrival_month %in% c('October', 'November', 'December'), 'Quarter 3'), ifelse(Arrival_month %in% c('January', 'February', 'March'), 'Quarter 4',  NA)))) %>% 
  mutate(Arrival_hour = hour(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(ARRIVALTIME)))), unit = "hour")),
         Arrival_minute = minute(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(ARRIVALTIME)))), unit = "minute"))) %>% 
  mutate(Minutes_to_conclusion = CONCLDUR) %>% 
  mutate(Completion_time = ifelse(CONCLTIME == 3000, 'Invalid', ifelse(CONCLTIME == 4000, 'Unknown', CONCLTIME))) %>% 
  mutate(Completion_hour = hour(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Completion_time)))), unit = "hour")),
         Completion_minute = minute(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Completion_time)))), unit = "minute"))) %>% 
  mutate(Minutes_to_departure = DEPDUR) %>% 
  mutate(Departure_time = ifelse(DEPTIME == 3000, 'Invalid', ifelse(DEPTIME == 4000, 'Unknown', DEPTIME))) %>% 
  mutate(Departure_hour = hour(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Departure_time)))), unit = "hour")),
         Departure_minute = minute(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Departure_time)))), unit = "minute"))) %>% 
  mutate(Ethnicity = ifelse(ETHNOS == 'A', 'White British', ifelse(ETHNOS == 'B', 'White Irish', ifelse(ETHNOS == 'C', 'Any other White background', ifelse(ETHNOS == 'D', 'Mixed - White and Black Caribbean', ifelse(ETHNOS == 'E', 'Mixed - White and Black African', ifelse(ETHNOS == 'F', 'Mixed - White and Asian', ifelse(ETHNOS == 'G' , 'Mixed - Any other Mixed background', ifelse(ETHNOS == 'H', 'Asian or Asian British - Indian', ifelse(ETHNOS == 'J', 'Asian or Asian British - Pakistani', ifelse(ETHNOS == 'K', 'Asian or Asian British - Bangladeshi', ifelse(ETHNOS == 'L', 'Asian or Asian British - Any other Asian background', ifelse(ETHNOS == 'M', 'Black or Black British - Caribbean', ifelse(ETHNOS == 'N', 'Black or Black British - African', ifelse(ETHNOS == 'P', 'Black or Black British - Any other Black background', ifelse(ETHNOS == 'R', 'Other - Chinese', ifelse(ETHNOS == 'S', 'Other - Any other ethnic group', ifelse(ETHNOS == 'Z', 'Not stated', ifelse(ETHNOS %in% c('X', '9','99'), 'Unknown', ifelse(ETHNOS == '0', 'White', ifelse(ETHNOS == '1', 'Black or Black British - Caribbean', ifelse(ETHNOS == '2', 'Black or Black British - African', ifelse(ETHNOS == '3', 'Black or Black British - Any other Black background', ifelse(ETHNOS == '4', 'Asian or Asian British - Indian', ifelse(ETHNOS == '5', 'Asian or Asian British - Pakistani', ifelse(ETHNOS == '6', 'Asian or Asian British - Bangladeshi', ifelse(ETHNOS == '7', 'Other - Chinese', ifelse(ETHNOS == '8', 'Other - Any other ethnic group',  ETHNOS)))))))))))))))))))))))))))) %>% 
  mutate(Minutes_to_initial_assessment = INITDUR) %>% 
  mutate(Initial_assessment_time = ifelse(INITTIME == 3000, 'Invalid', ifelse(INITTIME == 4000, 'Unknown', INITTIME))) %>% 
  mutate(Initial_assessment_hour = hour(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Initial_assessment_time)))), unit = "hour")),
         Initial_assessment_minute = minute(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Initial_assessment_time)))), unit = "minute"))) %>% 
  mutate(Treatment_time = ifelse(TRETTIME == 3000, 'Invalid', ifelse(TRETTIME == 4000, 'Unknown', TRETTIME))) %>% 
  mutate(Treatment_hour = hour(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Treatment_time)))), unit = "hour")),
         Treatment_minute = minute(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Treatment_time)))), unit = "minute"))) %>% 
  select(Financial_year = FYEAR, PSEUDO_HESID, AEKEY, EPIKEY, Ethnicity, Sex = SEX, Arrival_age_band_five, Arrival_age_band_five_neonatal,  GP_practice = GPPRAC, CCG_of_responsibility = CCG_RESPONSIBILITY, Provider_code_three = PROCODE3, Provider_code_five = PROCODE5, PROCODET, LSOA11CD = LSOA11, MSOA11CD = MSOA11, LTLA_Code = RESLADST_ONS, SUSHRG, Arrival_date = ARRIVALDATE, Arrival_month_year, Arrival_month, Arrival_year, Arrival_quarter_calendar, Arrival_quarter_financial, Arrival_hour, Arrival_minute, Arrival_mode, Attendance_category, Attendance_disposal, Type_of_department, Incident_location, INVEST2_01, INVEST2_02, INVEST2_03, INVEST2_04, INVEST2_05, INVEST2_06, INVEST2_07, INVEST2_08, INVEST2_09, INVEST2_10, INVEST2_11, INVEST2_12,DIAG2_01, DIAG2_02, DIAG2_03, DIAG2_04, DIAG2_05, DIAG2_06, DIAG2_07, DIAG2_08, DIAG2_09, DIAG2_10, DIAG2_11, DIAG2_12, DIAG3_01, DIAG3_02, DIAG3_03, DIAG3_04, DIAG3_05, DIAG3_06, DIAG3_07, DIAG3_08, DIAG3_09, DIAG3_10, DIAG3_11, DIAG3_12, Anatomical_area_01 = DIAGA_01, Anatomical_area_02 = DIAGA_02, Anatomical_area_03 = DIAGA_03, Anatomical_area_04 = DIAGA_04, Anatomical_area_05 = DIAGA_05, Anatomical_area_06 = DIAGA_06, Anatomical_area_07 = DIAGA_07, Anatomical_area_08 = DIAGA_08, Anatomical_area_09 = DIAGA_09, Anatomical_area_10 = DIAGA_10, Anatomical_area_21 = DIAGA_11, Anatomical_area_12 = DIAGA_12, Anatomical_side_01 = DIAGS_01, Anatomical_side_02 = DIAGS_02, Anatomical_side_03 = DIAGS_03, Anatomical_side_04 = DIAGS_04, Anatomical_side_05 = DIAGS_05, Anatomical_side_06 = DIAGS_06, Anatomical_side_07 = DIAGS_07, Anatomical_side_08 = DIAGS_08, Anatomical_side_09 = DIAGS_09, Anatomical_side_10 = DIAGS_10, Anatomical_side_11 = DIAGS_11, Anatomical_side_12 = DIAGS_12, Patient_group, AE_referral_source,  Minutes_to_conclusion, Completion_time, Completion_hour, Completion_minute, Minutes_to_departure, Departure_time, Departure_hour, Departure_minute, Minutes_to_initial_assessment, Initial_assessment_time, Initial_assessment_hour, Initial_assessment_minute, Treatment_time, Treatment_hour, Treatment_minute,  CCG_of_treatment = CCG_TREATMENT, TREAT2_01, TREAT2_02, TREAT2_03, TREAT2_04, TREAT2_05, TREAT2_06, TREAT2_07, TREAT2_08, TREAT2_09, TREAT2_10, TREAT2_11, TREAT2_12, TREAT3_01, TREAT3_02, TREAT3_03, TREAT3_04, TREAT3_05, TREAT3_06, TREAT3_07, TREAT3_08, TREAT3_09, TREAT3_10, TREAT3_11,  TREAT3_12, Distance_between_provider_lsoa_km = PROVDIST, PROVDIST_FLAG, NER_TREATMENT, SITETRET, SITEDIST, SITEDIST_FLAG)      

# To summarise with levels of a factor that has a zero cell
df_processed %>% 
  group_by(Arrival_age_band_five_neonatal) %>% 
  summarise(Attendances = n()) %>%
  complete(Arrival_age_band_five_neonatal, fill = list(Attendances = 0)) %>% 
  View()

df_processed %>% 
  group_by(ARRIVALDATE) %>% 
  summarise(n())

# Look to the future - ECDS 

# From NHS England
# The A&E data provides a simplistic picture of why people attend A&E and the treatment they receive. It was developed in the 1980s and since then the number of people, and their health needs, have changed.

# THE Emergency Care Dataset will improve patient care through better and more consistent information to allow better planning of healthcare services; and improve communication between health professionals.

# The better data we can capture, the more we can understand and commission services that improve care for patients and reduce pressure for staff.

# The ECDS contains 108 data items - Patient demographics (gender, ethnicity, age at activity date), episode information (including arrival and conclusion dates, source of referral and attendance category type), clinical information (chief complaint, acuity, diagnosis, investigations and treatments), injury information (data/time of injury, place type, activity and mechanism) and referred services and discharge information (onward referral for treatment, treatment complete, streaming, follow-up treatment and safeguarding concerns).