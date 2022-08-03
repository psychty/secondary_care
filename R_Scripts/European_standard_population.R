
# This script will explain the 2013 European Standard Population and methods of using R to apply directly and indirectly standardised population rates.

packages <- c('easypackages', 'tidyverse','readxl', 'readr')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

options(scipen=999)

# https://epirhandbook.com/en/standardised-rates.html  is a useful resource for understanding standardisation

# Fromt he Epi Handbook -

# There are two main ways to standardize: direct and indirect standardization. Let’s say we would like to the standardize mortality rate by age and sex for country A and country B, and compare the standardized rates between these countries.

# For direct standardization, you will have to know the number of the at-risk population and the number of deaths for each stratum of age and sex, for country A and country B. One stratum in our example could be females between ages 15-44.

# For indirect standardization, you only need to know the total number of deaths and the age- and sex structure of each country. This option is therefore feasible if age- and sex-specific mortality rates or population numbers are not available. Indirect standardization is furthermore preferable in case of small numbers per stratum, as estimates in direct standardization would be influenced by substantial sampling variation.

# Age-standardised rates are standardised to the European Standard Population (ESP), a hypothetical population assuming the age structure is the same in both sexes, therefore allowing comparisons to be made between the sexes as well as between areas.

# standard tables ####

# Age Group (years)	Standard Population

esp_2013_21_cat <- data.frame(Age_group = c('0 years', '1-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90-94 years', '95 and over'), Standard_population = c(1000, 4000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 1500, 800, 200), stringsAsFactors = TRUE)

esp_2013_20_cat_90_plus <- data.frame(Age_group = c('0 years', '1-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90 and over'), Standard_population = c(1000, 4000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 1500, 1000), stringsAsFactors = TRUE)

esp_2013_19_cat_0_4_90_plus <- data.frame(Age_group = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90 and over'), Standard_population = c(5000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 1500, 1000), stringsAsFactors = TRUE)

# You need to end up with a dataframe of one row per area, sex, and age with a numerator and denominator

dummy_df <- esp_2013_21_cat %>% 
  mutate(sex = 'male',
         numerator = sample(35:1500, nrow(.), replace = TRUE),
         denominator = sample(12000:90000, nrow(.), replace = TRUE)) %>% 
  mutate(Age_specific_rate = numerator / denominator * 100000) %>% 
  mutate(Age_standardised_rate = Age_specific_rate * Standard_population)

totals_rate <- dummy_df %>% 
  summarise(Standard_population = sum(Standard_population, na.rm = TRUE),
            numerator = sum(numerator, na.rm = TRUE),
            denominator = sum(denominator, na.rm = TRUE),
            Age_standardised_rate = sum(Age_standardised_rate, na.rm = TRUE)) %>% 
  mutate(Age_standardised_rate = Age_standardised_rate / Standard_population) %>% 
  mutate(Lower_CI = Age_standardised_rate - (1.96*(Age_standardised_rate / sqrt(numerator))),
         Upper_CI = Age_standardised_rate + (1.96*(Age_standardised_rate / sqrt(numerator))))

