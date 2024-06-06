    SELECT *
    FROM hdis_10years.hes_apc_1314_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION  
    SELECT *
    FROM hdis_10years.hes_apc_1415_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_1516_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_1617_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_1718_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_1819_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_1920_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_2021_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_2122_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )
UNION
    SELECT *
    FROM hdis_10years.hes_apc_2223_hdis_10years
    WHERE FAE = 1
    AND PERSON_ID_DEID IN (
        SELECT PERSON_ID_DEID
        FROM global_temp.arbd_1314_2223_wsx_cohort
    )