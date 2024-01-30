--¿Cuál es la distancia acumulada de reparto de cada runner?
--¿Y la velocidad promedio en (km/h))?

CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.CLEANED_CUSTOMER_ORDERS AS
    SELECT
         ORDER_ID
        ,CUSTOMER_ID
        ,PIZZA_ID 
        ,CASE
             WHEN TRIM(EXCLUSIONS) IN ('null', '') 
               OR EXCLUSIONS IS NULL THEN NULL
             ELSE EXCLUSIONS
         END AS EXCLUSIONS
        ,CASE
             WHEN TRIM(EXTRAS) IN ('null', '') 
               OR EXTRAS IS NULL THEN NULL
             ELSE EXTRAS
         END AS EXTRAS
        ,ORDER_TIME 
    FROM CUSTOMER_ORDERS;


CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.CLEANED_RUNNER_ORDERS AS
    SELECT
        ORDER_ID
       ,RUNNER_ID
       ,CASE
            WHEN TRIM(PICKUP_TIME) = 'null' THEN NULL
            ELSE PICKUP_TIME
        END AS PICKUP_TIME
       ,CASE
            WHEN TRIM(DISTANCE) = 'null' THEN NULL 
             ELSE REGEXP_REPLACE(DISTANCE, '[^0-9.]', '')::NUMBER(32,2)
        END AS DISTANCE_KM
       ,CASE
            WHEN TRIM(DURATION) = 'null' THEN NULL 
            ELSE REGEXP_REPLACE(DURATION, '[^0-9.]', '')::NUMBER(32,2)
        END AS DURATION_MIN
       ,DURATION_MIN/60 AS DURATION_H
    FROM RUNNER_ORDERS;

SELECT 
     B.RUNNER_ID
    ,SUM(COALESCE(A.DISTANCE_KM,0)) AS DISTANCIA_TOTAL_KMS
    ,COALESCE(ROUND(AVG(A.DISTANCE_KM/A.DURATION_H),2),0) AS VELOCIDAD_MEDIA_KMH
FROM ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.CLEANED_RUNNER_ORDERS A
RIGHT JOIN RUNNERS B
        ON A.RUNNER_ID = B.RUNNER_ID
GROUP BY 1;

/*JUANPE: 

Resultado: Correcto

Código: Correcto. Con las tablas bien limpias una sencilla select es suficiente bien hecho! y además tu forma de limpiar el campo con el uso del
REGEXP_REPLACE me parece muy limpio otra posible forma hubiera sido REGEXP_SUBSTR(DURATION, '[0-9.]*'), que en vez de reemplazar sustraemos los
caracteres que queremos conservar.

Legibilidad: Correcto

Extra: Bien en sacar al runner 4 y limpiar los nulos por ceros y redondear a dos decimales. 
*/
