# Data cleaning and tidying
# Exercise 1 
# Load required libraries
library(tidyr)
library(dplyr)
library(janitor)
library(labelled)
library(readxl)
library(haven)
library(here)
library(ggplot2)
library(stringr)

# Exercise 2
# Load data
df_village <- read_xlsx(here("DataWork", "Data", "treat_status.xlsx")) %>%
              clean_names()

df_hh <- read_dta(here("DataWork","Data", "TZA_CCT_baseline.dta")) %>%
        clean_names()

# Exercise 3
nrow(df_hh)
n_distinct(df_hh)
# same number

# Exercise 4
df_hh %>% select(vid, hhid) %>% 
    n_distinct()

# Exercise 5
df_hh_dedup <- df_hh %>% distinct(vid, hhid, .keep_all = TRUE)

# Exercise 6
nrow(df_hh_dedup) == df_hh_dedup %>% 
  select(vid, hhid) %>%
  n_distinct()

# Exercise 7
df_hh_dedup <- df_hh_dedup %>% 
  left_join(df_village, by = "vid")

# Exercise 8
df_hh_village <- df_hh_dedup %>%
  group_by(vid) %>%
  summarise(n_households = n())

# Exercise 9
df_hh_dedup <- df_hh_dedup %>%
  mutate(duration = as.numeric(duration))

class(df_hh_dedup$duration)

# Exercise 10
df_hh_dedup <- df_hh_dedup %>%
  mutate(ar_farm_unit = case_when(
    ar_farm_unit == "Acre" ~ 1,
    ar_farm_unit == "Hectare" ~ 2,
    .default = NA
  ))

# Exercise 11
df_hh_dedup <- df_hh_dedup %>%
  mutate(crop_other_clean = str_replace_all(crop_other, c(
    "Coconut trees" = "Coconut",
    "Coconut trees." = "Coconut",
    "Coconut." = "Coconut",
    "Coconuts" = "Coconut",
    "sesame" = "Sesame",
    "Sesame." = "Sesame"
  )))

# Exercise 12
df_hh_new_cols <- df_hh_dedup %>%
  mutate(year = 2017, collection_stage = "baseline")

# Exercise 13
df_hh_dedup <- df_hh_dedup %>%
  mutate(area_farm_hect = case_when(ar_farm_unit == "Acre" ~ ar_farm * 0.405, .default = ar_farm))

# Exercise 14
df_hh_dedup <- df_hh_dedup %>%
  mutate(read_or_write = case_when(read_1 == 1 | read_2 == 1 ~ 1, .default = 0))

# Exercise 15
df_hh_dedup <- df_hh_dedup %>%
  mutate(any_member_sick = case_when(sick_1 == 1 | sick_2 == 1 ~ 1, .default = 0))

# Exercise 16
df_hh_dedup <- df_hh_dedup %>%
  mutate(total_treat_cost = treat_cost_1 + treat_cost_2)

# Exercise 17
df_hh_dedup <- df_hh_dedup %>%
  rowwise() %>%
  mutate(total_treat_cost = sum(treat_cost_1, treat_cost_2, na.rm = TRUE)) %>%
  ungroup()

# Exercise 18
values_var <- c(1, 0)
labels_var <- c("Yes", "No")
df_hh_dedup <- df_hh_dedup %>%
  mutate(
    read_or_write = factor(read_or_write, levels = values_var, labels = labels_var),
    any_member_sick = factor(any_member_sick, levels = values_var, labels = labels_var)
  )

# Exercise 19
df_hh_dedup <- df_hh_dedup %>%
  set_variable_labels(
    area_farm_hect = "Area of farm in hectares",
    read_or_write = "Can any member read or write?",
    any_member_sick = "Is any member sick?",
    total_treat_cost = "Total cost of treatment"
  )

# Exercise 20
df_hh_dedup <- df_hh_dedup %>%
  mutate(mean_area_farm_hect = mean(area_farm_hect, na.rm = TRUE),
         sd_area_farm_hect = sd(area_farm_hect, na.rm = TRUE),
         z_score = (abs(area_farm_hect - mean_area_farm_hect) / sd_area_farm_hect))

df_outliers <- df_hh_dedup %>%
  filter(z_score > 2.5) %>%
  select(hhid, area_farm_hect, mean_area_farm_hect, z_score)
