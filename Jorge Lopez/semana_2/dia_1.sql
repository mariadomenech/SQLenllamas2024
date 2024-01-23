-------------------------------------------------------------------------------------
/* Dia 1 ¿Cuántos pedidos y cuántas pizas se han entregado con exito por cada runner 
¿Cuál es el porcentaje de éxito de cada runner?
¿Qué porcentaje de las pizzas entregadas tenían modificaciones? */

/* DISCLAIMER
  Te he dejado todo el proceso completo. Esta primera parte son las consultas de 
  ayuda para ir ojeando las tablas y los dos drop por si quería eliminar las temporales.
  Después tienes la creación y limpieza de cada tabla temporal y por último la consulta.
  Admito haber usado como ayuda la consulta de nuestro chat (evidentemente) y de chat gpt, 
  pero en este último caso solo para resolver errores en la creación de la consulta, 
  como "case when" mal formados, comas mal puestas y cosas así. 
  La lógica siempre la he ido aplicando yo. */

SELECT * FROM CASE02.CUSTOMER_ORDERS;
SELECT * FROM CASE02.RUNNER_ORDERS;
SELECT * FROM CASE02.RUNNERS;
SELECT * FROM CASE02.PIZZA_NAMES;
SELECT * FROM CASE02.PIZZA_RECIPES;
SELECT * FROM CASE02.PIZZA_TOPPINGS;
DROP TABLE IF EXISTS RUNNER_ORDERS_OK;
DROP TABLE IF EXISTS CUSTOMER_ORDERS_OK;

--------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE RUNNER_ORDERS_OK 
AS 
    SELECT * FROM CASE02.RUNNER_ORDERS;

UPDATE RUNNER_ORDERS_OK AS RO
SET 
    RO.PICKUP_TIME = NULL,
    RO.DURATION = NULL,
    RO.DISTANCE = NULL
WHERE 
    RO.PICKUP_TIME = 'null';

UPDATE RUNNER_ORDERS_OK AS RO
SET 
    RO.CANCELLATION = NULL
WHERE 
    RO.CANCELLATION = 'null' 
    OR RO.CANCELLATION = '';
    
--------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE CUSTOMER_ORDERS_OK 
AS 
    SELECT * FROM CASE02.CUSTOMER_ORDERS;

UPDATE CUSTOMER_ORDERS_OK AS CO
SET 
    CO.EXCLUSIONS = NULL
WHERE 
    CO.EXCLUSIONS = 'null'
    OR CO.EXCLUSIONS = '';
    
UPDATE CUSTOMER_ORDERS_OK AS CO
SET 
    CO.EXTRAS = NULL
WHERE 
    CO.EXTRAS = 'null'
    OR CO.EXTRAS = '';

--------------------------------------------------------------------------------------
SELECT 
    RUNNER,
    TOTAL_PEDIDOS_OK,
    CANTIDAD_DE_PIZZAS,
    CASE 
        WHEN TOTAL_PEDIDOS > 0 
        THEN ROUND(((TOTAL_PEDIDOS_OK / TOTAL_PEDIDOS) * 100), 2) 
        ELSE 0 
    END AS PORCENTAJE_ACIERTO,
    CASE 
        WHEN CANTIDAD_DE_PIZZAS > 0 
        THEN ROUND(((CANTIDAD_DE_PIZZAS_MODIFICADAS / CANTIDAD_DE_PIZZAS) * 100), 2) 
        ELSE 0 
    END AS PORCENTAJE_PIZZAS_MODIFICADAS
FROM (SELECT 
        r.RUNNER_ID AS RUNNER,
        COUNT(DISTINCT ro.ORDER_ID) AS TOTAL_PEDIDOS,
        COUNT(DISTINCT 
                    CASE 
                        WHEN ro.PICKUP_TIME IS NOT NULL 
                        THEN ro.ORDER_ID 
                    END) AS TOTAL_PEDIDOS_OK,
        COUNT(CASE 
                WHEN ro.PICKUP_TIME IS NOT NULL 
                THEN co.PIZZA_ID 
              END) AS CANTIDAD_DE_PIZZAS,
        COUNT(CASE 
                WHEN ro.PICKUP_TIME IS NOT NULL 
                    AND (co.EXCLUSIONS IS NOT NULL 
                    OR co.EXTRAS IS NOT NULL) 
                THEN co.PIZZA_ID 
              END) AS CANTIDAD_DE_PIZZAS_MODIFICADAS
    FROM CASE02.RUNNERS r
    LEFT JOIN RUNNER_ORDERS_OK ro 
        ON r.RUNNER_ID = ro.RUNNER_ID 
    LEFT JOIN CUSTOMER_ORDERS_OK co 
        ON co.ORDER_ID = ro.ORDER_ID
    GROUP BY r.RUNNER_ID
    ORDER BY r.RUNNER_ID);
