library(tidyverse)
library(scales)

cta_lines <- tribble(
  ~line, ~annual_rides, ~color,
  "Red Line",     39173070, "#C60C30",
  "Blue Line",    26050717, "#00A1DE",
  "Brown Line",   11198933, "#62361B",
  "Green Line",    7990447, "#009B3A",
  "Orange Line",   5386907, "#F9461C",
  "Pink Line",     3732162, "#E27EA6",
  "Purple Line",   1613108, "#522398",
  "Yellow Line",    396786, "#F9E300"
)

ggplot(cta_lines,
       aes(x = reorder(line, annual_rides),
           y = annual_rides,
           fill = line)) +
  geom_col() +
  geom_text(aes(label = paste0(round(annual_rides/1e6, 1), "M")),
            hjust = -0.1,
            size = 4.2) +
  scale_fill_manual(values = setNames(cta_lines$color, cta_lines$line)) +
  scale_y_continuous(labels = comma,
                     expand = expansion(mult = c(0, 0.1))) +
  coord_flip() +
  labs(
    title = "2024 CTA Ridership By Line",
    subtitle = "Summed totals, excluding Loop station boardings",
    x = NULL,
    y = NULL
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )
