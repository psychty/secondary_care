-- This query searchers for delivery of infant operations among people whose responsible ccg is in sussex, accross six tables and column binds (using union) the results
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, OPERTN_3_01, OPERTN_4_01, OPERTN_4_CONCAT, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, GPPRAC AS GP_Practice, ETHNOS AS Ethnicity, STARTAGE_CALC, PROCODE3, CCG_RESPONSIBILITY, EPIKEY, EPIDUR, EPIORDER, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 19 THEN '0-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND  24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN  30 AND  34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN  40 AND 150 THEN '40 and over' ELSE 'Unknown' END AS Age_group 
FROM hes.hes_apc_1617
-- Operation code (first or any of the operation codes) is 'delivery of infant' (R17-R25)
WHERE OPERTN_4_CONCAT RLIKE ('R1[7-9]|R2[0-5]')
-- CCG of responsibility in Sussex (this includes the new East and West Sussex CCGs)
AND CCG_RESPONSIBILITY RLIKE ('09[DFGHPX]|99K|70F|97R')
UNION
-- join results of an identical query but on 1718 table
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, OPERTN_3_01, OPERTN_4_01, OPERTN_4_CONCAT, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, GPPRAC AS GP_Practice, ETHNOS AS Ethnicity, STARTAGE_CALC, PROCODE3, CCG_RESPONSIBILITY, EPIKEY, EPIDUR, EPIORDER, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 19 THEN '0-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND  24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN  30 AND  34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN  40 AND 150 THEN '40 and over' ELSE 'Unknown' END AS Age_group 
FROM hes.hes_apc_1718
WHERE OPERTN_4_CONCAT RLIKE ('R1[7-9]|R2[0-5]')
AND CCG_RESPONSIBILITY RLIKE ('09[DFGHPX]|99K|70F|97R')
UNION
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, OPERTN_3_01, OPERTN_4_01, OPERTN_4_CONCAT, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, GPPRAC AS GP_Practice, ETHNOS AS Ethnicity, STARTAGE_CALC, PROCODE3, CCG_RESPONSIBILITY, EPIKEY, EPIDUR, EPIORDER, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 19 THEN '0-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND  24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN  30 AND  34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN  40 AND 150 THEN '40 and over' ELSE 'Unknown' END AS Age_group 
FROM hes.hes_apc_1819
WHERE OPERTN_4_CONCAT RLIKE ('R1[7-9]|R2[0-5]')
AND CCG_RESPONSIBILITY RLIKE ('09[DFGHPX]|99K|70F|97R')
UNION
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, OPERTN_3_01, OPERTN_4_01, OPERTN_4_CONCAT, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, GPPRAC AS GP_Practice, ETHNOS AS Ethnicity, STARTAGE_CALC, PROCODE3, CCG_RESPONSIBILITY, EPIKEY, EPIDUR, EPIORDER, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 19 THEN '0-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND  24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN  30 AND  34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN  40 AND 150 THEN '40 and over' ELSE 'Unknown' END AS Age_group 
FROM hes.hes_apc_1920
WHERE OPERTN_4_CONCAT RLIKE ('R1[7-9]|R2[0-5]')
AND CCG_RESPONSIBILITY RLIKE ('09[DFGHPX]|99K|70F|97R')
UNION
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, OPERTN_3_01, OPERTN_4_01, OPERTN_4_CONCAT, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, GPPRAC AS GP_Practice, ETHNOS AS Ethnicity, STARTAGE_CALC, PROCODE3, CCG_RESPONSIBILITY, EPIKEY, EPIDUR, EPIORDER, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 19 THEN '0-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND  24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN  30 AND  34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN  40 AND 150 THEN '40 and over' ELSE 'Unknown' END AS Age_group 
FROM hes.hes_apc_2021
WHERE OPERTN_4_CONCAT RLIKE ('R1[7-9]|R2[0-5]')
AND CCG_RESPONSIBILITY RLIKE ('09[DFGHPX]|99K|70F|97R')
UNION
SELECT FYEAR, PSEUDO_HESID, ADMIDATE, OPERTN_3_01, OPERTN_4_01, OPERTN_4_CONCAT, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, GPPRAC AS GP_Practice, ETHNOS AS Ethnicity, STARTAGE_CALC, PROCODE3, CCG_RESPONSIBILITY, EPIKEY, EPIDUR, EPIORDER, FAE, FCE, FDE, RESLADST_ONS, SEX,  CASE WHEN STARTAGE_CALC BETWEEN 0 AND 19 THEN '0-19 years' WHEN STARTAGE_CALC BETWEEN 20 AND  24 THEN '20-24 years' WHEN STARTAGE_CALC BETWEEN  25 AND  29 THEN '25-29 years' WHEN STARTAGE_CALC BETWEEN  30 AND  34 THEN '30-34 years' WHEN STARTAGE_CALC BETWEEN  35 AND  39 THEN '35-39 years' WHEN STARTAGE_CALC BETWEEN  40 AND 150 THEN '40 and over' ELSE 'Unknown' END AS Age_group 
FROM hes.hes_apc_2122
WHERE OPERTN_4_CONCAT RLIKE ('R1[7-9]|R2[0-5]')
AND CCG_RESPONSIBILITY RLIKE ('09[DFGHPX]|99K|70F|97R')