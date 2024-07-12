    SELECT COUNT 
    FROM hdis_10years.hes_apc_1314_hdis_10years
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
    --  the region of residence is one of the English regions, no fixed abode or unknown [resgor<= K or U or Y]
    AND RESGOR_ONS RLIKE ('E|U|Y')