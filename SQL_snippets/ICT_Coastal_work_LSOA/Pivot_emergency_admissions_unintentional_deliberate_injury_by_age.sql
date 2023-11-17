-- This is the crude rate of hospital admissions caused by unintentional and deliberate injuries in children aged under 5 years per 10,000 resident population aged under 5 years.

-- The number of finished emergency admissions (episode number equals 1, admission method starts with 2), with one or more codes for injuries and other adverse effects of external causes (ICD 10: S00 to T79 and or V01 to Y36) in any diagnostic field position, in children (aged 0 to 4 years). Admissions are only included if they have a valid Local Authority code. Regions are the sum of the Local Authorities. England is the sum of all Local Authorities and admissions coded as U (England NOS). Admissions that only include T80 to T98 or Y40 to T98, quality of care issues, in any field are excluded.

-- LSOA x Age pivoted by financial years 2018/19 - 2022/23 
SELECT *
FROM (
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_1819_hdis_10years
-- Finished episodes only (3)
WHERE EPISTAT = '3'
-- Admission episode
AND FAE = 1
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Emergency admissions
AND ADMIMETH LIKE ('2%')
-- First episode of a spell
AND EPIORDER = 1
-- causes and conditions 
-- injuries and other adverse effects of external causes (ICD 10: S00 to T79 and or V01 to Y36)
AND (DIAG_3_CONCAT RLIKE ('S|V|W|X') 
AND DIAG_3_CONCAT RLIKE ('T[0-7]') 
OR DIAG_3_CONCAT RLIKE ('Y[0-2]|Y3[0-6]')) 
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
UNION ALL -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_1920_hdis_10years
-- Finished episodes only (3)
WHERE EPISTAT = '3'
-- Admission episode
AND FAE = 1
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Emergency admissions
AND ADMIMETH LIKE ('2%')
-- First episode of a spell
AND EPIORDER = 1
-- causes and conditions 
-- injuries and other adverse effects of external causes (ICD 10: S00 to T79 and or V01 to Y36)
AND (DIAG_3_CONCAT RLIKE ('S|V|W|X') 
AND DIAG_3_CONCAT RLIKE ('T[0-7]') 
OR DIAG_3_CONCAT RLIKE ('Y[0-2]|Y3[0-6]')) 
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
UNION ALL-- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2021_hdis_10years
-- Finished episodes only (3)
WHERE EPISTAT = '3'
-- Admission episode
AND FAE = 1
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Emergency admissions
AND ADMIMETH LIKE ('2%')
-- First episode of a spell
AND EPIORDER = 1
-- causes and conditions 
-- injuries and other adverse effects of external causes (ICD 10: S00 to T79 and or V01 to Y36)
AND (DIAG_3_CONCAT RLIKE ('S|V|W|X') 
AND DIAG_3_CONCAT RLIKE ('T[0-7]') 
OR DIAG_3_CONCAT RLIKE ('Y[0-2]|Y3[0-6]')) 
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
UNION ALL -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2122_hdis_10years
-- Finished episodes only (3)
WHERE EPISTAT = '3'
-- Admission episode
AND FAE = 1
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Emergency admissions
AND ADMIMETH LIKE ('2%')
-- First episode of a spell
AND EPIORDER = 1
-- causes and conditions 
-- injuries and other adverse effects of external causes (ICD 10: S00 to T79 and or V01 to Y36)
AND (DIAG_3_CONCAT RLIKE ('S|V|W|X') 
AND DIAG_3_CONCAT RLIKE ('T[0-7]') 
OR DIAG_3_CONCAT RLIKE ('Y[0-2]|Y3[0-6]')) 
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
UNION ALL -- this joins the results of queries together
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes, CASE WHEN STARTAGE_CALC BETWEEN 0 AND 4 THEN '0-4 years' WHEN STARTAGE_CALC BETWEEN 5 AND 9 THEN '5-9 years' WHEN STARTAGE_CALC BETWEEN 10 AND 14 THEN '10-14 years' WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years' WHEN STARTAGE_CALC BETWEEN 45 AND 49 THEN '45-49 years' WHEN STARTAGE_CALC BETWEEN 50 AND 54 THEN '50-54 years' WHEN STARTAGE_CALC BETWEEN 55 AND 59 THEN '55-59 years' WHEN STARTAGE_CALC BETWEEN 60 AND 64 THEN '60-64 years' WHEN STARTAGE_CALC BETWEEN 65 AND 69 THEN '65-69 years' WHEN STARTAGE_CALC BETWEEN 70 AND 74 THEN '70-74 years' WHEN STARTAGE_CALC BETWEEN 75 AND 79 THEN '75-79 years' WHEN STARTAGE_CALC BETWEEN 80 AND 84 THEN '80-84 years' WHEN STARTAGE_CALC BETWEEN 85 AND 89 THEN '85-89 years' WHEN STARTAGE_CALC BETWEEN 90 AND 120 THEN '90+ years' ELSE 'Unknown' END AS Age_group, LSOA11 AS LSOA11CD
FROM hdis_10years.hes_apc_2223_hdis_10years
-- Finished episodes only (3)
WHERE EPISTAT = '3'
-- Admission episode
AND FAE = 1
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Emergency admissions
AND ADMIMETH LIKE ('2%')
-- First episode of a spell
AND EPIORDER = 1
-- causes and conditions 
-- injuries and other adverse effects of external causes (ICD 10: S00 to T79 and or V01 to Y36)
AND (DIAG_3_CONCAT RLIKE ('S|V|W|X') 
AND DIAG_3_CONCAT RLIKE ('T[0-7]') 
OR DIAG_3_CONCAT RLIKE ('Y[0-2]|Y3[0-6]')) 
-- England and Unknown LAD only
AND RESLADST_ONS RLIKE ('E|U')
   )
    PIVOT
    (
        SUM(FAE)
        FOR Financial_year IN (('FY_201819'), ('FY_201920'), ('FY_202021'), ('FY_202122'), ('FY_202223'))
    )