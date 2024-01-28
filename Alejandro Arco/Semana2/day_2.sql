/* Day 2
    ¿Cuál es la distancia acumulada de reparto de cada runner?
    ¿Y la velocidad promedio (en Km/h)?
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE02;

WITH RUNNER_ORDERS_NULLS AS (
    SELECT
        ORDER_ID,
        RUNNER_ID, 
        DECODE(PICKUP_TIME,'null',NULL,PICKUP_TIME) AS PICKUP_TIME,
        DECODE(DISTANCE,'null',NULL,DISTANCE) AS DISTANCE,
        DECODE(DURATION,'null',NULL,DURATION) AS DURATION, 
        DECODE(CANCELLATION,'null',NULL,'',NULL,CANCELLATION) AS CANCELLATION
    FROM RUNNER_ORDERS
),

RUNNER_ORDERS_CLEAN AS (
    SELECT
        ORDER_ID,
        RUNNER_ID, 
        PICKUP_TIME,
        TRIM(REPLACE(DISTANCE, 'km', ''))::FLOAT AS DISTANCE_IN_KM,
        SPLIT(TRIM(DURATION),'m')[0]::INTEGER AS DURATION_IN_MINUTES,
        CANCELLATION
    FROM RUNNER_ORDERS_NULLS
)


SELECT 
    R.RUNNER_ID,
    NVL(SUM(RO.DISTANCE_IN_KM),0) AS TOTAL_DISTANCE_IN_KM,
    AVG(DISTANCE_IN_KM/(RO.DURATION_IN_MINUTES/60))::NUMBER(5,2) AS AVG_VELOCITY -- null para el que no ha hecho pedidos
FROM RUNNER_ORDERS_CLEAN AS RO
RIGHT JOIN RUNNERS AS R
    ON RO.RUNNER_ID = R.RUNNER_ID
GROUP BY R.RUNNER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
