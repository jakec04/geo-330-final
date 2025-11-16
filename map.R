#| label: tbl-ridership-by-line
#| tbl-cap: "Average Weekday Ridership by CTA Line"
#| echo: false
#| message: false
#| warning: false

library(dplyr)
library(scales)

# stations_ll already exists from the map chunk

ridership_by_line <- stations_ll |>
  as.data.frame() |>
  dplyr::group_by(line_simplified) |>
  dplyr::summarise(
    avg_weekday_riders = mean(avg_weekday_rides, na.rm = TRUE),
    stations_in_line   = dplyr::n(),
    .groups = "drop"
  ) |>
  dplyr::arrange(desc(avg_weekday_riders)) |>
  dplyr::mutate(
    avg_weekday_riders = comma(round(avg_weekday_riders))
  )

ridership_by_line



#| label: tbl-monthly-averages
#| tbl-cap: "Average monthly CTA rail ridership by year, 2019–2025 (excluding Jan–Apr 2020)."
#| echo: false
#| message: false
#| warning: false

library(dplyr)
library(scales)
library(knitr)

yearly_avg <- monthly %>%
  group_by(year) %>%
  summarize(
    months_included = n(),
    avg_monthly_riders = mean(monthly_riders, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    avg_monthly_riders_millions = avg_monthly_riders / 1e6
  )

yearly_avg %>%
  transmute(
    Year = year,
    `Months included` = months_included,
    `Avg. monthly riders` = comma(avg_monthly_riders, accuracy = 1),
    `Avg. monthly riders (millions)` = number(avg_monthly_riders_millions, accuracy = 0.1)
  ) %>%
  kable()
