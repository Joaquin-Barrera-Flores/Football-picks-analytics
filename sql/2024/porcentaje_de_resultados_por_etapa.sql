/* DESCRIPCIÓN: 

Este código SQL genera un resumen por etapa y resultado de los partidos registrados en la tabla puntos_2024. 
En detalle:
1. Calcula cuántos partidos hay por etapa (partidos_por_etapa) en una subconsulta (c).
2. Une esa subconsulta con la tabla principal para obtener los resultados por etapa.
3. Agrupa por etapa y resultado, y cuenta cuántas veces ocurre cada resultado (partidos_por_resultado).
4. Calcula el porcentaje de cada tipo de resultado dentro de su etapa.
5. Ordena los resultados por cantidad total de partidos en la etapa (descendente), nombre de etapa (ascendente) 
y porcentaje del resultado (descendente).

RESULTADO: Una tabla que muestra por cada etapa, cada resultado posible, cuántas veces ocurrió, el total de 
partidos en esa etapa y el porcentaje que representa ese resultado. 

UTILIDAD: Experiencia en el diseño de consultas SQL complejas para generar reportes analíticos que combinan 
métricas absolutas y relativas, facilitando la toma de decisiones basada en datos.*/
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