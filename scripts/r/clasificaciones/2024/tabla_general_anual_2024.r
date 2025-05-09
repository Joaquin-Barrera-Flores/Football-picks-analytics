# 0. Establecer el working directory adecuado automáticamente
# if (!grepl("Football-picks-analytics", getwd())) {
#   setwd("~/Football-picks-analytics")
# }

# 1. Cargar paquetes necesarios
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr, rlang)

# 2. Importar datos (modo visitante)
url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_anuales/acumulado_total_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
glimpse(acumulado)

# 3. Convertir fechas
acumulado$fecha <- dmy(acumulado$fecha)

# 4. Configurar nombres y colores
jugadores <- c("barrera", "chochos", "dani", "velez")
nombres_jugadores <- c("barrera" = "Barrera", "chochos" = "Chochos", "dani" = "Dani", "velez" = "Vélez")
colores <- c(
    "Barrera" = "#49525e",
    "Chochos" = "#9b93c9",
    "Dani" = "#fdb052",
    "Vélez" = "#59acbe")

# 5. Ajustes individuales por jugador (horizontal y vertical)
ajustes_texto <- list(
  barrera = list(desp_dias = 3,  desp_pct = 0.02),
  chochos = list(desp_dias = 3,  desp_pct = -0.02),
  dani    = list(desp_dias = 2,  desp_pct = 0.04),
  velez   = list(desp_dias = 4,  desp_pct = 0.03)
)

# 6. Calcular máximos y últimos valores
maximos <- map(jugadores, ~ acumulado[which.max(acumulado[[paste0("puntos_", .x)]]), ])
names(maximos) <- jugadores

ultimos <- map(jugadores, ~ acumulado %>%
  slice_tail(n = 1) %>%
  select(fecha, puntos = all_of(paste0("puntos_", .x))))
names(ultimos) <- jugadores

# 7. Construir data frame con posiciones de texto ajustadas individualmente
maximos_ajustados <- map(jugadores, function(jugador) {
  fila <- maximos[[jugador]]
  puntos_col <- paste0("puntos_", jugador)
  desp <- ajustes_texto[[jugador]]
  rango_y <- diff(range(acumulado[[puntos_col]]))

  data.frame(
    fecha_texto = fila$fecha + days(desp$desp_dias),
    y_texto = fila[[puntos_col]] + (rango_y * desp$desp_pct),
    jugador = nombres_jugadores[[jugador]],
    label = fila[[puntos_col]]
  )
}) %>% bind_rows()

# 8. Abrir servidor de gráficos
hgd()
hgd_browse()

# 9. Graficar (optimizado sin aes_string)
C <- ggplot(acumulado, aes(x = fecha)) +
  # Líneas por jugador
  map(jugadores, function(jugador) {
    geom_line(
      aes(y = !!sym(paste0("puntos_", jugador)), color = nombres_jugadores[[jugador]]),
      linewidth = 0.5
    )
  }) +
  # Puntos finales
  map(jugadores, function(jugador) {
    geom_point(
      data = ultimos[[jugador]],
      aes(x = fecha, y = puntos, color = nombres_jugadores[[jugador]]),
      size = 0.7, show.legend = FALSE
    )
  }) +
  # Texto con máximos
  geom_text(
    data = maximos_ajustados,
    aes(x = fecha_texto, y = y_texto, label = label, color = jugador),
    size = 2.5, show.legend = FALSE
  ) +
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

# 10. Mostrar gráfica
print(C)

# 11. Guardar gráfica
ggsave(
  filename = "outputs/plots/r/r_tabla_general_anual_2024.png",
  plot = C,
  width = 12,
  height = 8,
  units = "in",
  dpi = 600
)

# 12. Guardar últimos valores
walk(jugadores, ~ write.csv(
  ultimos[[.x]],
  here("data", "processed", "r", "metricas_individuales", "maximos", "2024", paste0("puntaje_maximo_", .x, "_2024.csv")),
  row.names = FALSE
))
