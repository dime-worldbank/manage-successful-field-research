library(dplyr)
library(haven)
library(here)
library(janitor)
library(tidyr)

# 1. Data ----
input <- here("Data", "admin_data.dta")
df1 <- read_stata(input) %>% clean_names()

# 2. Data operations ----

## Village dataframe
df2 <- df1 %>%
  select(-c(hh_count)) %>%
  mutate(village_id = row_number() + 1000) %>%
  select(village_id,
         province,
         district,
         sector,
         cell,
         village)

## HH dataframe
df3 <- df1 %>%
  mutate(village_id = row_number() + 1000,
         hh_count = round(hh_count / 7)) %>%
  uncount(hh_count) %>%
  select(village_id, village) %>%
  mutate(hh_id = row_number() + 100000,
         hh_members = ceiling(runif(nrow(.)) * 11))
  
# 3. Exporting results ----
output_path <- here("data", "DataWork", "data", "raw")
write.csv(df2,
          here(output_path, "village_census.csv"),
          row.names = FALSE)
write.csv(df3,
          here(output_path, "household_census.csv"),
          row.names = FALSE)