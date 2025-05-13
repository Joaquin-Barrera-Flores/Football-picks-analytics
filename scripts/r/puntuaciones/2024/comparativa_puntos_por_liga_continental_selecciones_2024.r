# Cargar paquetes
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate,ggthemes)

# Importar datos desde GitHub
url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/principales/2024/puntos_2024.csv"
puntuacion <- read.csv(url)

filtro_continentales_selecciones_total <- puntuacion %>%
    filter(
        torneo %in% c(
            "CONCACAF Nations League", "Copa América", "Eurocopa",
            "UEFA Nations League", "Copa Oro Femenil", "OFC Nations Cup"
        )
    ) %>%
    group_by(torneo) %>%
    summarise(
        Barrera = sum(puntos_barrera, na.rm = TRUE),
        Chochos = sum(puntos_chochos, na.rm = TRUE),
        Dani = sum(puntos_dani, na.rm = TRUE),
        Vélez = sum(puntos_velez, na.rm = TRUE)
    ) %>%
    mutate(Total_Puntos = Barrera + Chochos + Dani + Vélez) %>%
    arrange(desc(Total_Puntos))

# Sumar puntos por torneo
suma_puntos_por_torneo_continental_selecciones <- filtro_continentales_selecciones_total %>%
    mutate(Total_Puntos = Barrera + Chochos + Dani + Vélez) %>%
    filter(
        Total_Puntos >= 20) %>%
    arrange(desc(Total_Puntos)) %>%
    mutate(torneo = factor(torneo, levels = unique(torneo)))

# Transformar a formato largo
suma_larga <- suma_puntos_por_torneo_continental_selecciones %>%
    pivot_longer(
        cols = c(Barrera, Chochos, Dani, Vélez),
        names_to = "Jugador",
        values_to = "Puntos"
    ) %>%
    mutate(
        nudge = case_when(
            Jugador == "Barrera" ~ -0.3,
            Jugador == "Chochos" ~ -0.1,
            Jugador == "Dani" ~ 0.1,
            Jugador == "Vélez" ~ 0.3
        )
    )

# Colores personalizados
colores_jugadores <- c(
    "Barrera" = "#49525e",
    "Chochos" = "#9b93c9",
    "Dani" = "#fdb052",
    "Vélez" = "#59acbe"
)

# Activar visor httpgd (opcional)
hgd()
hgd_browse()

# Crear gráfico con etiquetas de puntos
con_s <- ggplot(suma_larga, aes(x = torneo, y = Puntos, fill = Jugador)) +
    geom_bar(
        stat = "identity",
        position = position_nudge(x = suma_larga$nudge),
        width = 0.2,
        alpha = 0.6
    ) +
    geom_text(
        aes(
            x = as.numeric(torneo) + nudge,
            label = Puntos,
            color = Jugador
        ),
        vjust = -0.5,
        size = 2.8,
        show.legend = FALSE
    ) +
    scale_fill_manual(values = colores_jugadores) +
    scale_color_manual(values = colores_jugadores) +
    labs(
        title = "Puntos personales acumulados",
        subtitle = "Comparativa por torneo continental de selecciones",
        x = "Torneo",
        y = "Puntos",
        fill = "Jugadores",
        caption = "Datos al 31 de diciembre de 2024"
    ) +
    theme_few() +
    theme(
        axis.text.x = element_text(angle = 0, hjust = 0.5, size = 7),
        plot.title = element_text(hjust = 0.5)
    )

# Mostrar gráfico
print(con_s)

# Guardar gráfico
ggsave(
    filename = "outputs/plots/r/puntuaciones/comparativas/por_torneo/2024/r_comparativa_puntos_por_continental_selecciones_2024.png",
    plot = con_s,
    width = 12,
    height = 10,
    units = "in",
    dpi = 600
)

# Datos limpios
# Puntuaciones por liga obtenidos por cada jugador durante 2024
write.csv(filtro_continental_selecciones_total, here("data", "processed", "r", "metricas_comparativas", "puntuaciones", "por_torneo", "totales", "2024", "puntuaciones_por__liga_continental_selecciones_2024.csv"))
write.csv(suma_puntos_por_torneo_continental_selecciones, here("data", "processed", "r", "metricas_comparativas", "puntuaciones", "por_torneo", "principales", "2024", "puntuaciones_por_ligas_continentales_selecciones_principales.csv"))