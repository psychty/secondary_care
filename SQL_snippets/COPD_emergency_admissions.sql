    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1314_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1415_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1516_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1617_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1718_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1819_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')



    -- Second query
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_1920_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_2021_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_2122_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_2223_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')
UNION
    SELECT FYEAR, EPIKEY, PERSON_ID_DEID, ADMIDATE, ADMIMETH, ADMINCAT, ADMISORC, CAUSE_3, CAUSE_4, CLASSPAT, DIAG_3_CONCAT, DIAG_3_01, DIAG_4_CONCAT, DIAG_4_01, DIAG_COUNT, OPERTN_3_CONCAT, OPERTN_3_01, OPERTN_4_CONCAT, OPERTN_4_01, DISDATE, DISDEST, DISMETH, ELECDATE, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS, FAE, FCE, FDE, GPPRAC, RESLADST_ONS, SEX, SPELBGIN, SPELDUR, SPELDUR_CALC, SPELEND, STARTAGE, STARTAGE_CALC, TRETSPEF, LSOA11 AS LSOA11CD, SITEDIST, SITETRET, PROCODE3, PROCODE5
    FROM hdis_10years.hes_apc_2324_hdis_10years
    -- Finished admission episode
    WHERE FAE = 1
    -- Emergency admissions
    AND ADMIMETH RLIKE ('^2')
    -- Finished episodes (3)
    AND EPISTAT = '3'
    -- Ordinary admission (1), day case (2) or maternity (5)
    AND CLASSPAT IN ('1','2','5')
    -- First episode of a spell
    AND EPIORDER = 1
    -- Among those aged 35+ at the start of the admission
    AND STARTAGE_CALC >= 35
    -- and a primary diagnosis code (DIAG_3_01)
    AND DIAG_4_01 RLIKE ('J4[01234]')