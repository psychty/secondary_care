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

disclosure_control(0)
disclosure_control(14)
disclosure_control(4)

library(tidyverse)

dummy_df <- data.frame(count = sample(0:56, 100, replace = TRUE)) %>% 
  mutate(final_value = disclosure_control(count))
