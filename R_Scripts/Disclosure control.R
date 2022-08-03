# Disclosure control
# 
# The HES Analysis Guide on suppression of small numbers required values based 
# on counts between 1 and 7 to be suppressed. All other values in the ‘Observed’ column are rounded to the nearest 5. 
# 
# Secondary suppression is not necessary using this method. 
# create a function to handle this:

# FIXME this function needs to accept multiple arguments and return multiple values

disclosure_control <- function(x){
  if(x == 0)
    return(0)
  if(x <= 7)
    return('1-7*')
  else  return(round(x/5)*5)
}

# This is probably simpler 
# disclosure_control <- function(x){
#   if(x > 0 && x <= 7)
#     return('1-7*')
#   else return(round(x/5)*5)
# }

disclosure_control(0)
disclosure_control(14)
disclosure_control(4)

alt_disclosure_control <- function(x){
  return(dplyr::case_when(
    x == 0 ~ '0',
    x <= 7 ~ '1-7*',
    TRUE ~ as.character(5*round(x/5))
  ))
}

alt_disclosure_control(0)
alt_disclosure_control(14)
alt_disclosure_control(4)

nums <- c(0,14,4)
alt_disclosure_control(nums)

# TODO: alt_disclosure_control returns all values as chars, which might be unhelpful for the rounded values.
# One solution might be to set -1 as a value representing '1-7*' but then any logic that sums up values would have to bear this in mind later.

disclosure_control(x = c(0,2, 19, 10))

library(tidyverse)

dummy_df <- data.frame(count = sample(0:56, 100, replace = TRUE)) %>% 
  mutate(final_value = disclosure_control(count))
