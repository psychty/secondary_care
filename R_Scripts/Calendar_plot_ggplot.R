
########################
## Author: Rich Tyler ##
########################

# library(plyr); library(dplyr); library(tidyverse); library(reshape2); library(ggplot2); library(grid); library(gridExtra); library(knitr); library(kableExtra); library(tidyr); library(rowr); library(readxl); library(readr)

# Loading some packages 
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'showtext')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

# Custom fonts ####

# I want a calendar theme which includes Poppins as a custom font (it is not ordinarily available to R or on windows by default). If you have custom fonts installed (which not everyone will have) then uncomment out this next section, load showtext package and use font_add() to specify a filepath to your font.

# If you do not have the font (or any other font can be exchanged) then skip this next. If you do have a custom font 

# showtext_auto(TRUE)

# Load up Poppins font
# font_add(family = "poppins", regular = "C:/Users/asus/AppData/Local/Microsoft/Windows/Fonts/Poppins-Regular.ttf")
# font_add(family = "poppinsb", regular = "C:/Users/asus/AppData/Local/Microsoft/Windows/Fonts/Poppins-Bold.ttf")

# ph_cal_theme = function(){
#   theme( 
#     text = element_text(size = 11, family = 'poppins'),
#     plot.title = element_text(colour = "#000000", face = "bold", size = 12, vjust = 1, family = 'poppinsb'),
#     plot.background = element_rect(fill = "white", colour = "#E2E2E3"), 
#     panel.background = element_rect(fill = "white"), 
#     legend.position = "bottom", 
#     axis.ticks = element_blank(), 
#     axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.25),
#     axis.text.y = element_blank(),
#     axis.title = element_text(colour = "#327d9c", family = "poppinsb"),     
#     strip.text = element_text(colour = "#000000", family = "poppinsb"),
#     strip.background = element_rect(fill = "#ffffff"), 
#     panel.grid.major = element_blank(),
#     panel.grid.minor = element_blank())}

# This is the calendar theme I have created which uses base fonts
ph_cal_theme = function(){
  theme( 
    text = element_text(size = 11),
    plot.title = element_text(colour = "#000000", face = "bold", size = 12, vjust = 1),
    plot.background = element_rect(fill = "white", colour = "#E2E2E3"), 
    panel.background = element_rect(fill = "white"), 
    legend.position = "bottom", 
    axis.ticks = element_blank(), 
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.25),
    axis.text.y = element_blank(),
    axis.title = element_text(colour = "#327d9c"),     
    strip.text = element_text(colour = "#000000", face = 'bold'),
    strip.background = element_rect(fill = "#ffffff"), 
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank())}

# Data ####

df <- data.frame(id = as.character(1:8000)) %>% 
  mutate(Date = sample(seq(as.Date('2018-04-01', format = "%Y-%m-%d"), as.Date('2022-03-31', format="%Y-%m-%d"), by="day"), nrow(.), replace = TRUE))

# Create a table of the number of counts per day that incorporates dates where there were none.

df_table <- df %>% 
  group_by(Date) %>% 
  summarise(Count = n())

all_dates <- data.frame(Date = seq.Date(as.Date('2018-04-01', format = "%Y-%m-%d"), as.Date('2022-03-31', format="%Y-%m-%d"), by="day")) %>% 
  left_join(df_table, by = 'Date') %>% 
  mutate(Count = replace_na(Count, 0)) %>% 
  mutate(Year = format(Date, '%Y')) %>% 
  mutate(Month_n = format(Date, '%m')) %>% 
  mutate(Month_name = format(Date, '%b')) %>% 
  mutate(Weekday = ifelse(format(Date, '%w') == 0, 7, format(Date, '%w'))) %>% 
  mutate(Weekday_name = format(Date, '%a')) %>% 
  mutate(Month_year = format(Date, '%m-%Y'))

# Create a dataframe of every month between the start and end of the data

# If you have the first of the starting month in the dataset (as I added above) there is no need to execute the next few rows, if not (in our case it would have started on the 2/11/2013) then it will create a dataframe with the 2nd of each month as the date monthy and then yo have to retrospectively make the date the 1st

months_in_between <- data.frame(Date = seq.Date(from = min(all_dates$Date), to = max(all_dates$Date), by = "months"))

