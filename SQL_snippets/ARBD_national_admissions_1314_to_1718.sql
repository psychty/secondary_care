SELECT PERSON_ID_DEID, CLASSPAT, ADMIDATE, ADMIMETH, DISMETH, DISDEST, EPIKEY, EPIDUR, EPIORDER, EPISTART, EPISTAT, AEKEY, FAE, FCE, FDE,ETHNOS AS Ethnicity, GPPRAC AS GP_Practice, CCG_RESPONSIBILITY AS CCG_of_responsibility, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' WHEN SEX = 9 THEN 'Not specified' WHEN SEX = 'X' THEN 'Not known' ELSE 'Unknown' END AS Sex, SEX AS Sex_raw, LSOA11 AS LSOA11CD, RESLADST_ONS AS LTLA, CASE WHEN FYEAR = 1314 THEN 'FY_201314' WHEN FYEAR = 1415 THEN 'FY_201415' WHEN FYEAR = 1516 THEN 'FY_201516' WHEN FYEAR = 1617 THEN 'FY_201617'  WHEN FYEAR = 1718 THEN 'FY_201718'  WHEN FYEAR = 1819 THEN 'FY_201819' WHEN FYEAR = 1920 THEN 'FY_201920' WHEN FYEAR = 2021 THEN 'FY_202021' WHEN FYEAR = 2122 THEN 'FY_202122' WHEN FYEAR = 2223 THEN 'FY_202223' WHEN FYEAR = 2324 THEN 'FY_202324' ELSE FYEAR END AS Financial_year, FYEAR, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 18 THEN '15-18 years' WHEN STARTAGE_CALC = 19 THEN '19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 120 THEN '85+ years' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC
FROM hdis_10years.hes_apc_1314_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Valid start age
AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE >= 7001 AND STARTAGE <= 7007))
-- To match England totals
AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- Conditions
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_4_CONCAT RLIKE ('E512|F10[67]|G312|G621'))
UNION
SELECT PERSON_ID_DEID, CLASSPAT, ADMIDATE, ADMIMETH, DISMETH, DISDEST, EPIKEY, EPIDUR, EPIORDER, EPISTART, EPISTAT, AEKEY, FAE, FCE, FDE,ETHNOS AS Ethnicity, GPPRAC AS GP_Practice, CCG_RESPONSIBILITY AS CCG_of_responsibility, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' WHEN SEX = 9 THEN 'Not specified' WHEN SEX = 'X' THEN 'Not known' ELSE 'Unknown' END AS Sex, SEX AS Sex_raw, LSOA11 AS LSOA11CD, RESLADST_ONS AS LTLA, CASE WHEN FYEAR = 1314 THEN 'FY_201314' WHEN FYEAR = 1415 THEN 'FY_201415' WHEN FYEAR = 1516 THEN 'FY_201516' WHEN FYEAR = 1617 THEN 'FY_201617'  WHEN FYEAR = 1718 THEN 'FY_201718'  WHEN FYEAR = 1819 THEN 'FY_201819' WHEN FYEAR = 1920 THEN 'FY_201920' WHEN FYEAR = 2021 THEN 'FY_202021' WHEN FYEAR = 2122 THEN 'FY_202122' WHEN FYEAR = 2223 THEN 'FY_202223' WHEN FYEAR = 2324 THEN 'FY_202324' ELSE FYEAR END AS Financial_year, FYEAR, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 18 THEN '15-18 years' WHEN STARTAGE_CALC = 19 THEN '19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 120 THEN '85+ years' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC
FROM hdis_10years.hes_apc_1415_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Valid start age
AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE >= 7001 AND STARTAGE <= 7007))
-- To match England totals
AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- Conditions
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_4_CONCAT RLIKE ('E512|F10[67]|G312|G621'))
UNION
SELECT PERSON_ID_DEID, CLASSPAT, ADMIDATE, ADMIMETH, DISMETH, DISDEST, EPIKEY, EPIDUR, EPIORDER, EPISTART, EPISTAT, AEKEY, FAE, FCE, FDE,ETHNOS AS Ethnicity, GPPRAC AS GP_Practice, CCG_RESPONSIBILITY AS CCG_of_responsibility, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' WHEN SEX = 9 THEN 'Not specified' WHEN SEX = 'X' THEN 'Not known' ELSE 'Unknown' END AS Sex, SEX AS Sex_raw, LSOA11 AS LSOA11CD, RESLADST_ONS AS LTLA, CASE WHEN FYEAR = 1314 THEN 'FY_201314' WHEN FYEAR = 1415 THEN 'FY_201415' WHEN FYEAR = 1516 THEN 'FY_201516' WHEN FYEAR = 1617 THEN 'FY_201617'  WHEN FYEAR = 1718 THEN 'FY_201718'  WHEN FYEAR = 1819 THEN 'FY_201819' WHEN FYEAR = 1920 THEN 'FY_201920' WHEN FYEAR = 2021 THEN 'FY_202021' WHEN FYEAR = 2122 THEN 'FY_202122' WHEN FYEAR = 2223 THEN 'FY_202223' WHEN FYEAR = 2324 THEN 'FY_202324' ELSE FYEAR END AS Financial_year, FYEAR, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 18 THEN '15-18 years' WHEN STARTAGE_CALC = 19 THEN '19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 120 THEN '85+ years' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC
FROM hdis_10years.hes_apc_1516_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Valid start age
AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE >= 7001 AND STARTAGE <= 7007))
-- To match England totals
AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- Conditions
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_4_CONCAT RLIKE ('E512|F10[67]|G312|G621'))
UNION
SELECT PERSON_ID_DEID, CLASSPAT, ADMIDATE, ADMIMETH, DISMETH, DISDEST, EPIKEY, EPIDUR, EPIORDER, EPISTART, EPISTAT, AEKEY, FAE, FCE, FDE,ETHNOS AS Ethnicity, GPPRAC AS GP_Practice, CCG_RESPONSIBILITY AS CCG_of_responsibility, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' WHEN SEX = 9 THEN 'Not specified' WHEN SEX = 'X' THEN 'Not known' ELSE 'Unknown' END AS Sex, SEX AS Sex_raw, LSOA11 AS LSOA11CD, RESLADST_ONS AS LTLA, CASE WHEN FYEAR = 1314 THEN 'FY_201314' WHEN FYEAR = 1415 THEN 'FY_201415' WHEN FYEAR = 1516 THEN 'FY_201516' WHEN FYEAR = 1617 THEN 'FY_201617'  WHEN FYEAR = 1718 THEN 'FY_201718'  WHEN FYEAR = 1819 THEN 'FY_201819' WHEN FYEAR = 1920 THEN 'FY_201920' WHEN FYEAR = 2021 THEN 'FY_202021' WHEN FYEAR = 2122 THEN 'FY_202122' WHEN FYEAR = 2223 THEN 'FY_202223' WHEN FYEAR = 2324 THEN 'FY_202324' ELSE FYEAR END AS Financial_year, FYEAR, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 18 THEN '15-18 years' WHEN STARTAGE_CALC = 19 THEN '19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 120 THEN '85+ years' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC
FROM hdis_10years.hes_apc_1617_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Valid start age
AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE >= 7001 AND STARTAGE <= 7007))
-- To match England totals
AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- Conditions
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_4_CONCAT RLIKE ('E512|F10[67]|G312|G621'))
UNION
SELECT PERSON_ID_DEID, CLASSPAT, ADMIDATE, ADMIMETH, DISMETH, DISDEST, EPIKEY, EPIDUR, EPIORDER, EPISTART, EPISTAT, AEKEY, FAE, FCE, FDE,ETHNOS AS Ethnicity, GPPRAC AS GP_Practice, CCG_RESPONSIBILITY AS CCG_of_responsibility, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' WHEN SEX = 9 THEN 'Not specified' WHEN SEX = 'X' THEN 'Not known' ELSE 'Unknown' END AS Sex, SEX AS Sex_raw, LSOA11 AS LSOA11CD, RESLADST_ONS AS LTLA, CASE WHEN FYEAR = 1314 THEN 'FY_201314' WHEN FYEAR = 1415 THEN 'FY_201415' WHEN FYEAR = 1516 THEN 'FY_201516' WHEN FYEAR = 1617 THEN 'FY_201617'  WHEN FYEAR = 1718 THEN 'FY_201718'  WHEN FYEAR = 1819 THEN 'FY_201819' WHEN FYEAR = 1920 THEN 'FY_201920' WHEN FYEAR = 2021 THEN 'FY_202021' WHEN FYEAR = 2122 THEN 'FY_202122' WHEN FYEAR = 2223 THEN 'FY_202223' WHEN FYEAR = 2324 THEN 'FY_202324' ELSE FYEAR END AS Financial_year, FYEAR, CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02, DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 18 THEN '15-18 years' WHEN STARTAGE_CALC = 19 THEN '19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 120 THEN '85+ years' ELSE 'Unknown' END AS Age_group, STARTAGE_CALC
FROM hdis_10years.hes_apc_1718_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Valid start age
AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE >= 7001 AND STARTAGE <= 7007))
-- To match England totals
AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- Conditions
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_4_CONCAT RLIKE ('E512|F10[67]|G312|G621'))
