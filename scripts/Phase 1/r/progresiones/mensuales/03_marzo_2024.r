# SECCIÓN: CARGA DE PAQUETES Y DATOS

if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr, rlang, ggthemes)

#SECCIÓN: IMPORTAR DATOS Y VISTA PREVIA

url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_mensuales/2024/marzo_2024.csv"
acumulado <- read.csv(url)
message("Vista previa de los datos:")
glimpse(acumulado)

# SECCIÓN: PREPARACIÓN DE DATOS

acumulado$marzo <- dmy(acumulado$marzo)

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
    chochos = list(desp_dias = 22, desp_pct = -0.02),
    dani    = list(desp_dias = 1, desp_pct = 0.04),
    velez   = list(desp_dias = 1, desp_pct = -0.03)
)

# SECCIÓN: CALCULOS INTERMEDIOS

maximos <- map(jugadores, ~ acumulado[which.max(acumulado[[paste0("puntos_", .x)]]), ])
names(maximos) <- jugadores

ultimos <- map(jugadores, ~ acumulado %>%
    slice_tail(n = 1) %>%
    select(marzo, puntos = all_of(paste0("puntos_", .x))))
names(ultimos) <- jugadores

maximos_ajustados <- map(jugadores, ~ {
    maximo <- maximos[[.x]]
    puntos_jugador <- paste0("puntos_", .x)
    desp <- ajustes_texto[[.x]]
    rango_y <- diff(range(acumulado[[puntos_jugador]]))

    data.frame(
        ajuste_x = maximo$marzo + days(desp$desp_dias),
        ajuste_y = maximo[[puntos_jugador]] + (rango_y * desp$desp_pct),
        jugador = nombres_jugadores[[.x]],
        etiqueta = maximo[[puntos_jugador]]
    )
}) %>% bind_rows()


# SECCIÓN: GRAFICA Y VISUALIZACIÓN

hgd()
hgd_browse()

mar_24 <- ggplot(acumulado, aes(x = marzo)) +
    map(jugadores, ~ {
        geom_line(
            aes(
                y = !!sym(paste0("puntos_", .x)),
                color = nombres_jugadores[[.x]]
            ),
            linewidth = 0.35
        )
    }) +

    map(jugadores, ~ {
        geom_point(
            data = ultimos[[.x]],
            aes(
                x = marzo,
                y = puntos,
                color = nombres_jugadores[[.x]]
            ),
            size = 0.7,
            show.legend = FALSE
        )
    }) +

    geom_text(
        data = maximos_ajustados,
        aes(x = ajuste_x, y = ajuste_y, label = etiqueta, color = jugador),
        size = 4,
        show.legend = FALSE
    ) +

    labs(
        title = "Tabla mensual - Marzo",
        caption = "Datos a 31 de marzo de 2024",
        x = "Días",
        y = "Puntos",
        color = "Jugador"
    ) +
    

    scale_x_date(breaks = "1 week", date_labels = "%d") +
    scale_color_manual(values = colores) +
    theme_few()

    print(mar_24)

ggsave(
    filename = "outputs/plots/Phase 1/r/progresiones/mensuales/r_tabla_marzo_2024.png",
    plot = mar_24,
    width = 16,
    height = 8,
    units = "in",
    dpi = 600
)