# This asks if the first day of the month for the first observation is '01'. If it is then it will skip over the next three lines, if it is not then it will create a new field that concatenates the month-year of the date with 01 at the start, and then overwrites the date field with the dates starting on the 1st of the month. The third line removes the created field.

if (!(format(months_in_between$Date, "%d")[1] == "01")){
  months_in_between$Date_1 <- paste("01", format(months_in_between$Date, "%m-%Y"), sep = "-")
  months_in_between$Date <-as.Date(months_in_between$Date_1, format="%d-%m-%Y")
  months_in_between$Date_1 <- NULL
}  

# Day of the week (name and then number)
months_in_between <- months_in_between %>% 
  mutate(dw = format(Date, "%A"),
         dw_n = ifelse(format(Date, "%w") == 0, 7, format(Date, '%w'))) %>% # For some reason R thinks the week should start on Sunday (terrible idea), so we need to turn the 0 to 7 so that it is seen as the last day.
  mutate(Month_year = format(Date, "%m-%Y"))

# To make the calendar plot we are going to need to create a grid of 42 tiles (representing seven days in each week for six weeks, as any outlook calendar shows). From this we can start the data somewhere between tile one and tile seven depending on the day of the week the month starts (e.g. if the month starts on a wednesday, then we want the data to start on tile three).

# Make an empty dataframe with each month of the 'months_in_between' dataframe repeated 42 times
df_1 <- data.frame(Month_year = rep(months_in_between$Month_year, 42)) %>% 
  group_by(Month_year) %>% 
  mutate(id = 1:n()) # For each month, add a field with the sequence one to 42 (or the number of times the month has been repeated)

# Add the information we created about the day each month starts
final_df <- all_dates %>% 
  left_join(months_in_between[c("Month_year", "dw_n")], by = "Month_year") %>% 
  mutate(dw_n = as.numeric(dw_n)) %>% # When we created the values for day of the week with the format() function, the values returned were all characters. Make sure R reads the number of the starting day as a number and not a character
  group_by(Month_year) %>% 
  mutate(id = 1:n()) %>% # We need to create an id number to show the order of dates within a month
  mutate(id = id + dw_n - 1) %>% # If we add this id number to the dw (day of the week that the month starts) number, the id number becomes the position in our grid of 42 that the date should be. 
  # As we can only start a sequence from 1 onwards, and not zero, we need to subtract one from the total otherwise the position is offset too far.
  mutate(Week = ifelse(id <= 7, 1, ifelse(id <= 14, 2, ifelse(id <= 21, 3, ifelse(id <= 28, 4, ifelse(id <= 35, 5, 6)))))) # We can now overwrite the Week field in our dataframe to show what it should be given the grid of 42 days

# Rebuilding ####

