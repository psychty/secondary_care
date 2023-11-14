-- The number of first finished emergency admission episodes in patients (episode number equals 1, admission method starts with 2), with a recording of self harm by cause code (ICD10 X60 to X84) in financial year in which episode ended. Regular and day attenders have been excluded. Regions are the sum of the Local Authorities. England is the sum of all Local Authorities and admissions coded as U (England NOS).

-- To check England all ages 2021/22 figure (numerator)
SELECT FYEAR AS Financial_year, SUM(FAE) 
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
AND CAUSE_3 RLIKE ('X[67]|X8[0-4]')
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
GROUP BY Financial_year

-- The number of first finished emergency admission episodes in patients (episode number equals 1, admission method starts with 2), with a recording of self harm by cause code (ICD10 X60 to X84) in financial year in which episode ended. Regular and day attenders have been excluded. Regions are the sum of the Local Authorities. England is the sum of all Local Authorities and admissions coded as U (England NOS).
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_1819_hdis_10years
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
-- External cause of self harm (ICD X60-X84)
AND CAUSE_3 RLIKE ('X[67]|X8[0-4]')
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_1920_hdis_10years
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
AND CAUSE_3 RLIKE ('X[67]|X8[0-4]')
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2021_hdis_10years
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
AND CAUSE_3 RLIKE ('X[67]|X8[0-4]')
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
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
AND CAUSE_3 RLIKE ('X[67]|X8[0-4]')
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
UNION -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 THEN 'Female' ELSE 'Unknown' END AS Sex,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2223_hdis_10years
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
AND CAUSE_3 RLIKE ('X[67]|X8[0-4]')
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
GROUP BY LSOA11CD, Sex, Age_group, Financial_year
