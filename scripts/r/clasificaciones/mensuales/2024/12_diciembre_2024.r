# SECCIÓN: CARGA DE PAQUETES Y DATOS

if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr, rlang, ggthemes)

#SECCIÓN: IMPORTAR DATOS Y VISTA PREVIA

url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_mensuales/2024/diciembre_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
glimpse(acumulado)

# SECCIÓN: PREPARACIÓN DE DATOS

acumulado$diciembre <- dmy(acumulado$diciembre)

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
    barrera = list(desp_dias = 2, desp_pct = 0),
    chochos = list(desp_dias = 2, desp_pct = 0),
    dani    = list(desp_dias = 1, desp_pct = 0),
    velez   = list(desp_dias = 4, desp_pct = 0)
)

# SECCIÓN: CALCULOS INTERMEDIOS

maximos <- map(jugadores, ~ acumulado[which.max(acumulado[[paste0("puntos_", .x)]]), ])
names(maximos) <- jugadores

ultimos <- map(jugadores, ~ acumulado %>%
    slice_tail(n = 1) %>%
    select(diciembre, puntos = all_of(paste0("puntos_", .x))))
names(ultimos) <- jugadores

maximos_ajustados <- map(jugadores, function(jugador) {
    fila <- maximos[[jugador]]
    puntos_col <- paste0("puntos_", jugador)
    desp <- ajustes_texto[[jugador]]
    rango_y <- diff(range(acumulado[[puntos_col]]))

    data.frame(
        fecha_texto = fila$diciembre + days(desp$desp_dias),
        y_texto = fila[[puntos_col]] + (rango_y * desp$desp_pct),
        jugador = nombres_jugadores[[jugador]],
        label = fila[[puntos_col]]
    )
}) %>% bind_rows()

# SECCIÓN: GRAFICA Y VISUALIZACIÓN

hgd()
hgd_browse()

dic_24 <- ggplot(acumulado, aes(x = diciembre)) +
    map(jugadores, function(jugador) {
        geom_line(
            aes(y = !!sym(paste0("puntos_", jugador)), color = nombres_jugadores[[jugador]]),
            linewidth = 0.35
        )
    }) +

    map(jugadores, function(jugador) {
        geom_point(
            data = ultimos[[jugador]],
            aes(x = diciembre, y = puntos, color = nombres_jugadores[[jugador]]),
            size = 0.7, show.legend = FALSE
        )
    }) +

    geom_text(
        data = maximos_ajustados,
        aes(x = fecha_texto, y = y_texto, label = label, color = jugador),
        size = 2.5, show.legend = FALSE
    ) +

    labs(
        title = "Tabla mensual - Diciembre",
        caption = "Datos a 31 de diciembre de 2024",
        x = "Días",
        y = "Puntos",
        color = "Jugador"
    ) +

    scale_x_date(breaks = "1 week", date_labels = "%d") +
    scale_color_manual(values = colores) +
    theme_few()

print(dic_24)

ggsave(
    filename = "outputs/plots/r/clasificaciones/mensuales/2024/r_tabla_diciembre_2024.png",
    plot = dic_24,
    width = 16,
    height = 8,
    units = "in",
    dpi = 600
)