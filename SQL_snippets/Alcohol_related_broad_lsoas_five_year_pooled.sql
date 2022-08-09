
/* Admissions to hospital where the primary diagnosis or any of the secondary diagnoses are an alcohol-specific (wholly attributable) condition. Directly age standardised rate per 100,000 population (standardised to the European standard population). */

/* More specifically, hospital admissions records are identified where the admission is a finished episode [epistat = 3]; the admission is an ordinary admission, day case or maternity [classpat = 1, 2 or 5]; it is an admission episode [epiorder = 1]; the sex of the patient is valid [sex = 1 or 2]; there is a valid age at start of episode [startage between 0 and 150 or between 7001 and 7007]; the region of residence is one of the English regions, no fixed abode or unknown [resgor<= K or U or Y]; the episode end date [epiend] falls within the financial year, and an alcohol-attributable ICD10 code (whole or partly attributable) appears in the primary diagnosis field [diag_01] or an alcohol-related external cause code appears in any diagnosis field [diag_nn].

For each episode identified, an alcohol-attributable fraction is applied to the primary diagnosis field or an alcohol-attributable external cause code appears in one of the secondary codes based on the diagnostic codes, age group, and sex of the patient.  Where there is more than one alcohol-related ICD10 code among the 20 possible diagnostic codes the codes with the largest alcohol attributable fraction is selected; in the event of there being two or more codes with the same alcohol-attributable fraction within the same episode, the one from the lowest diagnostic position is selected. For a detailed list of all alcohol attributable diseases, including ICD 10 codes and relative risks see  ‘Alcohol-attributable fractions for England: an update’ (4).*/

-- we might want to include the ALC

WHERE 

-- Finished episodes (3)
AND EPISTAT = 3
-- Ordinary admission (1), day case (2) or maternity (5)
AND CLASSPAT IN ('1','2','5')
-- First episode of a spell
AND EPIORDER = 1
-- Males (1) or Females (2) (exclude unknown)
AND SEX IN ('1','2')
-- Any age
AND STARTAGE IS NOT NULL

-- West Sussex LTLAs
WHERE RESLADST_ONS IN ('E07000223','E07000224','E07000225','E07000226','E07000227','E0700022', 'E07000229')

-- Episode end date in year
-- The indicator also splits this by quarter
AND EPIEND >= '2020-04-01' AND EPIEND <= '2021-03-31'