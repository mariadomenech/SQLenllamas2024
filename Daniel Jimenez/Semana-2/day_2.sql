//¿Cual es la distancia acumulada de reparto de cada runner?¿y la velocidad promediokm/h?

WITH tabla_runner_limpita AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID 
        ,   CASE WHEN PICKUP_TIME = 'null' THEN NULL ELSE PICKUP_TIME END AS hora_recogida
        ,   CASE WHEN DISTANCE = 'null' THEN NULL ELSE DISTANCE END AS distancia
        ,   CASE WHEN DURATION = 'null' THEN NULL ELSE DURATION END AS duracion_runner
        ,   CASE WHEN CANCELLATION = 'null' OR CANCELLATION = '' THEN NULL ELSE CANCELLATION END AS pedido_cancelado
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
),
tabla_runner_sin_nulls AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID
        ,   hora_recogida
        ,   CAST(REGEXP_REPLACE(duracion_runner, '(minutes|mins|minute)', '') AS INTEGER) AS duracion_minutos
        ,   CAST(REPLACE(distancia, 'km', '') AS FLOAT) AS distancia_kilometros
        ,   pedido_cancelado
    FROM tabla_runner_limpita
)
SELECT  r.RUNNER_ID
    ,   COALESCE(SUM(tr.distancia_kilometros), 0) AS distancia_acumulada_reparto
    ,   ROUND(AVG(tr.distancia_kilometros / NULLIF(duracion_minutos, 0) * 60), 2) AS velocidad_promedia_kmh
FROM tabla_runner_sin_nulls tr
RIGHT JOIN SQL_EN_LLAMAS.CASE02.RUNNERS R
    ON tr.RUNNER_ID = r.RUNNER_ID
GROUP BY r.RUNNER_ID;
