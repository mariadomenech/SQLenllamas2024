/*1.¿Cual es la distancia acumulada de reparto de cada runner?
  2.¿Y la velocidad promedio en km/h?*/

--TABLAS LIMPIAS--
    
CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED AS
    SELECT
        order_id
        ,runner_id
        ,pickup_time
        ,CASE 
              WHEN TRIM(duration) in ('null','') THEN NULL
              ELSE REGEXP_REPLACE(duration,'[^0-9.]','') :: DECIMAL (15,2)
         END AS duration_minute
        ,COALESCE((duration_minute / 60),0) as duration_hour
        ,CASE 
              WHEN TRIM(distance) in ('null','') THEN NULL
              ELSE REGEXP_REPLACE (distance,'[^0-9.]','') :: DECIMAL (15,2)
         END AS distance
        ,CASE
              WHEN TRIM(cancellation) IS NULL OR TRIM(cancellation) IN ('', 'null') THEN NULL
              ELSE 'cancelled'
         END AS cancellation  
    FROM case02.runner_orders;

    --CASO--
SELECT 
       B.runner_id
      ,SUM(COALESCE(distance,0)) as total_distance_km
      ,COALESCE(ROUND(AVG (distance / duration_hour),2),0) as avg_speed_km_h
FROM ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED A
RIGHT JOIN case02.RUNNERS B
    ON A.runner_id = B.runner_id
WHERE cancellation IS NULL
GROUP BY 1;

