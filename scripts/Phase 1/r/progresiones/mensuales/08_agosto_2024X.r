if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr, rlang, ggthemes)

url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_mensuales/2024/agosto_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
glimpse(acumulado)