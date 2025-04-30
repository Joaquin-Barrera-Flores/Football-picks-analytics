-- Uso de UNION ALL command para COMBINAR los resultados de dos SELECT statements
/* Nota: UNION ALL necesita tener el mismo numero de columnas, identificadas de la misma manera., para poder funionar.
Ejemplo: 'Local' y 'Visitante' necesitan tener el mismo nombre para ser combinadas */
SELECT
    equipo,
    COUNT(*) AS total
FROM
    (
        SELECT
            Local AS equipo
        FROM
            los - picks - del - dia.puntuacion.puntos_2024
        UNION ALL
        /* Combino dos columnas para contar cuántas veces un mismo valor aparece en ellas */
        SELECT
            Visitante AS equipo
        FROM
            los - picks - del - dia.puntuacion.puntos_2024
    ) AS union_loc_vis
WHERE
    equipo IS NOT NULL
GROUP BY
    equipo
ORDER BY
    total DESC,
    equipo ASC