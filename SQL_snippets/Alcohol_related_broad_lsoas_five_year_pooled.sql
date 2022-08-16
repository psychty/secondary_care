-- Admissions to hospital where the primary diagnosis or any of the secondary diagnoses are an alcohol-specific (wholly attributable) condition. Directly age standardised rate per 100,000 population (standardised to the European standard population). 
-- More specifically, hospital admissions records are identified where the admission is a finished episode [epistat = 3]; the admission is an ordinary admission, day case or maternity [classpat = 1, 2 or 5]; it is an admission episode [epiorder = 1]; the sex of the patient is valid [sex = 1 or 2]; there is a valid age at start of episode [startage between 0 and 150 or between 7001 and 7007]; the region of residence is one of the English regions, no fixed abode or unknown [resgor<= K or U or Y]; the episode end date [epiend] falls within the financial year, and an alcohol-attributable ICD10 code (whole or partly attributable) appears in the primary diagnosis field [diag_01] or an alcohol-related external cause code appears in any diagnosis field [diag_nn].
-- For each episode identified, an alcohol-attributable fraction is applied to the primary diagnosis field or an alcohol-attributable external cause code appears in one of the secondary codes based on the diagnostic codes, age group, and sex of the patient.  Where there is more than one alcohol-related ICD10 code among the 20 possible diagnostic codes the codes with the largest alcohol attributable fraction is selected; in the event of there being two or more codes with the same alcohol-attributable fraction within the same episode, the one from the lowest diagnostic position is selected. For a detailed list of all alcohol attributable diseases, including ICD 10 codes and relative risks see  ‘Alcohol-attributable fractions for England: an update’ (4).
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1617
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2016-04-01' AND EPIEND <= '2021-03-31'
-- Conditions
-- Wholly attributable
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_3_CONCAT RLIKE ('F10')
-- Alcoholic liver disease
OR DIAG_3_CONCAT RLIKE ('K70')
-- Toxic effect of alcohol (selected conditioncodes)
OR DIAG_4_CONCAT RLIKE ('T51[019]') 
-- Other wholly attributable conditions
OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91')
-- Partly attributable
-- Tuberculosis
OR DIAG_3_CONCAT RLIKE ('A1[56789]')
-- Cancer 
OR DIAG_3_CONCAT RLIKE ('C0%|C1[123458]|C2[02]|C32|C50')
-- Type II diabetes mellitus
-- Note: Those conditions with a negative (protective AAF) are excluded so we will not extract those just because they have E11
-- OR DIAG_3_CONCAT RLIKE ('E11')
-- Epilepsy and Status epilepticus
OR DIAG_3_CONCAT RLIKE ('G4[01]')
-- Hypertensive diseases
OR DIAG_3_CONCAT RLIKE ('I1[0-5]')
-- Ischaemic heart disease is also completely excluded as all cohorts have negative AAFs
-- OR DIAG_3_CONCAT RLIKE ('12[0-5]')
-- Cardiac arrhythmias
OR DIAG_3_CONCAT RLIKE ('I4[78]')
-- Heart failure
OR DIAG_3_CONCAT RLIKE ('I5[01]')
-- Ischaemic stroke
-- The documentation separates mortality and morbidity; We'll extract it all and then can easily switch versions later
OR DIAG_3_CONCAT RLIKE ('I6[3-6]')
OR DIAG_4_CONCAT RLIKE ('I69[34]')
-- Haemorrhagic stroke
OR DIAG_3_CONCAT 'I6[0-2]'
OR DIAG_4_CONCAT RLIKE ('I69[0-2]')
-- Oesophageal varices
OR DIAG_3_CONCAT RLIKE ('I85')
-- Pneumonia 
OR DIAG_4_CONCAT RLIKE ('J1[01]0') 
OR DIAG_3_CONCAT RLIKE ('J1[2-5]|J18')
-- Unspecified liver disease
OR DIAG_3_CONCAT RLIKE ('K7[34]')
-- Cholelithiasis (gall stones) is also completely excluded as all cohorts have negative AAFs
-- OR DIAG_3_CONCAT RLIKE ('K80')
-- Acute and chronic pancreatitis
OR DIAG_3_CONCAT RLIKE ('K85') -- we do not need to exclude the k852 here as it is a condition code we'll be searching for anyway
OR DIAG_4_CONCAT RLIKE ('K861')
-- Spontaneous abortion 
OR DIAG_3_CONCAT RLIKE ('O03')
-- Low birth weight 
OR DIAG_3_CONCAT RLIKE ('P0[5-7]')

-- Unintentional injuries - road/pedestrian traffic accidents
OR DIAG_4_CONCAT RLIKE ('V0[234][1-9]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-9][3-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3456][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[012346789]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_3_CONCAT RLIKE ('V01|V88|V9%|W[2-4]%|W5[0-2]|W7[5-9]|W8%|W9%|X1%|X2%|X3[0-3]|X5%|Y4%|Y5%|Y6%|Y7%|Y8[0-6]|Y8[89]')
OR DIAG_4_CONCAT RLIKE ('V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V89[013456789]')
-- Intentional injuries
OR DIAG_3_CONCAT RLIKE ('X6%|X7%|X8[0-4]')
OR (DIAG_4_CONCAT RLIKE ('Y870') AND DIAG_3_CONCAT NOT RLIKE ('X65'))
-- Event of undetermined intent
OR DIAG_3_CONCAT RLIKE ('Y1%|Y2%|Y3[0-4]')
OR (DIAG_4_CONCAT RLIKE ('Y872') AND DIAG_3_CONCAT NOT RLIKE ('Y15'))
-- Assault
OR DIAG_3_CONCAT RLIKE ('X8[5-9]|X9%|Y0%')
OR DIAG_4_CONCAT RLIKE ('Y871'))