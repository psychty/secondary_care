
# Falls ####
packages <- c('easypackages', 'tidyr', 'ggplot2', 'dplyr', 'scales', 'readxl', 'readr', 'purrr', 'stringr', 'rgdal', 'spdplyr', 'geojsonio', 'rmapshaper', 'jsonlite', 'rgeos', 'sp', 'sf', 'maptools', 'leaflet', 'leaflet.extras', 'lubridate', 'openxlsx', 'fingertipsR', 'zoo', 'lemon')
install.packages(setdiff(packages, rownames(installed.packages())))
easypackages::libraries(packages)

local_store <- 'https://raw.githubusercontent.com/psychty/secondary_care/main/Data_store'

output_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/R/Falls'

# LSOA population
IMD_2019 <- read_csv('https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/845345/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv') %>% 
  select(LSOA11CD = `LSOA code (2011)`,  LTLA = `Local Authority District name (2019)`, IMD_Score = `Index of Multiple Deprivation (IMD) Score`, IMD_Decile = "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOAs)") %>% 
  filter(LTLA %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'))

lsoa_mye <- read_csv(paste0(local_store, '/lsoa_mye_1120.csv')) 

wsx_mye <- lsoa_mye %>% 
  group_by(Sex, Age_group) %>% 
  summarise(`2016_20` = sum(`2016_20`, na.rm = TRUE))

# Disclosure control function
source('https://raw.githubusercontent.com/psychty/secondary_care/main/R_Scripts/Disclosure%20control.R')

# Create a dataset for the European Standard Population
esp_2013_21_cat <- data.frame(Age_group = c('0 years', '1-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85-89 years', '90-94 years', '95 and over'), Standard_population = c(1000, 4000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 1500, 800, 200), stringsAsFactors = TRUE)

esp_2013_19_cat <- data.frame(Age_group = c('0-4 years', '5-9 years', '10-14 years', '15-19 years', '20-24 years', '25-29 years', '30-34 years', '35-39 years', '40-44 years', '45-49 years', '50-54 years', '55-59 years', '60-64 years', '65-69 years', '70-74 years', '75-79 years', '80-84 years', '85+ years'), Standard_population = c(5000, 5500, 5500, 5500, 6000, 6000, 6500, 7000, 7000, 7000, 7000, 6500, 6000, 5500, 5000, 4000, 2500, 2500), stringsAsFactors = TRUE)

# Data dictionary
HES_data_dictionary <- read_csv(paste0(local_store, "/HES_field_metadata.csv"))

sussex_areas <- c('Brighton and Hove', 'Eastbourne', 'Hastings', 'Lewes', 'Rother', 'Wealden', 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing', 'East Sussex', 'West Sussex', 'South East region', 'England')

sussex_ltlas <- c('Brighton and Hove', 'Eastbourne', 'Hastings', 'Lewes', 'Rother', 'Wealden', 'Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing')

# Fingertips indicator: Emergency admissions for falls injuries classified by primary diagnosis code (ICD10 code S00 - T98), and external cause (W00 - W19) and an emergency admission code - Age at admission 65+.

# PHE method describes - emergency first finished consultant episodes (episode number = 1 and admission method starts with 2.

falls_ohid <- fingertips_data(IndicatorID = 22401,
                             AreaTypeID = 'All',
                             categorytype = FALSE) %>% 
  filter(AreaName %in% sussex_areas,
         Sex == 'Persons') %>% 
  select(IndicatorID, Indicator = IndicatorName, Area_code = AreaCode, Area_name = AreaName, Sex, Age, Year = Timeperiod, Numerator = Count, Denominator, Rate = Value, Lower_CI = LowerCI95.0limit, Upper_CI = UpperCI95.0limit, TimeperiodSortable) %>% 
  unique()

falls_ohid %>% 
  filter(Area_name %in% c('Brighton and Hove', 'East Sussex', 'West Sussex')) %>% 
  filter(TimeperiodSortable == max(TimeperiodSortable))

# Primary Diagnosis Injury with a cause of Fall.

falls_codes <- data.frame(ICD_code = c("W00","W01","W02","W03","W04","W05","W06","W07","W08","W09","W10","W11","W12","W13","W14","W15","W16","W17","W18","W19"), 
                          definition = c("Fall on same level involving ice and snow", "Fall on same level from slipping, tripping and stumbling", "Fall involving ice-skates, skis, roller-skates or skateboards", "Other fall on same level due to collision with, or pushing by, another person", "Fall while being carried or supported by other persons", "Fall involving wheelchair", "Fall involving bed", "Fall involving chair", "Fall involving other furniture", "Fall involving playground equipment", "Fall on and from stairs and steps", "Fall on and from ladder", "Fall on and from scaffolding", "Fall from, out of or through building or structure", "Fall from tree", "Fall from cliff", "Diving or jumping into water causing injury other than drowning or submersion", "Other fall from one level to another", "Other fall on same level", "Unspecified fall"))

# Inpatient hospital admissions are a proportion of falls incidents, more may present to A&E and GPs, not all of which will lead to hospital admission.

# This indicator only counts falls that have been coded in the cause field and Injuries in primary diagnosis field. It has been observed that there are situations where falls (ICD10 W00-W19) and Injuries (S00-T98) are coded in secondary diagnosis fields. This may result in underestimation of falls resulting in injuries.

# HES extract

# Lookups
area_lookup <- falls_ohid %>% 
  select(Area_code, Area_name) %>% 
  unique() %>% 
  mutate(UTLA =  ifelse(Area_name %in% c('Eastbourne', 'Hastings', 'Lewes', 'Rother', 'Wealden'), 'East Sussex', ifelse(Area_name %in% c('Adur', 'Arun', 'Chichester', 'Crawley', 'Horsham', 'Mid Sussex', 'Worthing'), 'West Sussex', Area_name)))

# Load data ####
HDIS_directory <- '//chi_nas_prod2.corporate.westsussex.gov.uk/groups2.bu/Public Health Directorate/PH Research Unit/HDIS/Extracts_Rich_Tyler/'

list.files(HDIS_directory)

df_raw <- list.files(HDIS_directory)[grepl("Sussex_emergency_admission_episodes_falls_1112_2122", list.files(HDIS_directory)) == TRUE] %>%  map_df(~read_csv(paste0(HDIS_directory,.))) %>% 
  mutate(SEX = ifelse(SEX == 1, 'Male', ifelse(SEX == 2, 'Female', NA))) %>% 
  mutate(ETHNICITY = ifelse(ETHNICITY == 'A', 'White British', ifelse(ETHNICITY == 'B', 'White Irish', ifelse(ETHNICITY == 'C', 'Any other White background', ifelse(ETHNICITY == 'D', 'Mixed - White and Black Caribbean', ifelse(ETHNICITY == 'E', 'Mixed - White and Black African', ifelse(ETHNICITY == 'F', 'Mixed - White and Asian', ifelse(ETHNICITY == 'G' , 'Mixed - Any other Mixed background', ifelse(ETHNICITY == 'H', 'Asian or Asian British - Indian', ifelse(ETHNICITY == 'J', 'Asian or Asian British - Pakistani', ifelse(ETHNICITY == 'K', 'Asian or Asian British - Bangladeshi', ifelse(ETHNICITY == 'L', 'Asian or Asian British - Any other Asian background', ifelse(ETHNICITY == 'M', 'Black or Black British - Caribbean', ifelse(ETHNICITY == 'N', 'Black or Black British - African', ifelse(ETHNICITY == 'P', 'Black or Black British - Any other Black background', ifelse(ETHNICITY == 'R', 'Other - Chinese', ifelse(ETHNICITY == 'S', 'Other - Any other ethnic group', ifelse(ETHNICITY == 'Z', 'Not stated', ifelse(ETHNICITY %in% c('X', '9','99'), 'Unknown', ifelse(ETHNICITY == '0', 'White', ifelse(ETHNICITY == '1', 'Black or Black British - Caribbean', ifelse(ETHNICITY == '2', 'Black or Black British - African', ifelse(ETHNICITY == '3', 'Black or Black British - Any other Black background', ifelse(ETHNICITY == '4', 'Asian or Asian British - Indian', ifelse(ETHNICITY == '5', 'Asian or Asian British - Pakistani', ifelse(ETHNICITY == '6', 'Asian or Asian British - Bangladeshi', ifelse(ETHNICITY == '7', 'Other - Chinese', ifelse(ETHNICITY == '8', 'Other - Any other ethnic group',  ETHNICITY)))))))))))))))))))))))))))) %>% 
  left_join(area_lookup, by = c('RESLADST_ONS' = 'Area_code')) %>% 
  mutate(OHID_flag = ifelse(str_detect(CAUSE_3, '^W[01]') & str_detect(DIAG_3_01, '^[ST]') & CLASSPAT == 1, 'Yes', 'No')) %>% 
  mutate(FYEAR = factor(paste0('20',substr(FYEAR, 1,2), '/', substr(FYEAR, 3,4)), levels = c('2011/12', '2012/13', '2013/14', '2014/15', '2015/16', '2016/17', '2017/18', '2018/19', '2019/20', '2020/21', '2021/22'))) %>% 
  mutate(Area_name = factor(Area_name, levels = sussex_ltlas))

falls_65_plus <- df_raw %>% 
  filter(STARTAGE_CALC >= 65) %>% 
  filter(OHID_flag == 'Yes')

admissions_2021_v1 <- falls_65_plus %>% 
  filter(FYEAR == '2020/21') %>% 
  filter(UTLA == 'West Sussex')

admissions_2021_v2 <- falls_65_plus %>% 
  filter(ADMIDATE >= '2020-04-01' & ADMIDATE <= '2021-03-31') %>% 
  filter(UTLA == 'West Sussex')

HES_based_replicating_df <- falls_65_plus %>% 
  group_by(FYEAR, UTLA) %>% 
  summarise(Admissions = disclosure_control(n())) 

falls_ohid %>% 
  filter(Area_name %in% c('Brighton and Hove', 'East Sussex', 'West Sussex')) %>% 
  filter(Year == '2020/21')

HES_based_replicating_df %>% 
  filter(FYEAR == '2020/21')

# This is good enough for me 
wsx_65_falls <- df_raw %>% 
  filter(OHID_flag == 'Yes') %>% 
  filter(STARTAGE_CALC >= 65) %>%
  filter(UTLA == 'West Sussex') %>% 
  group_by(FYEAR) %>% 
  summarise(Admissions = disclosure_control(n())) %>% 
  mutate(position = ifelse(Admissions < 2000, 0,1.1))

wsx_65_falls %>% 
  ggplot() +
  geom_bar(aes(x = FYEAR,
               y = as.numeric(Admissions)),
           fill = 'maroon',
           stat = 'identity') +
  labs(x = 'Financial year',
       y = 'Admission episodes',
       title = 'Number of emergency admissions for falls injuries;\nWest Sussex residents aged 85+',
       subtitle = 'Source: Hospital Episode Statistics',
       caption = 'Admission counts have been rounded to nearest five in accordance with disclosure control rules.') +
  geom_text(aes(label = paste0(format(as.numeric(Admissions), big.mark = ','), ' admissions'),
                x = FYEAR,
                y = as.numeric(Admissions),
                hjust = position,
                colour = as.factor(position)),
            show.legend = FALSE) +
  scale_y_continuous(limits = c(0, 6500),
                     breaks = seq(0,6000, 500),
                     expand = c(0, 1)) +
  scale_colour_manual(values = c('#000000','#ffffff')) +
  coord_flip() +
  theme(panel.background = element_blank())

foundry_85_falls <- df_raw %>% 
  filter(OHID_flag == 'Yes') %>% 
  filter(STARTAGE_CALC >= 85) %>% 
  filter(GPPRAC %in% c('G81035','G81045','G81021')) %>% 
  group_by(FYEAR) %>% 
  summarise(Admissions = disclosure_control(n())) %>% 
  mutate(position = ifelse(Admissions < 50, 0, 1.1))

foundry_85_falls %>% 
  ggplot() +
  geom_bar(aes(x = FYEAR,
               y = as.numeric(Admissions)),
           fill = 'maroon',
           stat = 'identity') +
  labs(x = 'Financial year',
       y = 'Admission episodes',
       title = 'Number of emergency admissions for falls injuries;\nResidents in Sussex aged 85+ registered to NHS Foundry PCN;',
       subtitle = 'Source: Hospital Episode Statistics',
       caption = 'Admission counts have been rounded to nearest five in accordance with disclosure control rules.') +
  geom_text(aes(label = paste0(Admissions, ' admissions'),
                x = FYEAR,
                y = as.numeric(Admissions),
                hjust = position,
                colour = as.factor(position)),
            show.legend = FALSE) +
  scale_y_continuous(limits = c(0, 100),
                     breaks = seq(0,100, 10),
                     expand = c(0, 1)) +
  scale_colour_manual(values = c('#000000','#ffffff')) +
  coord_flip() +
  theme(panel.background = element_blank())

# This definition used by OHID is fairly narrow (only counting emergency admissions where the primary diagnosis is an injury to a part of parts of the body)

# It does not represent the breadth of hospital admissions which are related to falls.

# Annual and rolling three year counts ####

raw_annual_counts <- falls_65_plus %>% 
  group_by(FYEAR, Area_name, UTLA) %>% 
  summarise(Admissions = n()) %>% 
  select(Area_name, UTLA, FYEAR, Admissions) %>% 
  arrange(Area_name, UTLA, FYEAR) %>% 
  group_by(Area_name) %>% 
  mutate(Rolling_FYEAR = ifelse(is.na(lag(FYEAR, 2)), NA, paste0(lag(FYEAR, 2), '-' , FYEAR))) %>% 
  mutate(Three_year_admissions = ifelse(is.na(Rolling_FYEAR), NA,
                                        rollapplyr(Admissions, 
                                                   width = 3,
                                                   FUN = sum, 
                                                   align = 'right', 
                                                   partial = TRUE)))

rolling_three_yr_counts <- raw_annual_counts %>% 
  filter(!is.na(Rolling_FYEAR)) %>% 
  filter(Rolling_FYEAR != '2019/20-2021/22') %>% 
  mutate(Admissions = disclosure_control(Admissions))

small_multiples <- rolling_three_yr_counts %>% 
  filter(UTLA == 'West Sussex') %>% 
  ggplot() +
  geom_bar(aes(x = Rolling_FYEAR,
               y = as.numeric(Admissions)),
           fill = 'maroon',
           stat = 'identity') +
  labs(x = 'Financial year',
       y = 'Admission episodes',
       title = 'Rolling (three year) Number of emergency admissions for falls injuries;\nWest Sussex residents aged 65+',
       subtitle = 'Source: Hospital Episode Statistics',
       caption = 'Admission counts have been rounded to nearest five in accordance with disclosure control rules.') +
  geom_text(aes(label = paste0(format(as.numeric(Admissions), big.mark = ',')),
                x = Rolling_FYEAR,
                y = as.numeric(Admissions)),
            color = '#ffffff',
            hjust = 1.1,
            size = 3) +
  scale_y_continuous(limits = c(0, 1600),
                     breaks = seq(0, 1600, 400),
                     expand = c(0, 1)) +
  coord_flip() +
  theme(panel.background = element_blank()) +
  facet_rep_wrap(. ~ Area_name,
                 ncol = 4,
                 repeat.tick.labels = TRUE)

svg(filename = paste0(output_directory, '/small_multiples_west_sussex_65_plus_rolling_admissions.svg'),
       width = 10,
       height = 5)  
print(small_multiples)
dev.off()

# Exploring by fall type ####

fall_type_annual_df <- falls_65_plus %>% 
  left_join(falls_codes, by = c('CAUSE_3' = 'ICD_code')) %>% 
  group_by(CAUSE_3, definition, Area_name, FYEAR) %>% 
  summarise(Admissions = n()) %>%
  complete(Area_name, FYEAR, fill = list(Admissions = 0)) %>%
  unique() %>% # we need to preserve the 0s for the DSR (or at least there needs to be the same number of records for each group later)
  arrange(CAUSE_3, definition, Area_name, FYEAR) %>% 
  group_by(CAUSE_3, definition, Area_name) %>% 
  mutate(Rolling_FYEAR = ifelse(is.na(lag(FYEAR, 2)), NA, paste0(lag(FYEAR, 2), '-' , FYEAR))) %>% 
  mutate(Three_year_admissions = ifelse(is.na(Rolling_FYEAR),
                                        NA,
                                        rollapplyr(Admissions,
                                                   width = 3,
                                                   FUN = sum, 
                                                   align = 'right', 
                                                   partial = TRUE)))

fall_type_three_year_rolling_df <- fall_type_annual_df %>% 
  filter(!is.na(Rolling_FYEAR)) %>% 
  select(Area_name, CAUSE_3, definition, Rolling_FYEAR, Three_year_admissions) %>% 
  mutate(Three_year_admissions = disclosure_control(Three_year_admissions)) %>% 
  pivot_wider(names_from = 'Rolling_FYEAR',
              values_from = 'Three_year_admissions') %>% 
  arrange(Area_name)

# Small area analyses ####

# LSOA by year #

raw_annual_lsoa_counts <- falls_65_plus %>% 
  group_by(FYEAR, LSOA11CD) %>% 
  summarise(Admissions = n()) %>% 
  select(Area_name, UTLA, FYEAR, Admissions) %>% 
  arrange(Area_name, UTLA, FYEAR) %>% 
  group_by(Area_name) %>% 
  mutate(Rolling_FYEAR = ifelse(is.na(lag(FYEAR, 2)), NA, paste0(lag(FYEAR, 2), '-' , FYEAR))) %>% 
  mutate(Three_year_admissions = ifelse(is.na(Rolling_FYEAR), NA,
                                        rollapplyr(Admissions, 
                                                   width = 3,
                                                   FUN = sum, 
                                                   align = 'right', 
                                                   partial = TRUE)))

rolling_three_yr_counts <- raw_annual_counts %>% 
  filter(!is.na(Rolling_FYEAR)) %>% 
  filter(Rolling_FYEAR != '2019/20-2021/22') %>% 
  mutate(Admissions = disclosure_control(Admissions))



# visualising outputs
map_theme = function(){
  theme( 
    legend.position = "bottom", 
    legend.key.size = unit(.75,"line"),
    legend.title = element_text(size = 8, face = 'bold'),
    plot.background = element_blank(), 
    plot.title.position = "plot",
    panel.background = element_blank(),  
    panel.border = element_blank(),
    axis.text = element_blank(), 
    plot.title = element_text(colour = "#000000", face = "bold", size = 11), 
    plot.subtitle = element_text(colour = "#000000", size = 10), 
    axis.title = element_blank(),     
    panel.grid.major.x = element_blank(), 
    panel.grid.minor.x = element_blank(), 
    panel.grid.major.y = element_blank(), 
    panel.grid.minor.y = element_blank(), 
    strip.text = element_text(colour = "white"), 
    strip.background = element_rect(fill = "#ffffff"), 
    axis.ticks = element_blank()
  ) 
} 

# This will read in the boundaries (in a geojson format) from Open Geography Portal
query <- 'https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Local_Authority_Districts_December_2021_GB_BFC/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson'

lad_boundaries_sf <- st_read(query) %>% 
  filter(LAD21NM %in% sussex_ltlas) 

lad_boundaries_spdf <- as_Spatial(lad_boundaries_sf, IDs = lad_boundaries_sf$LAD21NM)

lad_boundary_ggplot <- lad_boundaries_spdf %>%   
  fortify(region = "LAD21NM") %>% 
  rename(LAD19NM = id) 

# phe_dsr(., 
#         x = Alcohol_related_episodes,
#         n = `2016_20`,
#         stdpop = Standard_population,
#         stdpoptype = "field", 
#         confidence = 0.95, 
#         multiplier = 100000, 
#         type = "full") %>% 
#   mutate(Year = '2016/17 to 2020/21') %>% 
#   bind_cols(dsrs_wsx[c('wsx_dsr', 'wsx_lci', 'wsx_uci')])

lsoa_spdf <- geojson_read("https://opendata.arcgis.com/datasets/8bbadffa6ddc493a94078c195a1e293b_0.geojson",  what = "sp") %>%
  filter(LSOA11CD %in% IMD_2019$LSOA11CD)

lsoa_boundary_ggplot <- lsoa_spdf %>%   
  fortify(region = "LSOA11CD") %>% 
  rename(LSOA11CD = id) 
