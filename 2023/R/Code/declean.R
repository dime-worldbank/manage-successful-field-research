library(dplyr)
library(haven)
library(here)
library(tidyr)
library(labelled)

# 1. Data ----

## Admin data
input_admin <- here("Data", "admin_data.csv")
df_admin <- read.csv(input_admin)

## Survey data
input_survey <- here("Data", "LWH_FUP2_raw_data.dta")
df_survey <- read_stata(input_survey)

# 2. Data operations ----

## Admin data
df_admin2 <- df_admin %>%
  distinct(Province,
           District,
           Sector,
           Cell,
           Village,
           .keep_all = TRUE)

## Survey data

### HH level
df_hh <- df_survey %>%
  select(
    device_id,
    sim_number,
    starts_with("ID_"),
    starts_with("INC_")
  ) %>%
  distinct()

### Food source level
df_food <- df_survey %>%
  select(
    ID_05:ID_06,
    starts_with("EXP_")
  ) %>%
  rename(
    EXP25_1 = EXP_25_1,
    EXP25_2 = EXP_25_2,
    EXP26_1 = EXP_26_1,
    EXP26_2 = EXP_26_2
  ) %>%
  pivot_longer(cols = starts_with("EXP"),
               names_to = c('.value',
                            'food'),
               names_sep = '_') %>%
  mutate(
    food = case_when(food == 1 ~ "Flour",
                     food == 2 ~ "Bread"),
    EXP26 = as.numeric(EXP26)
  ) %>%
  set_variable_labels(
    EXP25 = "How many days in the last 1 week has your household consumed?",
    EXP26 = "What was the source of?",
    food  = "Food"
  )

# 3. Saving dataframes ----
output_path <- here("Data", "DataWork", "data", "intermediate", "tidy")
saveRDS(df_admin2,
        here(output_path, "tidy-village.Rds"))
saveRDS(df_hh,
        here(output_path, "tidy-HH.Rds"))
saveRDS(df_food,
        here(output_path, "tidy-food-consumption.Rds"))