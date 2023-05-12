SELECT COUNT PERSON_ID_DEID
FROM hdis_10years.hes_apc_2021_hdis_10years
-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Emergency admissions
AND ADMIMETH LIKE ('2%')
-- First episode of a spell
AND EPIORDER = 1
-- Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229', 'E06000043', 'E07000061', 'E07000062', 'E07000063', 'E07000064', 'E07000065')
-- Conditions any episode with a fall cause code (W00 - W19)
AND DIAG_3_CONCAT RLIKE ('W[01]')
-- Start age 65+
AND STARTAGE_CALC > 65