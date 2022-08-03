
# Ambulatory Care Sensitive Conditions ####

packages <- c('easypackages', 'tidyverse','readxl', 'readr')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# This indicator measures how many people with specific long-term conditions, which should not normally require hospitalisation, are admitted to hospital in an emergency. These conditions include, for example, diabetes, epilepsy and high blood pressure

# This outcome is concerned with how successfully the NHS manages to reduce emergency admissions for all long-term conditions where optimum management can be achieved in the community.

# The coronavirus (COVID-19) pandemic began to have an impact on Hospital Episode Statistics (HES) data late in the 2019/20 financial year, which continued into the 2020/21 financial year. This means we are seeing different patterns in the submitted data, for example, fewer patients being admitted to hospital, and therefore statistics which contain data from this period should be interpreted with care.

# https://digital.nhs.uk/data-and-information/publications/statistical/nhs-outcomes-framework/march-2022/domain-2---enhancing-quality-of-life-for-people-with-long-term-conditions-nof/2.3.i-unplanned-hospitalisation-for-chronic-ambulatory-care-sensitive-conditions 

# ambulatory_care <- read_csv('https://files.digital.nhs.uk/53/C9C77B/NHSOF_2.3.i_I00708_D.csv')

# This indicator measures the rate of emergency hospital admissions per 100,000 population for patients with long-term ambulatory care sensitive conditions. The numerator is given by the number of finished and unfinished admission episodes, excluding transfers, for patients of all ages with an emergency method of admission and with a primary diagnosis of an ACS condition as detailed below. A data period of three months is used to produce each of the quarterly outputs. The rate is indirectly age and gender standardised to the reference year 2012/13.

# We follow the specification of the NHS Outcomes Framework indicator 2.3 unplanned hospitalisation for chronic ambulatory care sensitive conditions

# The indirectly standardised rate, per 100,000 population, of emergency admissions for chronic ambulatory care sensitive conditions in the respective financial year or quarter of the financial year for people of all ages.

# The numerator is given by the number of finished and unfinished admission episodes, excluding transfers, for patients of all ages with an emergency method of admission and with a primary diagnosis of an ACS condition A data period of three months is used to produce each of the quarterly outputs. The rate is indirectly age and gender standardised to the reference year 2012/13.

# https://files.digital.nhs.uk/8F/335AC1/NHSOF_Domain_2_S.pdf

