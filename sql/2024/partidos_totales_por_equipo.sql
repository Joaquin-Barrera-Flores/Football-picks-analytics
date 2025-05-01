/* DESCRIPCIÓN:

Este código SQL cuenta cuántas veces aparece cada equipo como Local o Visitante en la tabla puntos_2024. 
Para ello:
1. Combina las columnas Local y Visitante en una sola columna llamada equipo usando UNION ALL.
2. Filtra valores nulos (equipo IS NOT NULL).
3. Agrupa por equipo y cuenta las apariciones.
4. Ordena los resultados por la cantidad de apariciones de forma descendente y luego alfabéticamente.

RESULTADO: Una lista de equipos con el número total de veces que han participado, ya sea como local o visitante.

UTILIDAD: Capacidad para extraer y consolidar información relevante desde múltiples columnas de una base de datos, 
aplicando filtros y funciones agregadas para construir reportes claros y significativos.

Nota personal: UNION ALL necesita tener el mismo numero de columnas, identificadas de la misma manera, para poder 
funcionar. Ejemplo: 'Local' y 'Visitante' necesitan tener el mismo nombre para ser combinadas */
SELECT
    equipo,
    COUNT(*) AS total
/* Se genera una tabla que implemente UNION ALL para combinar dos columnas relacionadas de una misma tabla */
FROM 
    (
        SELECT
            Local AS equipo
        FROM
            los - picks - del - dia.puntuacion.puntos_2024
        /* Combino dos columnas para contar cuántas veces un mismo valor aparece en ellas */
        UNION ALL
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