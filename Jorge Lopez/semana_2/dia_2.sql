/* Día 2: ¿Cúal es la distancia acumulada de cada repartidor y su velocidad promedio?

  Como en el día anterior, primero he limpiado las tablas para después hacer la 
  consulta.*/

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
