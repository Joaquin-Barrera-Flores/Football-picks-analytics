# 0. Establecer el working directory adecuado automáticamente
# if (!grepl("Football-picks-analytics", getwd())) {
#   setwd("~/Football-picks-analytics")  
# }

# 1. De ser necesario, cargar paquetes con instalación automática
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate)

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

# 5. Búsqueda de valores máximos para cada serie
max_barrera <- acumulado[which.max(acumulado$"puntos_barrera"), ]
max_chochos <- acumulado[which.max(acumulado$"puntos_chochos"), ]
max_dani <- acumulado[which.max(acumulado$"puntos_dani"), ]
max_velez <- acumulado[which.max(acumulado$"puntos_velez"), ]

message("Vista de max_barrera:")
glimpse(max_barrera)
message("Vista de max_chochos:")
glimpse(max_chochos)
message("Vista de max_dani:")
glimpse(max_dani)
message("Vista de max_velez:")
glimpse(max_velez)

# 6. Extracción del último valor de cada serie
last_point_barrera <- acumulado %>%
  slice_tail(n = 1) %>%
  select(fecha, "puntos_barrera")
last_point_chochos <- acumulado %>%
  slice_tail(n = 1) %>%
  select(fecha, "puntos_chochos")
last_point_dani <- acumulado %>%
  slice_tail(n = 1) %>%
  select(fecha, "puntos_dani")
last_point_velez <- acumulado %>%
  slice_tail(n = 1) %>%
  select(fecha, "puntos_velez")

message("Vista de last_point_barrera:")
glimpse(last_point_barrera)
message("Vista de last_point_chochos:")
glimpse(last_point_chochos)
message("Vista de last_point_dani:")
glimpse(last_point_dani)
message("Vista de last_point_velez:")
glimpse(last_point_velez)
# 7. Abrir el servidor para la visualización de la gráfica
hgd()
hgd_browse()

# 8. Gráfica
p <- ggplot(acumulado, aes(x = fecha)) +
  geom_line(aes(y = puntos_barrera, color = "Barrera"), size = 0.35) +
  geom_line(aes(y = puntos_chochos, color = "Chochos"), size = 0.35) +
  geom_line(aes(y = puntos_dani, color = "Dani"), size = 0.35) +
  geom_line(aes(y = puntos_velez, color = "Vélez"), size = 0.35) +

  geom_point(data = last_point_barrera, aes(x = fecha, y = puntos_barrera, color = "Barrera"), size = 0.7, show.legend = FALSE) +
  geom_point(data = last_point_chochos, aes(x = fecha, y = puntos_chochos, color = "Chochos"), size = 0.7, show.legend = FALSE) +
  geom_point(data = last_point_dani, aes(x = fecha, y = puntos_dani, color = "Dani"), size = 0.7, show.legend = FALSE) +
  geom_point(data = last_point_velez, aes(x = fecha, y = puntos_velez, color = "Vélez"), size = 0.7, show.legend = FALSE) +

  geom_text(
    data = max_barrera, aes(x = fecha + 1, y = puntos_barrera, label = puntos_barrera, color = "Barrera"),
    vjust = 1, hjust = -0.1, size = 2.5, show.legend = FALSE
  ) +
  geom_text(
    data = max_chochos, aes(x = fecha + 1, y = puntos_chochos, label = puntos_chochos, color = "Chochos"),
    vjust = 2, hjust = -0.1, size = 2.5, show.legend = FALSE
  ) +
  geom_text(
    data = max_dani, aes(x = fecha + 1, y = puntos_dani, label = puntos_dani, color = "Dani"),
    vjust = -0.1, hjust = 0, size = 2.5, show.legend = FALSE
  ) +
  geom_text(
    data = max_velez, aes(x = fecha + 1, y = puntos_velez, label = puntos_velez, color = "Vélez"),
    vjust = 0.5, hjust = -0.6, size = 2.5, show.legend = FALSE
  ) +

  labs(
    title = "Tabla general",
    caption = "Datos a 31 de diciembre de 2024",
    x = "Meses",
    y = "Puntos",
    color = "Jugador"
  ) +
  scale_x_date(breaks = "1 month", date_labels = "%b") +
  scale_color_manual(values = c(
    "Barrera" = "#40c8d3",
    "Chochos" = "#ff9547",
    "Dani" = "#ff67c7",
    "Vélez" = "#689cee"
  )) +
  theme_minimal()

# 9. Mostrar la gráfica
print(p)

# 10. Guardar la gráfica
ggsave("outputs/plots/r/r_tabla_general_anual_2024.png")

# 11. Datos limpios
# Maximo puntaje anual, y día alcanzado, de cada jugador
write.csv(last_point_barrera, here("data", "processed", "r", "metricas_individuales", "puntaje_maximo_barrera_2024.csv"))
write.csv(last_point_chochos, here("data", "processed", "r", "metricas_individuales", "puntaje_maximo_chochos_2024.csv"))
write.csv(last_point_dani, here("data", "processed", "r", "metricas_individuales", "puntaje_maximo_dani_2024.csv"))
write.csv(last_point_velez, here("data", "processed", "r", "metricas_individuales", "puntaje_maximo_velez_2024.csv"))