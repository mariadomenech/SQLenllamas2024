WITH primera AS (
    SELECT 
        b.runner_id AS corredor, 
        order_id,
        CASE WHEN distance = 'null' THEN '0'
            WHEN distance IS NULL THEN '0'
            WHEN distance = '' THEN '0'
            ELSE distance END AS distancia,
        CASE WHEN duration = 'null' THEN '0'
            WHEN duration IS NULL THEN '0'
            WHEN duration = '' THEN '0'
            ELSE duration END AS duracion
        
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS A
    FULL JOIN SQL_EN_LLAMAS.CASE02.RUNNERS B
        ON A.RUNNER_ID=B.RUNNER_ID
    ORDER BY B.RUNNER_ID, order_id
),

segunda AS (
    SELECT 
        corredor,
        TRIM(distancia, ' km') AS distancia_km,
        ROUND((TRIM(duracion, 'minutes')/60),4) AS duracion_horas
    FROM primera
    order by corredor
),

tercera AS (
    SELECT 
        corredor,
        distancia_km,
        duracion_horas,
        CASE WHEN duracion_horas = 0 THEN NULL
            WHEN distancia_km = 0 THEN NULL
            ELSE ROUND(distancia_km/duracion_horas,2) END AS velocidad_km_h
    FROM segunda
)

SELECT 
    corredor, 
    ROUND(AVG(velocidad_km_h),2) AS velocidad_media,
    SUM(distancia_km) AS distancia_acumulada
FROM tercera
GROUP BY corredor
ORDER BY corredor;
