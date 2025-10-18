#SECCIÓN: CARGA DE PAQUETES Y DATOS

if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, dplyr, ggplot2, httpgd, tidyr, readr, lubridate, purrr, rlang, ggthemes)

url <- "https://raw.githubusercontent.com/Joaquin-Barrera-Flores/Football-picks-analytics/main/data/raw/acumulados_mensuales/2024/noviembre_2024.csv"
acumulado <- read.csv(url)

# SECCIÓN: PREPARACIÓN DE DATOS

acumulado <- dmy(acumulado$noviembre)

# SECCIÓN: CONFIGURACIÓN
jugadores <- c("barrera", "chochos", "dani", "velez")

nombres_jugadores <- c("barrera" = "Fernando Barrera", "chochos" = "César Reyes", "dani" = "Daniel Ruíz", "velez" = "Antonio Vélez")

colores <- (
    "Fernando Barrera" = "#49525e",
    "César Reyes" = "#9b93c9",
    "Daniel Ruíz" = "#fdb052",
    "Antonio Velez" = "#59acbe"
    )
    
ajustes_texto <- list(
     barrera = list(desp_dias = 2, desp_pct = 0),
    chochos = list(desp_dias = 2, desp_pct = 0),
    dani    = list(desp_dias = 1, desp_pct = 0),
    velez   = list(desp_dias = 4, desp_pct = 0)
)

# SECCION CALCULOS INTERMEDIOS

maximos <- map(jugadores, ~ acumulado[which.max(acumulado[[paste0("puntos_", .x)]]), ])
names(maximos) <- jugadores

ultimos <- map(jugadores, ~ acumulado %>%
    slice_tail(n = 1) %>%
    select(noviembre, puntos = all_of(paste0("puntos_", .x))))
names(ultimos) <- jugadores
    
maximos_ajustados <- map(jugadores, ~ {
    maximo <- maximos[[.x]]
    puntos_jugador <- paste0("puntos_", .x)
    })#


