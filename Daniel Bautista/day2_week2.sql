SELECT 
    a.RUNNER_ID,
    SUM(
        CASE
            WHEN a.distance LIKE '%km' THEN CAST(LEFT(a.distance, POSITION('km' IN a.distance) - 1) AS DECIMAL(10,1))
            WHEN a.distance IS NULL OR a.distance = 'null' THEN 0
            ELSE CAST(a.distance AS DECIMAL(10,1))
        END
    ) AS distancia_acumulada_km,
    SUM(
        CASE
            WHEN a.duration LIKE '%min%' THEN CAST(LEFT(a.duration, POSITION('min' IN a.duration) - 1) AS INT)
            WHEN a.duration IS NULL OR a.duration = 'null' THEN 0
            ELSE CAST(a.duration AS INT)
        END
    ) / 60.0 AS tiempo_horas,
    SUM(
        CASE
            WHEN a.distance LIKE '%km' THEN CAST(LEFT(a.distance, POSITION('km' IN a.distance) - 1) AS DECIMAL(10,1))
            WHEN a.distance IS NULL OR a.distance = 'null' THEN 0
            ELSE CAST(a.distance AS DECIMAL(10,1))
        END
    ) / (SUM(
            CASE
                WHEN a.duration LIKE '%min%' THEN CAST(LEFT(a.duration, POSITION('min' IN a.duration) - 1) AS INT)
                WHEN a.duration IS NULL OR a.duration = 'null' THEN 0
                ELSE CAST(a.duration AS INT)
            END
        ) / 60.0) AS velocidad_promedio_km_h
FROM 
    SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS AS a
GROUP BY 
    a.runner_id;
