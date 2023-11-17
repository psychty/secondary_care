-- Admissions to hospital where the primary diagnosis or any of the secondary diagnoses are an alcohol-specific (wholly attributable) condition. Directly age standardised rate per 100,000 population (standardised to the European standard population

-- I cannot match the figures on fingertips with this one
SELECT FYEAR AS Financial_year, SUM(FAE) AS Admission_episodes
FROM hdis_10years.hes_apc_2122_hdis_10years
-- Finished episodes only (3)
WHERE EPISTAT = '3'
-- Admission episode
AND FAE = 1
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- Admission end in year
AND EPIEND 
-- First episode of a spell
AND EPIORDER = 1
-- Sex male or female
AND SEX IN ('1','2')
-- Valid start age
AND ((STARTAGE >= 0 AND STARTAGE <= 150) OR (STARTAGE >= 7001 AND STARTAGE <= 7007))
AND (DIAG_3_CONCAT RLIKE ('F10')
-- Alcoholic liver disease
OR DIAG_3_CONCAT RLIKE ('K70')
-- Toxic effect of alcohol (selected conditioncodes)
OR DIAG_4_CONCAT RLIKE ('T51[019]') 
-- Other wholly attributable conditions
OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))
AND RESGOR_ONS RLIKE ('E|U|Y')