
# Load required packages
#install.packages("ggplot2")
library(ggplot2)
library(dplyr)
library(forcats)
library(haven)
library(here)
library(scales)

# Exercise 2: Read and label data
df_hh <- read_stata(here("DataWork","Data","Raw", "TZA_CCT_baseline.dta")) %>%
  as_factor()

# Exercise 3: Basic scatterplot
df_hh %>%
  ggplot(aes(x = food_cons, y = nonfood_cons)) +
  geom_point()

# Exercise 4: Customized scatterplot
custom_scatter <- df_hh %>%
  ggplot(aes(x = food_cons, y = nonfood_cons)) +
  geom_point(color = "navy") +
  labs(
    title = "Household food and non-food consumption value",
    x = "Annual food consumption",
    y = "Annual non-food consumption"
  ) +
  scale_x_continuous(labels = label_comma(), limits = c(0, 5100000)) +
  scale_y_continuous(labels = label_comma()) +
  theme_minimal()

# Exercise 5: Bar plot
df_energy <- df_hh %>%
  group_by(energy) %>%
  summarize(N = n()) %>%
  ungroup() %>%
  mutate(energy = fct_recode(energy,
                             "Solar panels/\nprivate generator" = "Solar panels/private generator"))

bar_plot <- ggplot(df_energy, aes(x = energy, y = N)) +
  geom_col(fill = "dark green") +
  geom_text(aes(label = N), vjust = -0.25) +
  labs(
    title = "Energy sources used for lightning",
    x = "Energy source",
    y = "Number of HHs"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(size = 7.5))

# Exercise 6: Histogram
hist_plot <- ggplot(df_hh, aes(x = food_cons)) +
  geom_histogram(fill = "cyan2") +
  scale_x_continuous(labels = label_comma()) +
  labs(
    title = "Distribution of HH Annual Food Consumption",
    x = "Food consumption",
    y = "Number of HHs"
  ) +
  theme_minimal()

# Exercise 7: Box plot
box_plot <- ggplot(df_hh, aes(x = factor(enid), y = as.numeric(duration))) +
  geom_boxplot(fill = "purple") +
  labs(
    title = "Distribution of Survey Duration by Enumerator",
    x = "Enumerator ID",
    y = "Minutes"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Exercise 8: Save one plot
ggsave(
  box_plot,
  filename = here("DataWork", "Outputs", "boxplot.png"),
  dpi = 300,
  scale = 0.8,
  width = 8,
  bg = "white"
)

# Exercise 9: Save other plots
ggsave(
  custom_scatter,
  filename = here("DataWork", "Outputs", "scatterplot.png"),
  dpi = 300,
  scale = 0.8,
  width = 8,
  bg = "white"
)

ggsave(
  bar_plot,
  filename = here("DataWork", "Outputs", "barplot.png"),
  dpi = 300,
  scale = 0.8,
  width = 8,
  bg = "white"
)

ggsave(
  hist_plot,
  filename = here("DataWork", "Outputs", "histogram.png"),
  dpi = 300,
  scale = 0.8,
  width = 8,
  bg = "white"
)
