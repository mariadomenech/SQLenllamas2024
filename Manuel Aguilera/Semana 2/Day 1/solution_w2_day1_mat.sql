WITH RUNNER_ORDERS_CLEAN AS 
(
SELECT 
    ORDER_ID,
    RUNNER_ID,
    CASE 
        WHEN PICKUP_TIME='null' OR PICKUP_TIME='' THEN null
        ELSE PICKUP_TIME
    END AS PICKUP_TIME,
    CASE 
        WHEN DISTANCE='null' OR DISTANCE ='' THEN null
        ELSE TRY_CAST(REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') AS NUMBER(10, 2)) 
    END AS DISTANCE_KM,
    CASE 
        WHEN DURATION='null' OR DURATION = '' THEN null
        ELSE TRY_CAST(REGEXP_REPLACE(DURATION, '[a-zA-Z]', '') AS NUMBER) 
    END AS DURATION_MIN,
    CASE 
        WHEN CANCELLATION='null' OR CANCELLATION='' THEN null
        ELSE CANCELLATION 
    END AS CANCELLATION
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
), --Limpieza de datos de la tablla runner_orders
CUSTOMER_ORDERS_CLEAN AS
(
SELECT 
    ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
    CASE 
        WHEN EXCLUSIONS='null' or EXCLUSIONS='' THEN null
        ELSE EXCLUSIONS
    END AS EXCLUSIONS, 
    CASE 
        WHEN EXTRAS='null' or EXTRAS='' THEN null
        ELSE EXTRAS
    END AS EXTRAS
FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
) --Limpieza de datos de la tablla customer_orders
SELECT RUNNER_ID,
COUNT(DISTINCT CASE
                    WHEN CANCELLATION IS NULL THEN A.ORDER_ID
                END) AS PEDIDOS_EXITOSOS, 
        -- Cuento los distintos ORDER_ID siempre que no haya sido CANCELADO el pedido
 COUNT (CASE
            WHEN CANCELLATION IS NULL THEN 1
        END) AS PIZZAS_EXITOSAS,
       -- Cuanto las distintas filas que tiene siempre que el pedido no haya sido CANCELADO, que van a ser las pizzas pedidas 
       (100 * COUNT(DISTINCT CASE
                                 WHEN CANCELLATION IS NULL THEN A.ORDER_ID
                             END)) / COUNT(DISTINCT A.ORDER_ID) AS PEDIDOS_EXITOSOS_PORCENTAJE, 
        --Divido los distintos ORDER_ID siempre que no haya sido CANCELADO el pedido por los pedidos totales y lo multiplico por 100 para sacar el porcentaje
 (100 * COUNT (CASE
                   WHEN CANCELLATION IS NULL
                        AND (EXCLUSIONS IS NOT NULL
                             OR EXTRAS IS NOT NULL) THEN 1 -- Casos en que las pizzas han sufrido modificaciones
               END)) / COUNT (CASE
                                  WHEN CANCELLATION IS NULL THEN 1
                              END) AS PIZZAS_MODIFICADAS_PORCENTAJE
                --Divido las pizzas modificadas por los pizzas totales y lo multiplico por 100 para sacar el porcentaje
FROM RUNNER_ORDERS_CLEAN A
INNER JOIN CUSTOMER_ORDERS_CLEAN B 
    ON (A.ORDER_ID=B.ORDER_ID)
GROUP BY 1;
