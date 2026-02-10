-- Pelvic Inflammatory Disease (PID) hospital admissions - record level extract

/* The number of hospital admissions with any mention (primary or secondary diagnosis in any position) of PID (ICD10 codes in the range N70-N74) in females aged 15-44 years in the financial year (April to March). */

SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
     -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
     -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION    
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
  -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
   -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
     -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
    -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
   -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
    -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
     -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
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
     -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')
    UNION
SELECT FYEAR AS Financial_year, EPIKEY, PERSON_ID_DEID AS Person_ID, ADMIDATE AS Admission_date, ADMISORC AS Admission_source, 
ADMIMETH AS Admission_method, EPIDUR AS Episode_duration, EPIEND AS Episode_end_date, EPIORDER AS Episode_order, 
EPISTART AS Episode_start_date, EPISTAT AS Episode_status,  CAUSE_3, CAUSE_4, DIAG_3_CONCAT, DIAG_4_CONCAT, 
DIAG_COUNT, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, CASE WHEN SEX = 1 THEN 'Male' WHEN SEX = 2 
THEN 'Female' ELSE 'Unknown' END AS Sex, STARTAGE_CALC AS Age_years_calc, LSOA11 AS LSOA11CD, MSOA11 AS MSOA11CD, 
GPPRAC AS ODS_Code, SPELBGIN AS Beginning_of_spell_indicator, SPELDUR AS Duration_of_spell, 
SPELDUR_CALC AS Duration_of_spell_excluding_regular_day_case, SPELEND AS End_of_spell_indicator, 
DISDATE AS Discharge_date, DISMETH AS Discharge_method, DISDEST AS Discharge_destination, MAINSPEF,
PROCODE3, PROCODE5, PROCODET, SITETRET
    FROM hdis_10years.hes_apc_2526_hdis_10years
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
    -- West Sussex resident
    AND RESCTY_ONS = 'E10000032'
    -- Pelvic Inflammatory Disease ICD codes (N70 - N74) in any diagnosis field
    AND DIAG_3_CONCAT RLIKE ('N7[0-4]')