WITH RUNNER_ORDERS_CLEAN AS 
(
SELECT 
    ORDER_ID,
    RUNNER_ID,
    DECODE(PICKUP_TIME,'',NULL,'null',NULL,PICKUP_TIME) as PICKUP_TIME,
    TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) AS DISTANCE_KM,
    TRY_CAST(REGEXP_REPLACE(DURATION, '[a-zA-Z]', '') AS NUMBER) AS DURATION_MIN,
    DECODE(CANCELLATION,'',NULL,'null',NULL,CANCELLATION) as CANCELLATION
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
) --Limpieza de datos de la tablla runner_orders
SELECT 
    A.RUNNER_ID, 
    NVL(SUM(DISTANCE_KM),0) AS DISTANCIA_TOTAL,
    NVL(AVG(DISTANCE_KM/(DURATION_MIN/60)),0) AS VELOCIDAD_KM_H
FROM SQL_EN_LLAMAS.CASE02.RUNNERS A
LEFT JOIN RUNNER_ORDERS_CLEAN B
    ON (A.RUNNER_ID=B.RUNNER_ID)
--WHERE CANCELLATION IS NULL
GROUP BY 1;