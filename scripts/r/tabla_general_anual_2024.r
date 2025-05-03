# 0. Establecer el working directory adecuado automáticamente
# if (!grepl("Football-picks-analytics", getwd())) {
#   setwd("~/Football-picks-analytics")
# }

# 1. De ser necesario, cargar paquetes con instalación automática
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr)

# 3. (Personal) Importar y reconocer el archivo
# acumulado <- read.csv(
#   here("data", "raw", "acumulados_anuales", "acumulado_total_2024.csv"))

# 3. (Visitantes) Importar y reconocer el archivo
url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_anuales/acumulado_total_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
glimpse(acumulado)

# 4. Convertir columna fecha automáticamente
acumulado$fecha <- dmy(acumulado$fecha)

# 5-6. Calcular máximos y últimos valores de cada jugador
jugadores <- c("barrera", "chochos", "dani", "velez")

maximos <- map(jugadores, ~ acumulado[which.max(acumulado[[paste0("puntos_", .x)]]), ])
names(maximos) <- jugadores

ultimos <- map(jugadores, ~ acumulado %>%
  slice_tail(n = 1) %>%
  select(fecha, puntos = all_of(paste0("puntos_", .x))))
names(ultimos) <- jugadores

# 7. Abrir el servidor para la visualización de la gráfica
hgd()
hgd_browse()

# 8. Gráfica
colores <- c("Barrera" = "#40c8d3", "Chochos" = "#ff9547", "Dani" = "#ff67c7", "Vélez" = "#689cee")
nombres_jugadores <- c("barrera" = "Barrera", "chochos" = "Chochos", "dani" = "Dani", "velez" = "Vélez")

p <- ggplot(acumulado, aes(x = fecha)) +
  map(jugadores, ~ geom_line(aes_string(y = paste0("puntos_", .x), color = shQuote(nombres_jugadores[[.x]])), size = 0.35)) +
  map(jugadores, ~ geom_point(data = ultimos[[.x]], aes(x = fecha, y = puntos, color = nombres_jugadores[[.x]]), size = 0.7, show.legend = FALSE)) +
  map(jugadores, ~ geom_text(
    data = maximos[[.x]],
    aes_string(
      x = "fecha + 1", y = paste0("puntos_", .x),
      label = paste0("puntos_", .x), color = shQuote(nombres_jugadores[[.x]])
    ),
    size = 2.5, show.legend = FALSE, vjust = 1, hjust = -0.1
  )) +
  labs(
    title = "Tabla general",
    caption = "Datos a 31 de diciembre de 2024",
    x = "Meses",
    y = "Puntos",
    color = "Jugador"
  ) +
  scale_x_date(breaks = "1 month", date_labels = "%b") +
  scale_color_manual(values = colores) +
  theme_minimal()

# 9. Mostrar la gráfica
print(p)

# 10. Guardar la gráfica
ggsave("outputs/plots/r/r_tabla_general_anual_2024.png")

# 11. Datos limpios: guardar últimos valores
walk(jugadores, ~ write.csv(
  ultimos[[.x]],
  here("data", "processed", "r", "metricas_individuales", paste0("puntaje_maximo_", .x, "_2024.csv")),
  row.names = FALSE
))
