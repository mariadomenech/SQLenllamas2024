/*
Limpiamos las columnas distancia y duración casteándolas a number habiendo eliminado
previamente los caracteres no numéricos y cambiando los 'null' por '0'.
*/
WITH pedidos_limpios AS (
    SELECT 
        runner_id,
        TO_NUMBER(RTRIM(DECODE(distance, 'null', '0', distance), 'km'), 10, 2) AS clean_distance_km,
        TO_NUMBER(LEFT(DECODE(duration, 'null', '0', duration), 2), 10, 2) AS clean_duration_min
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
)
/*
Calculamos la distancia acumulada de cada rider y su velocidad media en km/h
*/
SELECT 
    r.runner_id,
    nvl(SUM(pl.clean_distance_km), 0) AS km_recorridos,
    ROUND(nvl(SUM(pl.clean_distance_km) / NULLIF(SUM(pl.clean_duration_min), 0) * 60, 0), 2) AS velocidad_media_km_h
FROM SQL_EN_LLAMAS.CASE02.RUNNERS r
LEFT JOIN pedidos_limpios pl
       ON r.runner_id = pl.runner_id
GROUP BY r.runner_id;
