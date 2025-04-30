SELECT
    a.etapa,
    a.resultado,
    COUNT(a.resultado) AS partidos_por_resultado,
    c.partidos_por_etapa,
    ROUND(
        COUNT(a.resultado) / (
            SELECT
                COUNT(b.etapa)
            FROM
                los - picks - del - dia.puntuacion.puntos_2024 b
            WHERE
                a.etapa = b.etapa
            GROUP BY
                etapa
        ) * 100,
        1
    ) AS porcentaje
FROM
    (
        SELECT
            etapa,
            COUNT(resultado) as partidos_por_etapa
        FROM
            los - picks - del - dia.puntuacion.puntos_2024
        GROUP BY
            etapa
    ) as c
    JOIN los - picks - del - dia.puntuacion.puntos_2024 a ON a.etapa = c.etapa
GROUP BY
    a.etapa,
    a.resultado,
    c.partidos_por_etapa
ORDER BY
    c.partidos_por_etapa DESC,
    a.etapa ASC,
    porcentaje DESC