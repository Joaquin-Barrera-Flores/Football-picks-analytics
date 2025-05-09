# Cargar paquetes
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate)

# Importar datos desde GitHub
url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/principales/puntos_2024.csv"
puntuacion <- read.csv(url)

filtro_copas_total <- puntuacion %>%
    mutate(torneo = ifelse(
        torneo == "The Custodian of the Two Holy Mosques' Cup",
        "King's Cup", torneo
    )) %>%
    filter(
        torneo %in% c(
            "Pokal", "EFL Cup", "Copa Colombia", "Coppa Italia",
            "Cuope de France", "Copa do Brasil", "Copa del Rey",
            "King's Cup", "Scottish Cup", "FA Cup",
            "Copa de la Liga Profesional"
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
suma_puntos_por_copa <- filtro_copas_total %>%
    mutate(Total_Puntos = Barrera + Chochos + Dani + Vélez) %>%
    filter(
        Total_Puntos >= 1) %>%
    arrange(desc(Total_Puntos)) %>%
    mutate(torneo = factor(torneo, levels = unique(torneo)))

# Transformar a formato largo
suma_larga <- suma_puntos_por_copa %>%
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
copa <- ggplot(suma_larga, aes(x = torneo, y = Puntos, fill = Jugador)) +
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
        subtitle = "Comparativa por copa",
        x = "Copa",
        y = "Puntos",
        fill = "Jugadores",
        caption = "Datos al 31 de diciembre de 2024"
    ) +
    theme_minimal() +
    theme(
        axis.text.x = element_text(angle = 0, hjust = 0.5, size = 7),
        plot.title = element_text(hjust = 0.5)
    )

# Mostrar gráfico
print(copa)

# Guardar gráfico
ggsave(
    filename = "outputs/plots/r/puntuaciones/comparativas/por_torneo/2024/r_comparativa_puntos_por_copa_2024.png",
    plot = copa,
    width = 18,
    height = 10,
    units = "in",
    dpi = 600
)

# Datos limpios
# Puntuaciones por liga obtenidos por cada jugador durante 2024
write.csv(filtro_copas_total, here("data", "processed", "r", "metricas_comparativas","puntuaciones", "por_torneo", "totales", "2024", "puntuaciones_por_copa_2024.csv"))
write.csv(suma_puntos_por_copa, here("data", "processed", "r", "metricas_comparativas", "puntuaciones", "por_torneo", "principales", "2024", "puntuaciones_por_copas_principales_2024.csv"))