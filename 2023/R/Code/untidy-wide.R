library(dplyr)
library(haven)
library(here)

# 1. Data ----
input <- here("Data", "LWH_FUP2_raw_data.dta")
df1 <- read_stata(input)

# 2. Data operations ----

## Keeping some columns for the exercise, renaming
df2 <- df1 %>%
  select(starts_with("ID_0"), starts_with("INC_"), starts_with("EXP_")) %>%
  select(-c(ID_03, INC_03, INC_04, INC_06, INC_10, INC_11, INC_12)) %>%
  rename(days_flour = EXP_25_1,
         source_flour = EXP_26_1,
         days_bread = EXP_25_2,
         source_bread = EXP_26_2,
         district = ID_09,
         sector = ID_08,
         cell = ID_07,
         village = ID_06,
         HHID = ID_05,
         income1 = INC_01,
         income2 = INC_02) %>%
  select(district,
         sector,
         cell,
         village, 
         HHID,
         starts_with("inc"),
         starts_with("days"),
         starts_with("source")) %>%
  distinct(district, sector, cell, village, HHID, .keep_all = TRUE)

## Adding duplicates of two entire rows
dups <- df2 %>%
  slice(343, 1111)
df3 <- df2 %>%
  bind_rows(dups) %>%
  arrange(district, sector, cell, village, HHID)

# 3. Exporting result ----
output <- here("Data", "DataWork", "data", "raw", "LWH_baseline_wide.csv")
write.csv(df3, file = output, row.names = FALSE)
