/* Uso de: 
WITH clause como COMMON TABLE EXPRESSION (CTE) para generar una suquery (la cual funciona como una Derived Table) que puede ser referenciada múltiples veces en la main query. 
 */
/* Las CTEs de apellidos otorgan los datos en función de los partidos contestados;
Además, se agregan columnas para comparación de datos si se requiere extraer la query (señaladas con --)*/
WITH
    barrera AS (
        SELECT
            /* 3° Solicitar las columnas requeridas extrayéndolas de cada tabla con su id */
            expected_data_barrera.torneo AS torneo,
            total_torneo.partidos, --
            COUNT(expected_data_barrera.torneo) AS contestados_barrera,
            SUM(expected_data_barrera.puntos_barrera) AS puntos_barrera, --
            ROUND(
                SUM(expected_data_barrera.puntos_barrera) / COUNT(total_torneo.torneo),
                3
            ) AS expected_rating_barrera,
            /* 4° Especificamos Subqueries en SELECT para generar un valor que no sea afectado por la estructura o las formulas
            de la Outer Query */
            (
                SELECT
                    ROUND(AVG(puntos_barrera), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_barrera, --
            (
                SELECT
                    ROUND(AVG(puntos_barrera), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                WHERE
                    estado_barrera = 'Contestado'
            ) AS expected_rating_gral_barrera
            /* 1° Generar una Derived Table con una Subquery en FROM que dé los datos completos de la columna Torneo */
        FROM
            (
                SELECT --
                    torneo,
                    COUNT(torneo) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    torneo
            ) AS total_torneo
            /* 2° Establecer una JOIN que permita unir las columnas de la Derived Table y de la Tabla de Origen.
            Además, en este punto se generan los id's de cada tabla*/
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_barrera ON expected_data_barrera.torneo = total_torneo.torneo
            /* 5° Se completa el query estableciendo un filtro, agrupando las columnas no agregadas y ordenando */
        WHERE
            expected_data_barrera.estado_barrera = "Contestado"
        GROUP BY
            expected_data_barrera.torneo,
            total_torneo.partidos
        ORDER BY
            total_torneo.partidos DESC
    ),
    /* 6° Repetimos el proceso para el resto de las CTEs de apellidos */
    chochos AS (
        SELECT
            expected_data_chochos.torneo AS torneo,
            total_torneo.partidos, --
            COUNT(expected_data_chochos.torneo) AS contestados_chochos,
            SUM(expected_data_chochos.puntos_chochos) AS puntos_chochos, --
            ROUND(
                SUM(expected_data_chochos.puntos_barrera) / COUNT(total_torneo.torneo),
                3
            ) AS expected_rating_chochos,
            (
                SELECT
                    ROUND(AVG(puntos_chochos), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_chochos, --
            (
                SELECT
                    ROUND(AVG(puntos_chochos), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                WHERE
                    estado_barrera = 'Contestado'
            ) AS expected_rating_gral_chochos
        FROM
            (
                SELECT --
                    torneo,
                    COUNT(torneo) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    torneo
            ) AS total_torneo
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_chochos ON expected_data_chochos.torneo = total_torneo.torneo
        WHERE
            expected_data_chochos.estado_chochos = "Contestado"
        GROUP BY
            expected_data_chochos.torneo,
            total_torneo.partidos
        ORDER BY
            total_torneo.partidos DESC
    ),
    dani AS (
        SELECT
            expected_data_dani.torneo AS torneo,
            total_torneo.partidos, --
            COUNT(expected_data_dani.torneo) AS contestados_dani,
            SUM(expected_data_dani.puntos_dani) AS puntos_dani, --
            ROUND(
                SUM(expected_data_dani.puntos_dani) / COUNT(total_torneo.torneo),
                3
            ) AS expected_rating_dani,
            (
                SELECT
                    ROUND(AVG(puntos_dani), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_dani, --
            (
                SELECT
                    ROUND(AVG(puntos_dani), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                WHERE
                    estado_dani = 'Contestado'
            ) AS expected_rating_gral_dani
        FROM
            (
                SELECT --
                    torneo,
                    COUNT(torneo) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    torneo
            ) AS total_torneo
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_dani ON expected_data_dani.torneo = total_torneo.torneo
        WHERE
            expected_data_dani.estado_dani = "Contestado"
        GROUP BY
            expected_data_dani.torneo,
            total_torneo.partidos
        ORDER BY
            total_torneo.partidos DESC
    ),
    velez AS (
        SELECT
            expected_data_velez.torneo AS torneo,
            total_torneo.partidos, --
            COUNT(expected_data_velez.torneo) AS contestados_velez,
            SUM(expected_data_velez.puntos_velez) AS puntos_velez, --
            ROUND(
                SUM(expected_data_velez.puntos_velez) / COUNT(total_torneo.torneo),
                3
            ) AS expected_rating_velez,
            (
                SELECT
                    ROUND(AVG(puntos_velez), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_velez, --
            (
                SELECT
                    ROUND(AVG(puntos_velez), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                WHERE
                    estado_velez = 'Contestado'
            ) AS expected_rating_gral_velez
        FROM
            (
                SELECT --
                    torneo,
                    COUNT(torneo) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    torneo
            ) AS total_torneo
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_velez ON expected_data_velez.torneo = total_torneo.torneo
        WHERE
            expected_data_velez.estado_velez = "Contestado"
        GROUP BY
            expected_data_velez.torneo,
            total_torneo.partidos
        ORDER BY
            total_torneo.partidos DESC
    ),
    /* 7° Generar una CTE que entregue puntajes y ratings individuales reales. 
    Después de solicitar los dos valores generales se generan valores propios para un participante. Posteriormente se duplica
    y se sutituye la identidad para cada uno del resto de participantes */
    puntos_y_ratings_reales AS (
        SELECT
            torneo,
            COUNT(torneo) AS partidos,
            -- Primer participante
            SUM(puntos_barrera) as puntos_barrera,
            ROUND(SUM(puntos_barrera) / COUNT(torneo), 3) AS rating_barrera,
            (
                SELECT
                    ROUND(AVG(puntos_barrera), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_barrera,
            -- Segundo participante
            SUM(puntos_chochos) as puntos_chochos,
            ROUND(SUM(puntos_chochos) / COUNT(torneo), 3) AS rating_chochos,
            (
                SELECT
                    ROUND(AVG(puntos_chochos), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_chochos,
            -- Tercer participante
            SUM(puntos_dani) as puntos_dani,
            ROUND(SUM(puntos_dani) / COUNT(torneo), 3) AS rating_dani,
            (
                SELECT
                    ROUND(AVG(puntos_dani), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_dani,
            -- Cuarto participante
            SUM(puntos_velez) as puntos_velez,
            ROUND(SUM(puntos_velez) / COUNT(torneo), 3) AS rating_velez,
            (
                SELECT
                    ROUND(AVG(puntos_velez), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_velez
        FROM
            los - picks - del - dia.puntuacion.puntos_2024
        GROUP BY
            torneo
        ORDER BY
            partidos DESC
    )
    /* 8° La Query Principal va a solicitar las columnas necesarias de cada CTE a las cuales se les sumaran columnas dadas a partir de operaciones sobre elementos de una de la CTE 'puntos_y_ratings_reales' (señaladas con --) */
SELECT
    puntos_y_ratings_reales.torneo,
    puntos_y_ratings_reales.partidos,
    -- Primer participante
    puntos_y_ratings_reales.puntos_barrera,
    puntos_y_ratings_reales.rating_barrera,
    puntos_y_ratings_reales.rating_gral_barrera,
    barrera.contestados_barrera,
    barrera.expected_rating_barrera,
    barrera.expected_rating_gral_barrera,
    ROUND(
        (
            puntos_y_ratings_reales.partidos * barrera.expected_rating_barrera
        ),
        3
    ) AS expected_points_barrera, --
    -- Segundo participante
    puntos_y_ratings_reales.puntos_chochos,
    puntos_y_ratings_reales.rating_chochos,
    puntos_y_ratings_reales.rating_gral_chochos,
    chochos.contestados_chochos,
    chochos.expected_rating_chochos,
    chochos.expected_rating_gral_chochos,
    ROUND(
        (
            puntos_y_ratings_reales.partidos * chochos.expected_rating_chochos
        ),
        3
    ) AS expected_points_chochos, --
    -- Tercer participante
    puntos_y_ratings_reales.puntos_dani,
    puntos_y_ratings_reales.rating_dani,
    puntos_y_ratings_reales.rating_gral_dani,
    dani.contestados_dani,
    dani.expected_rating_dani,
    dani.expected_rating_gral_dani,
    ROUND(
        (
            puntos_y_ratings_reales.partidos * dani.expected_rating_dani
        ),
        3
    ) AS expected_points_dani, --
    -- Cuarto participante
    puntos_y_ratings_reales.puntos_velez,
    puntos_y_ratings_reales.rating_velez,
    puntos_y_ratings_reales.rating_gral_velez,
    velez.contestados_velez,
    velez.expected_rating_velez,
    velez.expected_rating_gral_velez,
    ROUND(
        (
            puntos_y_ratings_reales.partidos * velez.expected_rating_velez
        ),
        3
    ) AS expected_points_velez, --
    -- Suma de multiples columnas provenientes de distintas CTEs para ser divididas entre la cantidad total de dichas columnas 
    ROUND(
        (
            puntos_y_ratings_reales.rating_barrera + puntos_y_ratings_reales.rating_chochos + puntos_y_ratings_reales.rating_dani + puntos_y_ratings_reales.rating_velez
        ) / 4,
        3
    ) AS rating_grupal_torneo,
    ROUND(
        (
            puntos_y_ratings_reales.rating_gral_barrera + puntos_y_ratings_reales.rating_gral_chochos + puntos_y_ratings_reales.rating_gral_dani + puntos_y_ratings_reales.rating_gral_velez
        ) / 4,
        3
    ) AS rating_grupal_gral,
    /* 9° Formar las Joins que aseguren combinar de forma correcta todas las CTEs utilizadas */
FROM
    puntos_y_ratings_reales
    JOIN barrera ON puntos_y_ratings_reales.torneo = barrera.torneo
    JOIN chochos ON barrera.torneo = chochos.torneo
    JOIN dani ON chochos.torneo = dani.torneo
    JOIN velez ON dani.torneo = velez.torneo
ORDER BY
    Partidos DESC;