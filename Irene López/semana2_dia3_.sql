-- Una pizza MEAT LOVERS cuesta 12€ y una VEGETARIANA 10€. Cada ingrediente extra supone 1€ adicional.
-- Por otro lado, cada corredor se le paga 0.30€/km recorrido.
-- ¿Cuánto dinero le sobra a Giuseppe después de estas entregas?

-- CREAMOS UNA TABLA TEMPORALES CON LOS CAMPOS LIMPIOS
-- E INCLUIMOS EN ESTA TABLA A TODOS LOS CORREDORES, HAYAN HECHO O NO UN PEDIDO
CREATE OR REPLACE TEMPORARY TABLE T_RUNNER_ORDERS AS
SELECT
    ORDER_ID
    ,RUNNER_ID
    ,PICKUP_TIME
    ,CAST(REPLACE(
                REPLACE(
                    COALESCE(DISTANCE,'0'
                    ),'null','0'
                ),'km','') AS DECIMAL(4,2)) AS DISTANCE
    ,ROUND
        (CAST
            (REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            COALESCE(DURATION,'0'
                            ),'null','0'
                        ),'minutes',''
                    ),'minute',''
                ),'mins',''
            ) AS DECIMAL(4,2))/60,2) AS DURATION_H
    ,REPLACE(
        COALESCE(CANCELLATION,''
            ),'null','') AS CANCELLATION
FROM RUNNER_ORDERS RO
ORDER BY RUNNER_ID
;

CREATE OR REPLACE TEMPORARY TABLE T_CUSTOMER_ORDERS_SPLITTED AS
SELECT 
    ORDER_ID
    ,CUSTOMER_ID
    ,CO.PIZZA_ID
    ,C2.value::string AS EXTRAS_NEW
    ,ORDER_TIME
FROM CUSTOMER_ORDERS CO
  -- Función en Snowflake que te divide por delimitador que le digas y te añade una nueva columna con ese valor
    , LATERAL FLATTEN(input=>split(REPLACE(COALESCE(EXTRAS,''),'null',''), ',')) C2
;

SELECT * FROM ILOPEZ_SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS;

WITH
    ORDERS_PIZZA_NAME AS (
SELECT 
    TCO.ORDER_ID
    ,CUSTOMER_ID
    ,TCO.PIZZA_ID
    ,CASE
        WHEN CANCELLATION = '' AND 
            PIZZA_NAME = 'Meatlovers'  THEN 12
        WHEN CANCELLATION = '' AND 
            PIZZA_NAME = 'Vegetarian' THEN 10
        ELSE 0
    END AS BENEFICIO
    ,CASE
        WHEN CANCELLATION != '' AND 
             PIZZA_NAME = 'Meatlovers'  THEN 12
        WHEN CANCELLATION != '' AND 
             PIZZA_NAME = 'Vegetarian' THEN 10
        ELSE 0
    END AS PERDIDA
    ,CASE
        WHEN CANCELLATION = '' AND 
            EXTRAS != ''  THEN 1
        ELSE 0
    END AS EXTRA_BENEFICIO
    ,CASE
        WHEN CANCELLATION != '' AND 
            EXTRAS != ''  THEN 1
        ELSE 0
    END AS EXTRA_PERDIDA
FROM CUSTOMER_ORDERS TCO
JOIN PIZZA_NAMES PN
    ON TCO.PIZZA_ID=PN.PIZZA_ID
JOIN T_RUNNER_ORDERS TRO
    ON TCO.ORDER_ID=TRO.ORDER_ID
), DISTANCIA_RECORRIDA AS(
    SELECT 
        ORDER_ID
        ,DISTANCE
    FROM T_RUNNER_ORDERS
)
-- Teniendo encuenta que al hacer un pedido y cancelarlo, ya se había hecho la pizza y por tanto es una pérdida de dinero para el restaurante:
, SUMAS_TOTALES AS(
SELECT
    OPN.ORDER_ID
    ,SUM(BENEFICIO) AS BENEFICIO_T
    ,SUM(PERDIDA) AS PERDIDA_T
    ,SUM(EXTRA_BENEFICIO) AS EXTRA_BENEFICIO_T
    ,SUM(EXTRA_PERDIDA) AS EXTRA_PERDIDA_T
    ,ROUND(SUM(DISTANCE)*0.3,2) AS EUR_KM
    ,ROUND(BENEFICIO_T - PERDIDA_T + EXTRA_BENEFICIO_T - EXTRA_PERDIDA_T - EUR_KM,2) AS GANANCIAS_TOTALES
FROM ORDERS_PIZZA_NAME OPN
LEFT JOIN DISTANCIA_RECORRIDA DR
    ON OPN.ORDER_ID = DR.ORDER_ID
GROUP BY OPN.ORDER_ID
)

SELECT CONCAT(SUM(GANANCIAS_TOTALES),'€') GANANCIAS_FINALES
FROM SUMAS_TOTALES;
-- Sin tenerlo en cuenta:
, SUMAS_TOTALES AS(
SELECT
    OPN.ORDER_ID
    ,SUM(BENEFICIO) AS BENEFICIO_T
    ,SUM(EXTRA_BENEFICIO) AS EXTRA_BENEFICIO_T
    ,ROUND(SUM(DISTANCE)*0.3,2) AS EUR_KM
    ,ROUND(BENEFICIO_T + EXTRA_BENEFICIO_T - EUR_KM,2) AS GANANCIAS_TOTALES
FROM ORDERS_PIZZA_NAME OPN
LEFT JOIN DISTANCIA_RECORRIDA DR
    ON OPN.ORDER_ID = DR.ORDER_ID
GROUP BY OPN.ORDER_ID
)
SELECT CONCAT(SUM(GANANCIAS_TOTALES),'€') GANANCIAS_FINALES
FROM SUMAS_TOTALES;
