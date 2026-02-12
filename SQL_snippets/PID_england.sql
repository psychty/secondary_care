SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_1516_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_1617_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_1718_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_1819_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_1920_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_2021_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_2122_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_2223_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_2324_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    GROUP BY Financial_year, Area_name, Age_group
UNION
SELECT
FYEAR AS Financial_year,
'England' AS Area_name,
CASE WHEN STARTAGE_CALC BETWEEN 0 AND 14 THEN '0-14 years'
WHEN STARTAGE_CALC BETWEEN 15 AND 19 THEN '15-19 years'
WHEN STARTAGE_CALC BETWEEN 20 AND 24 THEN '20-24 years'
WHEN STARTAGE_CALC BETWEEN 25 AND 29 THEN '25-29 years'
WHEN STARTAGE_CALC BETWEEN 30 AND 34 THEN '30-34 years'
WHEN STARTAGE_CALC BETWEEN 35 AND 39 THEN '35-39 years'
WHEN STARTAGE_CALC BETWEEN 40 AND 44 THEN '40-44 years'
WHEN STARTAGE_CALC BETWEEN 45 AND 120 THEN '45+ years'
ELSE 'Unknown' 
END AS Age_group,
SUM(FAE) AS admissions
FROM hdis_10years.hes_apc_2425_hdis_10years
 -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5) (e.g excludes regular attenders)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and 15 - 44 years valid starting age
    AND (STARTAGE_CALC >= 15 AND STARTAGE_CALC <= 44)
    -- Sex = female
    AND SEX = '2'
   -- England resident or no fixed abode/unknown
    AND RESCTY_ONS RLIKE ('E|U')
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
GROUP BY Financial_year, Area_name, Age_group
