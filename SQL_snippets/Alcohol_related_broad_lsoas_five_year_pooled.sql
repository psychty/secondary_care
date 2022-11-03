SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1112
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1213
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1314
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1415
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1516
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
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
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1718
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1819
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1920
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_2021
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))
UNION 
SELECT FYEAR, EPIKEY, PSEUDO_HESID, ADMIDATE, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 15 THEN '0-15 years' WHEN STARTAGE_CALC BETWEEN 16 AND  24 THEN '16-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  34 THEN '25-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  44 THEN '35-44 years' WHEN STARTAGE_CALC BETWEEN  45 AND  54 THEN '45-54 years' WHEN STARTAGE_CALC BETWEEN  55 AND  64 THEN '55-64 years' WHEN STARTAGE_CALC BETWEEN  65 AND  74 THEN '65-74 years' WHEN STARTAGE_CALC BETWEEN  75 AND  84 THEN '75-84 years' WHEN STARTAGE_CALC BETWEEN  85 AND 150 THEN '85 and over' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_2122
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Age 16+
-- AND Age_group NOT RLIKE ('Unknown|0-15 years')
-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2011-04-01' AND EPIEND <= '2022-03-31'
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
OR DIAG_3_CONCAT RLIKE ('I6[0-2]')
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
OR DIAG_4_CONCAT RLIKE ('V0[234][19]|V09[23]|V1[2-4][3-9]|V19[4-6]|V2[0-8][3-9]|V29[4-9]|V3[0-9][4-9]|V4[0-9][4-9]|V5[0-9][4-9]|V6[0-9][4-9]|V7[0-9][4-9]|V80[3-5]|V8[12]1|V8[3-6][0-3]|V87[0-8]|V892')
-- Poisoning 
OR DIAG_3_CONCAT RLIKE ('X4[0-4]|X[6-9]')
-- Fall injuries
OR DIAG_3_CONCAT RLIKE ('W[01]%')
-- Fire injuries
OR DIAG_3_CONCAT RLIKE ('X0%')
-- Drowning
OR DIAG_3_CONCAT RLIKE ('X6[5-9]|X7[0-4]')
-- Other unintentional injuries
OR DIAG_4_CONCAT RLIKE ('V01|V09[019]|V10[0-9]|V11[0-9]|V1[234][0-2]|V1[5-8][0-9]|V19[1-3]|V2[0-8][12]|V29[0-3]|V3[0-8][12]|V39[0-3]|V4[0-8][12]|V49[0-3]|V5[0-8][12]|V59[0-3]|V6[0-8][12]|V69[0-3]|V7[0-8][12]|V79[0-3]|V80[016789]|V81[023456789]|V82[023456789]|V8[3-6][4-9]|V879|V88|V89[013456789]|V9[0-9]|W[234][0-9]|W5[0-2]|W7[5-9]|W[89][0-9]|X[12][0-9]|X3[0-3]|X5[0-9]|Y[4-7][0-9]|Y8[0-6]|Y8[89]')
-- Intentional injuries
OR DIAG_4_CONCAT RLIKE ('X6[0-4]|X6[6-9]|X7|X8[0-4]|Y870')
-- Event of undetermined intent
OR DIAG_4_CONCAT RLIKE ('Y1[0-4]|Y1[6-9]|Y2|Y3[0-4]|Y872')
-- Assault
OR DIAG_4_CONCAT RLIKE ('X8[5-9]|X9|Y0|Y871'))