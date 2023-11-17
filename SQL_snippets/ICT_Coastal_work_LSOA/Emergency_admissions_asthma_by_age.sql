-- There are two indicators for asthma: 0-18 and 19+ (90810, 93573) respectively

-- Emergency admissions to hospital in persons (aged 19 years and over) where the primary diagnosis is asthma (ICD-10 codes J45, J46)

-- The 0-18 indicator is a crude rate and the 19+ is directly age standardised

-- To check England all ages 2021/22 figure (numerator)
SELECT FYEAR AS Financial_year, SUM(FAE), CASE WHEN STARTAGE_CALC BETWEEN 0 AND 18 THEN '0-18 years' WHEN STARTAGE_CALC BETWEEN 19 AND 120 THEN '19+ years' ELSE 'Unknown' END AS Age_group
FROM hdis_10years.hes_apc_2122_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), or maternity (5), or unknown (9)
-- check - the description says regular and day cases are excluded
AND CLASSPAT IN ('1','5', '8', '9')
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Conditions and causes
-- Primary diagnosis of Asthma or Status Asthmaticus (ICD10 code J45 or J46)
AND DIAG_3_01 RLIKE ('J4[56]')
-- England and Unknown LAD only
AND CCG_RESPONSIBILITY NOT RLIKE ('59999')
GROUP BY Financial_year, Age_group

-- Emergency admissions to hospital where the primary diagnosis is pneumonia (ICD-10 codes J12-J18). Directly age standardised rate per 100,000 population (standardised to the European standard population)
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_1819_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Conditions and causes
-- Primary diagnosis asthma or status asthmaticus (J45 or J46)
AND DIAG_3_01 RLIKE ('J4[56]')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_1920_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Conditions and causes
-- Primary diagnosis asthma or status asthmaticus (J45 or J46)
AND DIAG_3_01 RLIKE ('J4[56]')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2021_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Conditions and causes
-- Primary diagnosis asthma or status asthmaticus (J45 or J46)
AND DIAG_3_01 RLIKE ('J4[56]')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2122_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Conditions and causes
-- Primary diagnosis asthma or status asthmaticus (J45 or J46)
AND DIAG_3_01 RLIKE ('J4[56]')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2223_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Conditions and causes
-- Primary diagnosis asthma or status asthmaticus (J45 or J46)
AND DIAG_3_01 RLIKE ('J4[56]')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year