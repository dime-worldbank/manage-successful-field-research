library(dplyr)
library(haven)
library(here)

# 1. Data ----
input <- here("Data", "admin_data.dta")
df1 <- read_stata(input)

# 2. Data operations ----

## New rows to append
df2 <- df1 %>%
  mutate(rand = runif(nrow(df1), min = 2, max = 7),
         count = round(HH_Count * rand),
         group = 'population') %>%
  select(-c(rand, HH_Count))

## New df, long in village, untidy
df3 <- df1 %>%
  rename(count = HH_Count) %>%
  mutate(group = 'HH') %>%
  bind_rows(df2) %>%
  arrange(Province, District, Sector, Cell, Village, group) %>%
  select(Province, District, Village, group, count) %>%
  distinct(Province, District, Village, group, .keep_all = TRUE)

# 3. Exporting ----
output <- here("Data", "DataWork", "data", "raw", "admin_data_long.csv")
write.csv(df3, file = output, row.names = FALSE)
