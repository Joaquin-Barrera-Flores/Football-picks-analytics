/* DESCRIPCIÓN:
Extrae los puntajes máximos diarios por usuario (barrera, chochos, dani, velez) desde la tabla puntos_dia_2024, 
solo si su cociente (porcentaje de efectividad) es 100% (cociente_x = 1).

1. Genera consultas individuales para cada usuario ordenadas por puntaje máximo (MAX).
En una segunda parte más completa:
2. Usa CTEs (Common Table Expressions) para encapsular esas consultas y aplicar un filtro por puntaje mínimo 
(HAVING).
3. Une estas CTEs con la tabla principal a través de LEFT JOIN para consolidar los puntajes por fecha.
4. Usa COALESCE y CAST para mostrar “n/a” en lugar de NULL, asegurando un reporte legible. 

RESULTADO: Reporte de máximos puntajes individuales en un día, filtrado por rendimiento perfecto y formateado 
para lectura clara.

UTILIDAD: Consulta avanzada que identifica y consolida los máximos puntajes diarios por usuario solo cuando 
tienen un rendimiento perfecto. Uso de CTEs, joins condicionales y tratamiento de valores nulos para generar 
reportes limpios y precisos, facilitando la evaluación individual de desempeño. */

/* Tablas individuales con puntajes sobre rating 100% ordenadas DESC */
-- Barrera
SELECT
    Fecha,
    MAX(puntos_barrera) AS max_barrera
FROM
    los - picks - del - dia.puntos_dia.puntos_dia_2024
WHERE
    cociente_barrera = 1
GROUP BY
    fecha
ORDER BY
    max_barrera desc;

-- Chochos
SELECT
    fecha,
    MAX(puntos_chochos) AS max_chochos
FROM
    los - picks - del - dia.puntos_dia.puntos_dia_2024
WHERE
    cociente_chochos = 1
GROUP BY
    fecha
ORDER BY
    max_chochos desc;

-- Dani
SELECT
    fecha,
    MAX(puntos_dani) AS max_dani
FROM
    los - picks - del - dia.puntos_dia.puntos_dia_2024
WHERE
    cociente_dani = 1
GROUP BY
    fecha
ORDER BY
    max_dani desc;

--Velez
SELECT
    fecha,
    MAX(puntos_velez) AS max_velez
FROM
    los - picks - del - dia.puntos_dia.puntos_dia_2024
WHERE
    cociente_velez = 1
GROUP BY
    fecha
ORDER BY
    max_velez desc;

/* Tablas individuales con las puntuaciones más altas, 
previo calculo de porcentaje sobre 100% */
WITH
    barrera AS (
        SELECT
            fecha,
            MAX(puntos_barrera) AS max_barrera
        FROM
            los - picks - del - dia.puntos_dia.puntos_dia_2024
        WHERE
            cociente_barrera = 1
        GROUP BY
            fecha
        HAVING
            max_barrera >= 5 /* Variara, dependiendo los resultados de su tabla superior asociada */
        ORDER BY
            max_barrera desc
    ),
    chochos AS (
        SELECT
            fecha,
            MAX(puntos_chochos) AS max_chochos
        FROM
            los - picks - del - dia.puntos_dia.puntos_dia_2024
        WHERE
            cociente_chochos = 1
        GROUP BY
            fecha
        HAVING
            max_chochos >= 9 /* Variara, dependiendo los resultados de su tabla superior asociada */
        ORDER BY
            max_chochos desc
    ),
    dani AS (
        SELECT
            fecha,
            MAX(puntos_dani) AS max_dani
        FROM
            los - picks - del - dia.puntos_dia.puntos_dia_2024
        WHERE
            cociente_dani = 1
        GROUP BY
            fecha
        HAVING
            max_dani >= 5 /* Variara, dependiendo los resultados de su tabla superior asociada */
        ORDER BY
            max_dani desc
    ),
    velez AS (
        SELECT
            fecha,
            MAX(puntos_velez) AS max_velez
        FROM
            los - picks - del - dia.puntos_dia.puntos_dia_2024
        WHERE
            cociente_velez = 1
        GROUP BY
            fecha
        HAVING
            max_velez >= 6 /* Variara, dependiendo los resultados de su tabla superior asociada */
        ORDER BY
            max_velez desc
    )
SELECT
    pd.fecha,
    /* No es posible usar CAST en este caso porque hace una sustitución de valores a partir de IF/THEN,
    haciendo necesario definir el sustituto para cada valor o grupo de valores. COALESCE devuelve un 
    valor determinado en caso de un NULL*/
    COALESCE(CAST(b.max_barrera AS STRING), "n/a") AS puntos_barrera,
    COALESCE(CAST(c.max_chochos AS STRING), "n/a") AS puntos_chochos,
    COALESCE(CAST(d.max_dani AS STRING), "n/a") AS puntos_dani,
    COALESCE(CAST(v.max_velez AS STRING), "n/a") AS puntos_velez
FROM
    los - picks - del - dia.puntos_dia.puntos_dia_2024 AS pd
    LEFT JOIN barrera AS b ON pd.fecha = b.fecha
    LEFT JOIN chochos AS c ON pd.fecha = c.fecha
    LEFT JOIN dani AS d ON pd.fecha = d.fecha
    LEFT JOIN velez AS v ON pd.fecha = v.fecha
WHERE
    b.max_barrera IS NOT NULL
    OR c.max_chochos IS NOT NULL
    OR d.max_dani IS NOT NULL
    OR v.max_velez IS NOT NULL