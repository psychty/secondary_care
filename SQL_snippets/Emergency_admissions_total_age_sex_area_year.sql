-- Aggregated total number of emergency admissions
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1213_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Emergency (non-elective) admission
AND ADMIMETH LIKE ('2%')
-- Finished admission episode 
AND FAE = 1
-- First episode of spell
AND EPIORDER = 1
-- Sussex LTLAs or Sussex CCGs of responsibility
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1314_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1415_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1516_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1617_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1718_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1819_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_1920_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_2021_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_2122_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD
UNION
SELECT COUNT(EPIKEY) AS Emergency_admissions, EXTRACT(MONTH FROM ADMIDATE) AS Month_of_admission, EXTRACT(YEAR FROM ADMIDATE) AS Year_of_admission, FYEAR AS Financial_year, SEX AS Sex, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+' ELSE 'Unknown' END AS Age_group, MSOA11 AS MSOA11CD
FROM hdis_10years.hes_apc_2223_hdis_10years
WHERE EPISTAT = '3'
AND CLASSPAT IN ('1','2','5')
AND ADMIMETH LIKE ('2%')
AND FAE = 1
AND EPIORDER = 1
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063','E07000064','E07000065')
GROUP BY Month_of_admission, Year_of_admission, Financial_year, Sex, Age_group, MSOA11CD