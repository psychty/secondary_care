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

Treatment_lookup_three <- data.frame(Code = c(), Treatment = c(011 = Dressing minor wound/burn/eye\r\r\n012 = Dressing major wound/burn\r\r\n02 = Bandage/support\r\r\n031 = Primary sutures\r\r\n032 = Secondary/complex suture\r\r\n033 = Removal of sutures/clips\r\r\n041 = Wound closure - steristrips\r\r\n042 = Wound closure - wound glue\r\r\n043 = Wound closure - other (eg clips)\r\r\n051 = Plaster of Paris - application\r\r\n052 = Plaster of Paris - removal\r\r\n06 = Splint\r\r\n08 = Removal foreign body\r\r\n091 = Physiotherapy - strapping, ultra sound treatment, short wave diathermy,manipulation\r\r\n092 = Physiotherapy - gait re-education, falls prevention\r\r\n101 = Manipulation of upper limb fracture\r\r\n102 = Manipulation of lower limb fracture\r\r\n103 = Manipulation of dislocation\r\r\n11 = Incision and drainage\r\r\n12 = Intravenous cannula\r\r\n13 = Central line\r\r\n14 = Lavage/emesis/charcoal/eye irrigation\r\r\n15 = Intubation & Endotracheal tubes/laryngeal mask airways/rapid sequence induction\r\r\n16 = Chest drain\r\r\n17 = Urinary catheter/suprapubic\r\r\n181 = Defibrillation\r\r\n182 = External pacing\r\r\n19 = Resuscitation/cardiopulmonary resuscitation\r\r\n20 = Minor surgery\r\r\n21 = Observation/electrocardiogram,pulse oximetry/head injury/trends\r\r\n221 = Guidance/advice only - written\r\r\n222 = Guidance/advice only - verbal\r\r\n231 = Anaesthesia - general\r\r\n232 = Anaesthesia - local\r\r\n233 = Anaesthesia - regional block\r\r\n234 = Anaesthesia - etonox\r\r\n235 = Anaesthesia - sedation\r\r\n236 = Anaesthesia - other\r\r\n241 = Tetanus - immune\r\r\n242 = Tetanus - tetanus toxoid course\r\r\n243 = Tetanus - tetanus toxoid booster\r\r\n244 = Tetanus - human immunoglobin\r\r\n245 = Tetanus - combined tetanus/diphtheria course\r\r\n246 = Tetanus - combined tetanus/diphtheria booster\r\r\n25 = Nebulise/spacer\r\r\n27 = Other (consider alternatives)\r\r\n281 = Parenteral thrombolysis - streptokinase parenteral thrombolysis\r\r\n282 = Parenteral thrombolysis - recombinant - plasminogen activator\r\r\n291 = Other parenteral drugs - intravenous drug eg stat/bolus\r\r\n292 = Other parenteral drugs - intravenous infusion\r\r\n30 = Recording vital signs\r\r\n31 = Burns review\r\r\n32 = Recall/x-ray review\r\r\n33 = Fracture review\r\r\n34 = Wound cleaning\r\r\n35 = Dressing/wound review\r\r\n36 = Sling/collar cuff/broad arm sling\r\r\n37 = Epistaxis control\r\r\n38 = Nasal airway\r\r\n39 = Oral airway\r\r\n40 = Supplemental oxygen\r\r\n41 = Continuous positive airways pressure/nasal intermittent positive pressure ventilation/bag valve mask\r\r\n42 = Arterial line\r\r\n43 = Infusion fluids\r\r\n44 = Blood product transfusion\r\r\n45 = Pericardiocentesis\r\r\n46 = Lumbar puncture\r\r\n47 = Joint aspiration\r\r\n48 = Minor plastic procedure/splint skin graft\r\r\n49 = Active rewarming of the hypothermic patient\r\r\n50 = Cooling - control body temperature\r\r\n511 = Medication administered - oral\r\r\n512 = Medication administered - intra-muscular\r\r\n513 = Medication administered - subcutaneous\r\r\n514 = Medication administered - per rectum\r\r\n515 = Medication administered - sublingual\r\r\n516 = Medication administered - intra-nasal\r\r\n517 = Medication administered - eye drops\r\r\n518 = Medication administered - ear drops\r\r\n519 = Medication administered - topical skin cream\r\r\n521 = Occupational therapy functional assessments\r\r\n522 = Occupational therapy activities of daily living equipment provision\r\r\n53 = Loan of walking aid (crutches)\r\r\n54 = Social worker intervention\r\r\n551 = Eye - orthoptic exercises\r\r\n552 = Eye - laser of retina/iris or posterior capsule\r\r\n553 = Eye - retrobulbar injection\r\r\n554 = Eye - epilation of lashes\r\r\n555 = Eye - subconjunctival injection\r\r\n56 = Dental treatment\r\r\n57 = Prescription/medicines prepared to take away\r\r\n99 = None (consider guidance/advice option)\r\r\n))

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
                         DIAGA_12 = col_character()),
        na = "null")) %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', 'Unknown')))

df_processed <- df_raw %>% 
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
         Initial_assessment_minute = minute(as.period(hms(sub("(.{2})", "\\1:", sprintf("%04d:00", as.numeric(Initial_assessment_time)))), unit = "minute")))
  
df_processed %>% 
  group_by(InvE) %>% 
  summarise(n()) %>% 
  View()

field_x <- HES_data_dictionary %>% 
  filter(str_detect(Field, regex('treat3', ignore_case = TRUE)))

field_x$Name
field_x$Description
unique(field_x$Values)

df_processed %>% 
  group_by(as.numeric(ARRIVALTIME)) %>% 
  summarise(n()) %>% 
  View()

df_processed %>% 
  group_by(Arrival_month, Arrival_month_year, Arrival_quarter_calendar, Arrival_quarter_financial) %>% 
  summarise(Attendances = n()) %>% 
  View()

max(df_processed$ARRIVALDATE)

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