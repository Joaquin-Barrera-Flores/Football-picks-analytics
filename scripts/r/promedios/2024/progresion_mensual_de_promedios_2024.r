# 0. Establecer el working directory adecuado automáticamente
# if (!grepl("Football-picks-analytics", getwd())) {
#   setwd("~/Football-picks-analytics")
# }

# Cargar paquetes
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, ggthemes)

# 3. (Personal) Importar y reconocer el archivo
# acumulado <- read.csv(
#   here("data", "raw", "principales", "puntos_2024.csv"))

# 3. (Visitantes) Importar y reconocer el archivo
url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/principales/2024/puntos_2024.csv"
puntuacion <- read.csv(url)

# Procesar datos
prom_mensual <- puntuacion %>%
    mutate(
        fecha = dmy(fecha),
        mes = floor_date(fecha, "month")
    ) %>%
    group_by(mes) %>%
    summarize(
        prom_Barrera = mean(puntos_barrera, na.rm = TRUE),
        prom_Chochos = mean(puntos_chochos, na.rm = TRUE),
        prom_Dani = mean(puntos_dani, na.rm = TRUE),
        prom_Velez = mean(puntos_velez, na.rm = TRUE)
    )

# Último punto
last_points <- prom_mensual %>% slice_tail(n = 1)

# Iniciar visor
hgd()
hgd_browse()

# Gráfica
A <- ggplot(prom_mensual, aes(x = mes)) +
    geom_line(aes(y = prom_Barrera, color = "Barrera"), linewidth = 0.3) +
    geom_line(aes(y = prom_Chochos, color = "Chochos"), linewidth = 0.3) +
    geom_line(aes(y = prom_Dani, color = "Dani"), linewidth = 0.3) +
    geom_line(aes(y = prom_Velez, color = "Vélez"), linewidth = 0.3) +
    geom_point(aes(y = prom_Barrera, color = "Barrera"), size = 2, show.legend = FALSE) +
    geom_point(aes(y = prom_Chochos, color = "Chochos"), size = 2, show.legend = FALSE) +
    geom_point(aes(y = prom_Dani, color = "Dani"), size = 2, show.legend = FALSE) +
    geom_point(aes(y = prom_Velez, color = "Vélez"), size = 2, show.legend = FALSE) +
    geom_text(data = last_points, aes(x = mes + 15, y = prom_Barrera, label = round(prom_Barrera, 2), color = "Barrera"), size = 3, vjust = 1, hjust = 0, show.legend = FALSE) +
    geom_text(data = last_points, aes(x = mes + 15, y = prom_Chochos, label = round(prom_Chochos, 2), color = "Chochos"), size = 3, vjust = 0, hjust = 0, show.legend = FALSE) +
    geom_text(data = last_points, aes(x = mes + 15, y = prom_Dani, label = round(prom_Dani, 2), color = "Dani"), size = 3, vjust = -1, hjust = 0, show.legend = FALSE) +
    geom_text(data = last_points, aes(x = mes + 15, y = prom_Velez, label = round(prom_Velez, 2), color = "Vélez"), size = 3, vjust = 0.5, hjust = 0, show.legend = FALSE) +
    labs(
        title = "Progresión de ratings",
        subtitle = "Con base en los promedios mensuales",
        x = "Meses",
        y = "Puntos",
        color = "Jugador",
        caption = "Datos a 31 de diciembre de 2024"
    ) +
    scale_color_manual(values = c(
        "Barrera" = "#49525e",
        "Chochos" = "#9b93c9",
        "Dani" = "#fdb052",
        "Vélez" = "#59acbe"
    )) +
    scale_x_date(date_breaks = "1 month", date_labels = "%b") +
    theme_few() +
    theme(
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)
    )

# Mostrar gráfica
print(A)

# 10. Guardar la gráfica
ggsave(
    filename = "outputs/plots/r/promedios/generales/2024/r_progresion_mensual_de_promedios_2024.png",
    plot = A,
    width = 12,
    height = 8,
    units = "in",
    dpi = 600
    )

# 11. Datos limpios
# Maximo puntaje anual, y día alcanzado, de cada jugador
write.csv(prom_mensual, here("data", "processed", "r", "metricas_comparativas", "promedios", "2024", "promedios_mensuales_2024.csv"))
