    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1314_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and under 25 years valid starting age
     AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION  
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1415_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1516_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1617_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1718_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1819_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_1920_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST  
    FROM hdis_10years.hes_apc_2021_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_2122_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST  
    FROM hdis_10years.hes_apc_2223_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE,	ADMIMETH, ADMINCAT,	ADMISORC, CAUSE_3, CAUSE_4,	CLASSPAT, DIAG_3_01, DIAG_3_02,	DIAG_3_03,	DIAG_3_04,	DIAG_3_05,	DIAG_3_06,	DIAG_3_07,	DIAG_3_08,	DIAG_3_09,	DIAG_3_10,	DIAG_3_11,	DIAG_3_12,	DIAG_3_13,	DIAG_3_14,	DIAG_3_15,	DIAG_3_16,	DIAG_3_17,	DIAG_3_18,	DIAG_3_19,	DIAG_3_20,	DIAG_3_CONCAT,	DIAG_4_01,	DIAG_4_02,	DIAG_4_03,	DIAG_4_04,	DIAG_4_05,	DIAG_4_06,	DIAG_4_07,	DIAG_4_08,	DIAG_4_09,	DIAG_4_10,	DIAG_4_11,	DIAG_4_12,	DIAG_4_13,	DIAG_4_14,	DIAG_4_15,	DIAG_4_16,	DIAG_4_17,	DIAG_4_18,	DIAG_4_19,	DIAG_4_20,	DIAG_4_CONCAT,	DIAG_COUNT,	DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE,	FCE, FDE, GPPRAC, RESLADST_ONS,	SEX, SPELBGIN, SPELDUR,	SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11, MSOA11, SITEDIST
    FROM hdis_10years.hes_apc_2324_hdis_10years
    -- Finished episodes only (3)
    WHERE EPISTAT = '3'
    -- Ordinary admissions (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = '1'
    -- and a valid starting age
    AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE > 7001 AND STARTAGE <= 7007))
    -- West Sussex LTLA
    AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
    -- Alcohol specific conditions in any diagnosis field
    -- Mental and behavioural disorders due to use of alcohol
    AND (DIAG_3_CONCAT RLIKE ('F10')
    -- Alcoholic liver disease
    OR DIAG_3_CONCAT RLIKE ('K70')
    -- Toxic effect of alcohol (selected conditioncodes)
    OR DIAG_4_CONCAT RLIKE ('T51[019]') 
    -- Other wholly attributable conditions
    OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
    OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))