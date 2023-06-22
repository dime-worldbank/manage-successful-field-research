library(dplyr)
library(here)
library(labelled)
library(janitor)

# 1. Data ----
input <- here("Data",
              "DataWork",
              "data",
              "intermediate",
              "tidy",
              "tidy-HH.Rds")
df <- readRDS(input) %>% clean_names()

# 2. Data operations ----
df2 <- df %>%
  select(-c(device_id,
            sim_number,
            id_10_confirm,
            id_10_corrected)) %>%
  mutate(
    inc_02 = as.numeric(inc_02),
    year = 2017,
    collection_stage = "baseline"
  ) %>%
  filter(
    inc_01 >= 0,
    inc_01 < 70000,
    inc_02 >= 0,
    inc_02 < 70000
  ) %>%
  set_variable_labels(
    inc_02 = "INC_02: Non-farm enterprise (RWF)",
    year = "Year",
    collection_stage = "Stage of data collection"
  )

# 3. Saving dataframes ----
output_path <- here("Data", "DataWork", "data", "intermediate", "clean")
saveRDS(df2,
        here(output_path, "LWH-households-clean.Rds"))