# Join visits_date with the numbers 1-42 for each month and rebuild the artificially created grid with the year, month, and weekday information
final_df_1 <- left_join(df_1, final_df, by = c("Month_year", "id")) %>% 
  mutate(Year = substr(Month_year, 4, 7)) %>%  # take the four to seventh characters from the Month_year field to create the year
  mutate(Month_n = substr(Month_year, 1,2)) %>% # take the first and second characters from the Month_year field to create the month number
  mutate(Weekday_name = ifelse(id %in% c(1,8,15,22,29,36) & is.na(Date), "Mon", 
                               ifelse(id %in% c(2,9,16,23,30,37) & is.na(Date), "Tue", 
                                      ifelse(id %in% c(3,10,17,24,31,38) & is.na(Date), "Wed", 
                                             ifelse(id %in% c(4,11,18,25,32,39) & is.na(Date), "Thu",
                                                    ifelse(id %in% c(5,12,19,26,33,40) & is.na(Date), "Fri", 
                                                           ifelse(id %in% c(6,13,20,27,34,41) & is.na(Date), "Sat", 
                                                                  ifelse(id %in% c(7,14,21,28,35,42) & is.na(Date), "Sun", 
                                                                         Weekday_name)))))))) %>% # look through the dataframe and where the date is missing (indicating a non-date filler value within our 42 grid) and the id value is 1,8,15,22,29, or 36 (i.e. the monday value in our 42 grid for the month) then add a "Mon" for the day of the week and so on.
  mutate(Weekday = ifelse(id %in% c(1,8,15,22,29,36) & is.na(Date), 1,
                          ifelse(id %in% c(2,9,16,23,30,37) & is.na(Date), 2, 
                                 ifelse(id %in% c(3,10,17,24,31,38) & is.na(Date), 3,
                                        ifelse(id %in% c(4,11,18,25,32,39) & is.na(Date), 4,
                                               ifelse(id %in% c(5,12,19,26,33,40) & is.na(Date), 5,
                                                      ifelse(id %in% c(6,13,20,27,34,41) & is.na(Date), 6,
                                                             ifelse(id %in% c(7,14,21,28,35,42) & is.na(Date), 7, 
                                                                    Weekday )))))))) %>% # Similar to above but numbers not days
  mutate(Week = factor(ifelse(id <= 7,  1,
                              ifelse(id <= 14, 2,  
                                     ifelse(id <= 21, 3,
                                            ifelse(id <= 28, 4,
                                                   ifelse(id <= 35, 5,
                                                          ifelse(id <= 42, 6, 
                                                                 NA)))))), levels = c(6,5,4,3,2,1))) %>% # Add a calendar week value for faceting (1-6 from our 42 tile grid). # This is not the same as the week of the month and we save the levels of this field so R knows how to plot them.
  mutate(Month_name = factor(ifelse(Month_n == "01", "Jan",
                                    ifelse(Month_n == "02", "Feb",
                                           ifelse(Month_n == "03", "Mar",
                                                  ifelse(Month_n == "04", "Apr",
                                                         ifelse(Month_n == "05", "May",
                                                                ifelse(Month_n == "06", "Jun",
                                                                       ifelse(Month_n == "07", "Jul",
                                                                              ifelse(Month_n == "08", "Aug",
                                                                                     ifelse(Month_n == "09", "Sep",
                                                                                            ifelse(Month_n == "10", "Oct",
                                                                                                   ifelse(Month_n == "11", "Nov", 
                                                                                                          ifelse(Month_n == "12", "Dec", 
                                                                                                                 NA)))))))))))), levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))) %>% # Fill in the blanks of month name using the value in Month_n
  mutate(Weekday_name = factor(ifelse(Weekday_name == "Mon", "Monday",
                                      ifelse(Weekday_name == "Tue", "Tuesday",
                                             ifelse(Weekday_name == "Wed", "Wednesday",
                                                    ifelse(Weekday_name == "Thu", "Thursday", 
                                                           ifelse(Weekday_name == "Fri", "Friday",
                                                                  ifelse(Weekday_name == "Sat", "Saturday",
                                                                         ifelse(Weekday_name == "Sun", "Sunday", 
                                                                                Weekday_name))))))), levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))) %>% # Use the full weekday name
  select(!dw_n) %>% 
  mutate(Bins = factor(ifelse(is.na(Date), "non date",
                              ifelse(is.na(Count), 'data missing',
                                     ifelse(Count == 0, "none",
                                            ifelse(Count <= 4, "1-4", 
                                                   ifelse(Count <= 9, "5-9",
                                                          ifelse(Count <= 19, "10-19",
                                                                 ifelse(Count <= 29, "20-29", 
                                                                        ifelse(Count > 30, "30+",
                                                                               NA)))))))), levels = c("none","1-4", "5-9", "10-19", "20-29", "30+", "data missing", "non date")))

# This is the plot, faceted on Year and Month, I have supressed the axis titles and labels.

# I have also ommitted the 'non_date' value from the breaks = in the scale_fill_manual() line so that it does not show up in the legend. It will still be coloured appropriately on the plot

## This used to work, but now if I specify breaks that exclude the values then they are given unhelpful defaults. 

bin_colours <- c('#feebe2','#fcc5c0','#fa9fb5','#f768a1','#c51b8a','#7a0177', "#8e8e8e", "#f9f9f9")

final_df_1 %>% 
  ggplot() +
  geom_tile(aes(x = Weekday_name, 
                y = Week, 
                fill = Bins),
            colour = "#ffffff") + 
  facet_grid(Year ~ Month_name) +
  scale_x_discrete(expand = c(0,0.1)) +
  scale_fill_manual(values = bin_colours,
                    drop = FALSE,
                    breaks = c('none','1-4','5-9','10-19','20-29','30+'),
                    name = "Count per day",
                    na.value = '#f9f9f9') +
  labs(title = 'Count by day;',
       subtitle = 'West Sussex; 1st April 2018 - 31st March 2022',
       x = '', 
       y = '') +
  ph_cal_theme() +
  guides(fill = guide_legend(nrow = 1, 
                             byrow = TRUE))

