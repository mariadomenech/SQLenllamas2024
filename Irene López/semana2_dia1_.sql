--///------------------------------------
--// DÍA 1
--///------------------------------------
-- ¿Cuántos pedidos y cuántas pizzas se han entregado con éxito por cada runner, cuál es su porcentaje de éxito de cada runner?
-- ¿Qué porcentaje de las pizzas entregadas tenía modificaciones?

-- CREAMOS DOS TABLAS TEMPORALES CON LOS CAMPOS LIMPIOS
CREATE OR REPLACE TEMPORARY TABLE T_CUSTOMER_ORDERS AS
SELECT 
    ORDER_ID
    ,CUSTOMER_ID
    ,PIZZA_ID
    ,REPLACE(COALESCE(EXCLUSIONS,''),'null','') AS EXCLUSIONS
    ,REPLACE(COALESCE(EXTRAS,''),'null','') AS EXTRAS
    ,ORDER_TIME
FROM CUSTOMER_ORDERS;

-- INCLUIMOS EN ESTA TABLA A TODOS LOS CORREDORES, HAYAN HECHO O NO UN PEDIDO
CREATE OR REPLACE TEMPORARY TABLE T_RUNNER_ORDERS AS
SELECT
    ORDER_ID
    ,R.RUNNER_ID
    ,PICKUP_TIME
    ,REPLACE(REPLACE(COALESCE(DISTANCE,''),'null',''),'km','') AS DISTANCE
    ,REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(DURATION,''),'null',''),'minutes',''),'minute',''),'mins','') AS DURATION
    ,REPLACE(COALESCE(CANCELLATION,''),'null','') AS CANCELLATION
FROM RUNNER_ORDERS RO
    RIGHT JOIN RUNNERS R
    ON RO.RUNNER_ID = R.RUNNER_ID
;

-- SQL
--____________________________________________________________________________________
WITH PEDIDOS_PIZZAS_TOTALES AS (
SELECT 
    RUNNER_ID
    , COUNT(DISTINCT TCO.ORDER_ID) PEDIDOS_TOTALES
    , COUNT(PIZZA_ID) PIZZAS_TOTALES
FROM T_RUNNER_ORDERS TRO 
    LEFT JOIN T_CUSTOMER_ORDERS TCO
        ON TCO.ORDER_ID = TRO.ORDER_ID
GROUP BY
    RUNNER_ID
ORDER BY RUNNER_ID
)
, PEDIDOS_PIZZAS_OK AS(
SELECT 
    RUNNER_ID
    , COUNT(DISTINCT TCO.ORDER_ID) PEDIDOS_OK
    , COUNT(PIZZA_ID) PIZZA_OK
FROM T_RUNNER_ORDERS TRO 
    LEFT JOIN T_CUSTOMER_ORDERS TCO
        ON TCO.ORDER_ID = TRO.ORDER_ID
WHERE
    CANCELLATION = ''
GROUP BY
    RUNNER_ID
ORDER BY RUNNER_ID
)
,PIZZAS_MODIF AS (
    SELECT 
        RUNNER_ID
        ,COUNT(PIZZA_ID) PIZZA_MODIF
    FROM T_RUNNER_ORDERS TRO 
        LEFT JOIN T_CUSTOMER_ORDERS TCO
            ON TCO.ORDER_ID = TRO.ORDER_ID
    WHERE
        (EXCLUSIONS != '' OR EXTRAS != '') AND
        CANCELLATION = ''
    GROUP BY
         RUNNER_ID
    ORDER BY RUNNER_ID
)
SELECT
    PT.RUNNER_ID
    , PEDIDOS_OK
    , PIZZA_OK
    , COALESCE(ROUND(PEDIDOS_OK*100/NULLIF(PEDIDOS_TOTALES,0),2),0) AS PCT_PEDIDOS_OK
    , COALESCE(ROUND(PIZZA_MODIF*100/NULLIF(PIZZA_OK,0),2),0) AS PCT_PIZZAS_OK_MOD
FROM PEDIDOS_PIZZAS_OK PO
    LEFT JOIN PEDIDOS_PIZZAS_TOTALES PT
        ON PT.RUNNER_ID = PO.RUNNER_ID
    LEFT JOIN PIZZAS_MODIF PM
        ON PT.RUNNER_ID = PM.RUNNER_ID
;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto! Y muy limpio el resultado final.

*/
