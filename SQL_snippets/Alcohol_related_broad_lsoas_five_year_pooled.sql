
/* Admissions to hospital where the primary diagnosis or any of the secondary diagnoses are an alcohol-specific (wholly attributable) condition. Directly age standardised rate per 100,000 population (standardised to the European standard population). */

/* More specifically, hospital admissions records are identified where the admission is a finished episode [epistat = 3]; the admission is an ordinary admission, day case or maternity [classpat = 1, 2 or 5]; it is an admission episode [epiorder = 1]; the sex of the patient is valid [sex = 1 or 2]; there is a valid age at start of episode [startage between 0 and 150 or between 7001 and 7007]; the region of residence is one of the English regions, no fixed abode or unknown [resgor<= K or U or Y]; the episode end date [epiend] falls within the financial year, and an alcohol-attributable ICD10 code (whole or partly attributable) appears in the primary diagnosis field [diag_01] or an alcohol-related external cause code appears in any diagnosis field [diag_nn].

For each episode identified, an alcohol-attributable fraction is applied to the primary diagnosis field or an alcohol-attributable external cause code appears in one of the secondary codes based on the diagnostic codes, age group, and sex of the patient.  Where there is more than one alcohol-related ICD10 code among the 20 possible diagnostic codes the codes with the largest alcohol attributable fraction is selected; in the event of there being two or more codes with the same alcohol-attributable fraction within the same episode, the one from the lowest diagnostic position is selected. For a detailed list of all alcohol attributable diseases, including ICD 10 codes and relative risks see  ‘Alcohol-attributable fractions for England: an update’ (4).*/

SELECT FYEAR, PSEUDO_HESID, ADMIDATE, DIAG_3_CONCAT, DIAG_3_01, DIAG_3_02,   DIAG_3_03, DIAG_3_04, DIAG_3_05, DIAG_3_06, DIAG_3_07, DIAG_3_08, DIAG_3_09, DIAG_3_10, DIAG_3_11, DIAG_3_12, DIAG_3_13, DIAG_3_14, DIAG_3_15, DIAG_3_16, DIAG_3_17, DIAG_3_18, DIAG_3_19, DIAG_3_20, DIAG_4_CONCAT, DIAG_4_01, DIAG_4_02, DIAG_4_03, DIAG_4_04, DIAG_4_05, DIAG_4_06, DIAG_4_07, DIAG_4_08, DIAG_4_09, DIAG_4_10, DIAG_4_11, DIAG_4_12, DIAG_4_13, DIAG_4_14, DIAG_4_15, DIAG_4_16, DIAG_4_17, DIAG_4_18, DIAG_4_19, DIAG_4_20, DIAG_COUNT, EPIDUR, EPIEND, EPIORDER, EPISTART, EPISTAT, EPITYPE, ETHNOS AS ETHNICITY, FAE, FCE, FDE, RESLADST_ONS, SEX, LSOA11, MSOA11, GPPRAC, ALCDIAG_4, ALCFRAC, ALCNRWFRAC, ALCNRWDIAG, ALCBRDFRAC, ALCBRDDIAG
FROM hes.hes_apc_1617

-- Finished episodes (3)
WHERE EPISTAT = '3'
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Any valid age
AND STARTAGE_CALC IS NOT NULL

-- To match England totals
-- AND RESGOR_ONS NOT IN ('L99999999', 'M99999999', 'N99999999', 'S99999999', 'W99999999', 'X')
-- West Sussex LTLAs
AND RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E07000228', 'E07000229')
-- Episode end date in year
AND EPIEND >= '2016-04-01' AND EPIEND <= '2021-03-31'

-- Conditions

-- - Wholly attributable
-- Mental and behavioural disorders due to the use of alcohol
AND (DIAG_3_CONCAT RLIKE ('F10')
-- Alcoholic liver disease
OR DIAG_3_CONCAT RLIKE ('K70')
-- Toxic effect of alcohol (selected conditioncodes)
OR DIAG_4_CONCAT RLIKE ('T51[019]') 
-- Other wholly attributable conditions
OR DIAG_4_CONCAT RLIKE ('E244|G312|G621|G721|I426|K292|K852|K860|Q860|R780')
OR DIAG_3_CONCAT RLIKE ('X45|X65|Y15|Y90|Y91'))