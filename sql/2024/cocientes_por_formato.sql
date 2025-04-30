WITH
    barrera AS (
        SELECT
            expected_data_barrera.formato AS formato,
            total_formato.partidos, --
            COUNT(expected_data_barrera.formato) AS contestados_barrera,
            SUM(expected_data_barrera.puntos_barrera) AS puntos_barrera, --
            ROUND(
                SUM(expected_data_barrera.puntos_barrera) / COUNT(total_formato.formato),
                3
            ) AS expected_rating_barrera,
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
        FROM
            (
                SELECT
                    formato,
                    COUNT(formato) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    formato
            ) AS total_formato
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_barrera ON expected_data_barrera.formato = total_formato.formato
        WHERE
            expected_data_barrera.estado_barrera = "Contestado"
        GROUP BY
            expected_data_barrera.formato,
            total_formato.partidos
        ORDER BY
            total_formato.partidos DESC
    ),
    chochos AS (
        SELECT
            expected_data_chochos.formato AS formato,
            total_formato.partidos,
            COUNT(expected_data_chochos.formato) AS contestados_chochos,
            SUM(expected_data_chochos.puntos_chochos) AS puntos_chochos,
            ROUND(
                SUM(expected_data_chochos.puntos_chochos) / COUNT(total_formato.formato),
                3
            ) AS expected_rating_chochos,
            (
                SELECT
                    ROUND(AVG(puntos_chochos), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_chochos,
            (
                SELECT
                    ROUND(AVG(puntos_chochos), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                WHERE
                    estado_chochos = 'Contestado'
            ) AS expected_rating_gral_chochos
        FROM
            (
                SELECT
                    formato,
                    COUNT(formato) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    formato
            ) AS total_formato
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_chochos ON expected_data_chochos.formato = total_formato.formato
        WHERE
            expected_data_chochos.estado_chochos = "Contestado"
        GROUP BY
            expected_data_chochos.formato,
            total_formato.partidos
        ORDER BY
            total_formato.partidos DESC
    ),
    dani AS (
        SELECT
            expected_data_dani.formato AS formato,
            total_formato.partidos,
            COUNT(expected_data_dani.formato) AS contestados_dani,
            SUM(expected_data_dani.puntos_dani) AS puntos_dani,
            ROUND(
                SUM(expected_data_dani.puntos_dani) / COUNT(total_formato.Formato),
                3
            ) AS expected_rating_dani,
            (
                SELECT
                    ROUND(AVG(puntos_dani), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_dani,
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
                SELECT
                    formato,
                    COUNT(formato) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    formato
            ) AS total_formato
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_dani ON expected_data_dani.formato = total_formato.formato
        WHERE
            expected_data_dani.estado_dani = "Contestado"
        GROUP BY
            expected_data_dani.formato,
            total_formato.partidos
        ORDER BY
            total_formato.partidos DESC
    ),
    velez AS (
        SELECT
            expected_data_velez.formato AS formato,
            total_formato.partidos,
            COUNT(expected_data_velez.formato) AS contestados_velez,
            SUM(expected_data_velez.puntos_velez) AS puntos_velez,
            ROUND(
                SUM(expected_data_velez.puntos_velez) / COUNT(total_formato.formato),
                3
            ) AS expected_rating_velez,
            (
                SELECT
                    ROUND(AVG(puntos_velez), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_velez,
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
                SELECT
                    formato,
                    COUNT(formato) AS partidos
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
                GROUP BY
                    formato
            ) AS total_formato
            JOIN los - picks - del - dia.puntuacion.puntos_2024 AS expected_data_velez ON expected_data_velez.formato = total_formato.formato
        WHERE
            expected_data_velez.estado_velez = "Contestado"
        GROUP BY
            expected_data_velez.formato,
            total_formato.partidos
        ORDER BY
            total_formato.partidos DESC
    ),
    puntos_y_ratings_reales AS (
        SELECT
            formato,
            COUNT(formato) AS partidos,
            SUM(puntos_barrera) as puntos_barrera,
            ROUND(SUM(puntos_barrera) / COUNT(formato), 3) AS rating_barrera,
            (
                SELECT
                    ROUND(AVG(puntos_barrera), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_barrera,
            SUM(puntos_chochos) as puntos_chochos,
            ROUND(SUM(puntos_chochos) / COUNT(formato), 3) AS rating_chochos,
            (
                SELECT
                    ROUND(AVG(puntos_chochos), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_chochos,
            SUM(puntos_dani) as puntos_dani,
            ROUND(SUM(puntos_dani) / COUNT(formato), 3) AS rating_dani,
            (
                SELECT
                    ROUND(AVG(puntos_dani), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_dani,
            SUM(puntos_velez) as puntos_velez,
            ROUND(SUM(puntos_velez) / COUNT(formato), 3) AS rating_velez,
            (
                SELECT
                    ROUND(AVG(puntos_velez), 3)
                FROM
                    los - picks - del - dia.puntuacion.puntos_2024
            ) AS rating_gral_velez
        FROM
            los - picks - del - dia.puntuacion.puntos_2024
        GROUP BY
            formato
        ORDER BY
            partidos DESC
    )
SELECT
    puntos_y_ratings_reales.formato,
    puntos_y_ratings_reales.partidos,
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
    ) AS expected_points_barrera,
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
    ) AS expected_points_chochos,
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
    ) AS expected_points_dani,
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
    ROUND(
        (
            puntos_y_ratings_reales.rating_barrera + puntos_y_ratings_reales.rating_chochos + puntos_y_ratings_reales.rating_dani + puntos_y_ratings_reales.rating_velez
        ) / 4,
        3
    ) AS rating_grupal_formato,
    ROUND(
        (
            puntos_y_ratings_reales.rating_gral_barrera + puntos_y_ratings_reales.rating_gral_chochos + puntos_y_ratings_reales.rating_gral_dani + puntos_y_ratings_reales.rating_gral_velez
        ) / 4,
        3
    ) AS rating_grupal_gral,
FROM
    puntos_y_ratings_reales
    JOIN barrera ON puntos_y_ratings_reales.formato = barrera.formato
    JOIN chochos ON barrera.formato = chochos.formato
    JOIN dani ON chochos.formato = dani.formato
    JOIN velez ON dani.formato = velez.formato
ORDER BY
    Partidos DESC;