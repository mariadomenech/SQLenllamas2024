/*Día 3: Una pizza meat lovers(1) cuesta 12 y la vegetariana(2) 10. Cada ingrediente extra 1 euros Cada 
runner se le paga 0.30 km ¿Cuánto dinero queda de ganancia después de las entregas?*/

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

UPDATE RUNNER_ORDERS_OK AS RO
SET RO.DISTANCE = CAST(REPLACE(RO.DISTANCE, 'km', '') AS FLOAT)
FROM RUNNER_ORDERS_OK;
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
SELECT * FROM RUNNER_ORDERS_OK;

UPDATE RUNNER_ORDERS_OK AS RO
SET RO.DISTANCE = CAST(REPLACE(RO.DISTANCE, 'km', '') AS FLOAT)
FROM RUNNER_ORDERS_OK;

UPDATE RUNNER_ORDERS_OK AS RO
SET RO.DURATION = REPLACE(RO.DURATION, 'mins', '')
FROM RUNNER_ORDERS_OK;

UPDATE RUNNER_ORDERS_OK AS RO
SET RO.DURATION = REPLACE(RO.DURATION, 'minutes', '')
FROM RUNNER_ORDERS_OK;

UPDATE RUNNER_ORDERS_OK AS RO
SET RO.DURATION = REPLACE(RO.DURATION, 'minute', '')
FROM RUNNER_ORDERS_OK;

UPDATE RUNNER_ORDERS_OK AS RO
SET RO.DURATION = CAST(RO.DURATION AS FLOAT)
FROM RUNNER_ORDERS_OK;
--------------------------------------------------------------------------------------

SELECT 
    (SUM(DINERO_GENERADO + EXTRAS_OK)) - (SUM(KM_TOTALES * 0.30)) AS BENEFICIO_TOTAL
FROM(
    SELECT 
        PEDIDO,
        DINERO_GENERADO,
        CASE WHEN EXTRAS IS NULL THEN 0 ELSE EXTRAS END AS EXTRAS_OK,
        KM_TOTALES
    FROM(
        SELECT 
            co.ORDER_ID AS PEDIDO,
            SUM(CASE 
                    WHEN ro.PICKUP_TIME IS NULL THEN 0
                    ELSE
                        CASE 
                            WHEN co.PIZZA_ID = 1 THEN 12
                            ELSE 10
                        END
                END) AS DINERO_GENERADO,
                SUM(ARRAY_SIZE(SPLIT(CO.EXTRAS, ','))) AS EXTRAS,
                SUM(ro.DISTANCE) AS KM_TOTALES
        FROM RUNNER_ORDERS_OK ro 
        LEFT JOIN CUSTOMER_ORDERS_OK co 
            ON co.ORDER_ID = ro.ORDER_ID
        WHERE ro.PICKUP_TIME IS NOT NULL
        GROUP BY co.ORDER_ID
        ORDER BY co.ORDER_ID));

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Has tenido un fallo que incluso yo tuve cuando planteé el ejericicio.

Si un  pedido tiene dos pizzas, la distancia solo la cuentas una vez. Ten cuidado porque has contado como si cada pizza fuera un viaje diferente.
El gasto total debe salir  43.56.

Por tanto, puedes hacerte un indicador que te diga cuántas pizzas hay por pedido, y te quedas solo con el registro cuando el contador sea 1.

Lo demás bien!

Te chivo una expresión regular para limpiarte los valores string de los campos, para que no te quede tan largo y denso el código:  REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') 

*/
