# 1. Establecer working directory automáticamente
if (!grepl("Football-picks-analytics", getwd())) {
  setwd("~/Football-picks-analytics")  # Ajusta si usas otra ruta
}

# 2. Cargar paquetes con instalación automática
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr)

acumulado <- read.csv(
  here("data", "raw", "acumulados_anuales", "acumulado_total_2024.csv"))

# 3. Importar y reconocer el archivo
url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_anuales/acumulado_total_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
# Verificar carga
glimpse(acumulado)


# 3. Formato de fecha
acumulado$fecha <- as.Date(acumulado$fecha, format = "%d/%m")
write_csv(acumulado, here("data", "processed", "r", "acumulado_fechas_convertidas.csv"))

# 4. Búsqueda de valores máximos para cada serie
  max_barrera <- acumulado[which.max(acumulado$"puntos_barrera"), ]
  max_chochos <- acumulado[which.max(acumulado$"puntos_chochos"), ]
  max_dani <- acumulado[which.max(acumulado$"puntos_dani"), ]
  max_velez <- acumulado[which.max(acumulado$"puntos_velez"), ]

# 5. Extracción del último valor de cada serie
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

# 6. Abrir el servidor para la visualización de la gráfica
hgd()
hgd_browse()

# 7. Gráfica
p <- ggplot(acumulado, aes(x = fecha)) +
  # Líneas principales
  geom_line(aes(y = puntos_barrera, color = "Barrera"), size = 0.35) +
  geom_line(aes(y = puntos_chochos, color = "Chochos"), size = 0.35) +
  geom_line(aes(y = puntos_dani, color = "Dani"), size = 0.35) +
  geom_line(aes(y = puntos_velez, color = "Vélez"), size = 0.35) +

  # Puntos finales (sin leyenda)
  geom_point(data = last_point_barrera, aes(x = fecha, y = puntos_barrera, color = "Barrera"), size = 0.7, show.legend = FALSE) +
  geom_point(data = last_point_chochos, aes(x = fecha, y = puntos_chochos, color = "Chochos"), size = 0.7, show.legend = FALSE) +
  geom_point(data = last_point_dani, aes(x = fecha, y = puntos_dani, color = "Dani"), size = 0.7, show.legend = FALSE) +
  geom_point(data = last_point_velez, aes(x =fecha, y = puntos_velez, color = "Vélez"), size = 0.7, show.legend = FALSE) +

  # Textos de los valores máximos (sin leyenda)
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

  # Configuración de etiquetas y colores
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

# 8. Mostrar la gráfica
print(p)

# Guardar todos los resultados procesados
library(readr)
dir.create(here("data", "processed", "r"), showWarnings = FALSE)

# 1. Datos limpios
write_csv(acumulado, here("data", "processed", "r", "acumulado_limpio.csv"))

# 2. Métricas de jugadores
list(
  "maximos" = bind_rows(
    max_barrera %>% mutate(jugador = "Barrera"),
    max_chochos %>% mutate(jugador = "Chochos"),
    # ... otros jugadores
  ),
  "finales" = bind_rows(
    last_point_barrera %>% mutate(jugador = "Barrera"),
    # ... otros jugadores
  )
) %>%
  write_rds(here("data", "processed", "r", "metricas_jugadores.csv"))  # Guarda múltiples objetos