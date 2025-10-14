# SECCIÓN: CARGA DE PAQUETES Y DATOS

if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr, rlang, ggthemes)

#SECCIÓN: IMPORTAR DATOS Y VISTA PREVIA

url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_mensuales/2024/julio_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
glimpse(acumulado)

# SECCIÓN: PREPARACIÓN DE DATOS

acumulado$julio <- dmy(acumulado$julio)

# SECCIÓN: CONFIGURACIÓN

jugadores <- c("barrera", "chochos", "dani", "velez")

nombres_jugadores <- c("barrera" = "Barrera", "chochos" = "Chochos", "dani" = "Dani", "velez" = "Vélez")

colores <- c(
    "Barrera" = "#49525e",
    "Chochos" = "#9b93c9",
    "Dani" = "#fdb052",
    "Vélez" = "#59acbe"
)

ajustes_texto <- list(
    barrera = list(desp_dias = 1, desp_pct = 0.01),
    chochos = list(desp_dias = 1, desp_pct = -0.02),
    dani    = list(desp_dias = 1, desp_pct = 0.04),
    velez   = list(desp_dias = 1, desp_pct = -0.03)
)

# SECCIÓN: CALCULOS INTERMEDIOS

maximos <- map(jugadores, ~ acumulado[which.max(acumulado[[paste0("puntos_", .x)]]), ])
names(maximos) <- jugadores

ultimos <- map(jugadores, ~ acumulado %>%
    slice_tail(n = 1) %>%
    select(julio, puntos = all_of(paste0("puntos_", .x))))
names(ultimos) <- jugadores

maximos_ajustados <- map(jugadores, ~ {
    fila <- maximos[[.x]]
    puntos_col <- paste0("puntos_", .x)
    desp <- ajustes_texto[[.x]]
    rango_y <- diff(range(acumulado[[puntos_col]]))

    data.frame(
        fecha_texto = fila$julio + days(desp$desp_dias),
        y_texto = fila[[puntos_col]] + (rango_y * desp$desp_pct),
        jugador = nombres_jugadores[[.x]],
        label = fila[[puntos_col]]
    )
}) %>% bind_rows()

# SECCIÓN: GRAFICA Y VISUALIZACIÓN

hgd()
hgd_browse()

jul_24 <- ggplot(acumulado, aes(x = julio)) +
    map(jugadores, function(jugador) {
        geom_line(
            aes(y = !!sym(paste0("puntos_", jugador)), 
            color = nombres_jugadores[[jugador]]),
            linewidth = 0.35
        )
    }) +
    # Puntos finales
    map(jugadores, ~ {
        geom_point(
            data = ultimos[[.x]],
            aes(x = julio, y = puntos, color = nombres_jugadores[[.x]]),
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
        title = "Tabla mensual - Julio",
        caption = "Datos a 31 de julio de 2024",
        x = "Días",
        y = "Puntos",
        color = "Jugador"
    ) +
    scale_x_date(breaks = "1 week", date_labels = "%d") +
    scale_color_manual(values = colores) +
    theme_few()

# 10. Mostrar gráfica
print(jul_24)

# 11. Guardar gráfica
ggsave(
    filename = "outputs/plots/r/clasificaciones/mensuales/2024/r_tabla_julio_2024.png",
    plot = jul_24,
    width = 16,
    height = 8,
    units = "in",
    dpi = 600
)