-- Ambulatory Care Sensitive Conditions - record level extract

/* The number of finished and unfinished admission episodes, excluding transfers, for patients 
with an emergency method of admission and with a primary diagnosis of a chronic 
ambulatory care sensitive condition */

-- https://research-information.bris.ac.uk/ws/files/80892920/variation_for_priorities_03_06_16.pdf

SELECT ADMIMETH, ADMIAGE, QUINARY_ADMIAGE, FAE, FCE, FDE, ADMIDATE, DISDATE, DISDEST, GPPRAC, EPIORDER, EPISTAT, SEX, SPELDUR, CAUSE, DIAG_01, DIAG_02, DIAG_03, DIAG_04, DIAG_05, DIAG_06, DIAG_07, DIAG_08, DIAG_09, DIAG_10, DIAG_11, DIAG_12, DIAG_13, DIAG_14, DIAG_15,DIAG_16,DIAG_17,DIAG_18, DIAG_19, DIAG_20, RESLADST_ONS, CCG_RESIDENCE, CCG_RESPONSIBILITY, PROVSPNOPS, PROCODE
FROM hes.hes_apc_2021
/* Infections - hronic viral hepatitis B: Chronic viral hepatitis B with delta-agent (B180). Chronic viral hepatitis B without delta-agent (B181) (excludes people with a secondary diagnosis of D57 sickle-cell disorders) */
WHERE ((DIAG_4_01 IN ('B180', 'B181') AND DIAG_3_CONCAT NOT IN ('D57'))
/* Nutrition, endocrine, and metabolic - Diabetes: Insulin-dependent diabetes mellitus (E10), Non-insulin-dependent diabetes mellitus (E11), Malnutrition-related diabetes mellitus (E12), Other specified diabetes mellitus (E13), Unspecified diabetes mellitus (E14) */
OR DIAG_3_01 IN ('E10', 'E11', 'E12', 'E13', 'E14')
/* Diseases of the blood - Iron deficiency anaemia: Sideropenic dysphagia (D501), Other iron deficiency anaemias (D508), Iron deficiency anaemia, unspecified (D509); Vitamin B12 deficiency 
anaemia (D51), Folate deficiency anaemia (D52) */
OR DIAG_4_01 IN ('D501', 'D508', 'D509')
OR DIAG_3_01 IN ('D51', 'D52')
/* Mental or behavioural disorders - Dementia: Dementia in Alzheimer disease (F00), Vascular dementia (F01), Dementia in other diseases classified elsewhere (F02), Unspecified dementia (F03)*/
OR DIAG_3_01 IN ('F00', 'F01', 'F02', 'F03')
/* Neurological disorders - Convulsions and Epilepsy: Epilespsy (G40), Status epilepticus (G41)*/
OR DIAG_3_01 IN ('G40', 'G41')
/* Cardiovascular diseases - Congestive heart failure: Hypertensive heart disease with (congestive) heart failure (I110), Heart failure (I50), Pulmonary oedema (J81X), Hypertensive heart and renal 
disease with (congestive) heart failure (I130) - excluding certain operation codes */
OR((DIAG_3_01 = 'I50'OR DIAG_4_01 IN ('I110', 'J81X', 'I130')) AND OPERTN_3_CONCAT NOT IN ('K0', 'K1', 'K2', 'K3', 'K4', 'K50', 'K52', 'K55', 'K56', 'K57', 'K60', 'K61', 'K66', 'K67', 'K68', 'K69', 'K71', 'K73', 'K74'))
/* Cardiovascular diseases - Angina: Angina pectoris (I20), Chronic ischaemic heart 
disease (I25) - excluding certain operation codes */
OR (DIAG_3_01 IN ('I20', 'I25') AND OPERTN_3_CONCAT NOT RLIKE ('^A|^B|^C|^D|^E|^F|^G|^H|^I|^J|^K|^L|^M|^N|^O|^P|^Q|^R|^S|^T|^V|^W|^X0|^X1|^X2|^X4|^X5'))
/* Cardiovascular diseases - Hypertension: Essential (primary) hypertension (I10X), Hypertensive heart disease without (congestive) heart failure (I119) - excluding certain operation codes */
OR (DIAG_4_01 IN ('I10X', 'I119') AND OPERTN_3_CONCAT NOT RLIKE ('^K0|^K1|^K2|^K3|^K4|^K50|^K52|^K55|^K56|^K57|^K60|^K61|^K66|^K67|^K68|^K69|^K71|^K73|^K74'))
/* Cardiovascular dieases - Atrial fibrillation and flutter */
OR DIAG_3_01 IN ('I48')
/* Respiratory diseases - Chronic obstructive pulmonary disease: Acute bronchitis (J20), Simple and mucopurulent chronic bronchitis (J41), Unspecified chronic bronchitis (J42X), Emphysema (J43), Other chronic obstructive pulmonary disease (J44), Bronchiectasis (J47)*/
OR (DIAG_3_01 = 'J20' AND DIAG_3_CONCAT RLIKE ('J41|J42|J43|J44|J47')) -- J20 only with certain conditions codes
OR DIAG_3_01 IN ('J41', 'J43', 'J44') 
OR DIAG_4_01 IN ('J42X', 'J47X')
/* Respiratory diseases - Asthma (J45). Status asthmaticus (J46)*/
OR (DIAG_3_01 = 'J45' OR DIAG_4_01 = 'J46X'))
-- Age of the patient at the start of their episode of care. For this indicator all ages are considered.
-- I'm not sure this works
AND STARTAGE IS NOT NULL -- 120 OR (STARTAGE_CALC >= 7001 AND STARTAGE_CALC <= 7007))
-- Emergency admissions only
AND ADMIMETH LIKE '2%'
-- Unfinished (1) and Finished (3) episodes
AND EPISTAT = IN ('1', '3')
-- Admission date in year
-- The indicator also splits this by quarter
AND ADMIDATE >= '2020-04-01' AND ADMIDATE <= '2021-03-31'
-- Sex is male (1) or female (2) - exclude records where sex was unknown or unspecified.
AND SEX IN ('1', '2')
-- First episode in a spell
AND EPIORDER = 1
-- Exclude admission source of transfers 
AND ADMISORC NOT IN ('51', '52', '53')
-- Include just general health episode types (and exclude births/maternity/mental health episodes)
AND EPITYPE = '1'
-- Include ordinary admissions (and exclude day case, regular day/night attenders and mothers/babies using only delivery facilities)
AND CLASSPAT = '1'
-- AND ccg_responsibility IN ('09G', '09X', '09H')
-- West Sussex LTLAs
WHERE RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E0700022', 'E07000229')
--GROUP BY fyear, sex, ccg_responsibility;



