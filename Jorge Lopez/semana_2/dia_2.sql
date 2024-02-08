/* Día 2: ¿Cúal es la distancia acumulada de cada repartidor y su velocidad promedio?

  Como en el día anterior, primero he limpiado las tablas para después hacer la 
  consulta.*/

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
    RUNNER,
    DISTANCIA,
    DURACION,
    CASE 
        WHEN DURACION > 0 
        THEN ROUND ((DISTANCIA / (DURACION /60)) ,2)
        ELSE 0 
    END AS VELOCIDAD_MEDIA
FROM
    (SELECT 
        r.RUNNER_ID AS RUNNER, 
        ROUND (SUM(CASE 
                    WHEN PICKUP_TIME IS NOT NULL THEN ro.DISTANCE ELSE 0 END), 2) AS DISTANCIA,
        ROUND (SUM(CASE WHEN PICKUP_TIME IS NOT NULL THEN ro.DURATION ELSE 0 END), 2) AS DURACION
    FROM CASE02.RUNNERS r
        LEFT JOIN RUNNER_ORDERS_OK ro 
            ON r.RUNNER_ID = ro.RUNNER_ID 
    GROUP BY 1);


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

No es del todo correcto el código, se pedía velocidad promedio. Una vez que calculas los km/hora de cada pedido, haz la media por runner AVG.

Te chivo un método para limpiar los campos usando expresiones regulares: REGEXP_REPLACE(DISTANCE, '[a-zA-Z]', '') 

*/
