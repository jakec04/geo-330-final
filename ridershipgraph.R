```{r}
library(tidyverse)
library(lubridate)
library(scales)

# 1. Load CTA dataset (daily boardings)
base <- "https://data.cityofchicago.org/resource/6iiy-9s97.csv"
query <- "?$limit=200000"
url <- URLencode(paste0(base, query))

df <- readr::read_csv(url, show_col_types = FALSE) %>%
  mutate(
    service_date = as.Date(service_date),
    year  = year(service_date),
    month = month(service_date),
    month_label = factor(month.abb[month], levels = month.abb),
    total_rides = as.numeric(total_rides)
  ) %>%
  filter(
    year >= 2019, year <= 2025,
    !(year == 2020 & month <= 4)   # drop Jan–Apr 2020 (pre-pandemic)
  )

# 2. TOTAL MONTHLY RIDERSHIP (sum of daily values in each month)
monthly <- df %>%
  group_by(year, month, month_label) %>%  # keep numeric month too
  summarize(
    monthly_riders = sum(total_rides, na.rm = TRUE),
    .groups = "drop"
  )

# 3. Keep 2019–2025 and make year a factor for custom colors / ordering
plot_data <- monthly %>%
  filter(year %in% 2019:2025) %>%
  mutate(year = factor(year))

# 4. Positions for right-edge labels: use numeric month to get the last month per year
end_labels <- plot_data %>%
  group_by(year) %>%
  filter(month == max(month)) %>%
  ungroup()

# 5. Custom NYT-ish color palette: 2019 bold, middle years muted, latest years highlighted
year_colors <- c(
  "2019" = "#222222",  # dark baseline
  "2020" = "#d0d0d0",
  "2021" = "#c0c0c0",
  "2022" = "#aaaaaa",
  "2023" = "#8f8f8f",
  "2024" = "#7F7F7F",  # strong blue
  "2025" = "#0072B2"   # accent orange
)

# 6. Plot: modern look with baseline + direct labels
ggplot(plot_data, aes(
  x = month_label,
  y = monthly_riders,
  group = year,
  color = year
)) +
  # muted lines first
  geom_line(
    data = subset(plot_data, year != "2019"),
    linewidth = 0.7
  ) +
  # bold pre-pandemic baseline
  geom_line(
    data = subset(plot_data, year == "2019"),
    linewidth = 1.2
  ) +
  # Direct labels at the right edge
  geom_text(
    data = end_labels,
    aes(
      label = ifelse(
        year == "2019",
        "2019 (pre-pandemic baseline)",
        as.character(year)
      )
    ),
    hjust = -0.05,
    vjust = 0.5,
    size = 3,
    show.legend = FALSE
  ) +
  scale_color_manual(values = year_colors) +
  scale_y_continuous(
    labels = label_number(accuracy = 0.1, scale = 1e-6, suffix = "M"),
    expand = expansion(mult = c(0, 0.1))
  ) +
  scale_x_discrete(expand = expansion(mult = c(0.02, 0.12))) +
  coord_cartesian(clip = "off") +
  labs(
    title = "CTA Ridership is still lagging",
    subtitle = "Total monthly rail boarings, 2019–2025.",
    x = "Month",
    y = "Total monthly riders"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_line(color = "grey85"),
    axis.title.y = element_text(margin = margin(r = 10)),
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(color = "grey30"),
    plot.margin = margin(t = 10, r = 40, b = 10, l = 5)
  )
