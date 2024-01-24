/*1.número de pedidos que se han entregado con éxito
2.número de pizzas que se han entregado con éxito
3.porcentaje de éxito de cada runner, num pedidos éxitos respecto al total de pedidos.
4.porcentaje de pizzas entregadas con éxito que tenían modificaciones (num pizzas entregadas con éxito y con modificaciones respecto num pizzas total).*/

--TABLAS LIMPIAS--
CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED AS
    SELECT
        order_id
        ,customer_id
        ,pizza_id
        ,CASE
            WHEN trim(exclusions) IS NULL OR TRIM(exclusions) IN ('', 'null')  THEN NULL
            ELSE exclusions
        END AS exclusions,
        CASE
            WHEN TRIM(extras) IS NULL OR TRIM(extras) IN ('', 'null')  THEN NULL
            ELSE extras
        END AS extras
        ,order_time
    FROM case02.customer_orders;

    
CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED AS
    SELECT
        order_id
        ,runner_id
        ,pickup_time
        ,distance
        ,duration
       , CASE
            WHEN TRIM(cancellation) IS NULL OR TRIM(cancellation) IN ('', 'null') THEN NULL
            ELSE 'cancelled'
        END AS cancellation  
    FROM case02.runner_orders;

    --CASO--
WITH exit_delivered_orders_and_pizzas AS 
    (
    SELECT A.runner_id
          ,coalesce (COUNT (DISTINCT C.order_id),0) as total_exit_delivered_orders
          ,coalesce(COUNT (C.order_id),0) as total_exit_delivered_pizzas
    FROM case02.runners A
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED B
         ON A.runner_id = B.runner_id
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED C
         ON B.order_id = C.order_id
    WHERE B.cancellation IS NULL
    GROUP BY A.runner_id
    )
    ,modified_exit_delivered_pizzas AS 
    (
     SELECT
                B.runner_id
                ,COALESCE( COUNT(*),0) AS total_modified_exit_delivered_pizzas
    FROM ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED A
    INNER JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED B
        ON A.order_id = B.order_id
    WHERE cancellation IS NULL
        AND (extras IS NOT NULL OR exclusions IS NOT NULL)
    GROUP BY runner_id
    )
    ,total_exit_pizzas_delivered AS
    (
    SELECT
                runner_id,
                COUNT(*) AS total_pizzas
    FROM ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED A
    INNER JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED B
            ON A.order_id = B.order_id
    WHERE cancellation IS NULL
    GROUP BY runner_id
    )
    ,total_orders AS
    (
    SELECT
           A.runner_id
           ,COALESCE(COUNT (A.order_id),0) as number_total_orders
    FROM ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED A
    GROUP BY A.runner_id
    )
    
SELECT 
       A.runner_id
      ,coalesce(total_exit_delivered_orders,0) as total_exit_delivered_orders
      ,coalesce(total_exit_delivered_pizzas,0) as total_exit_delivered_pizzas
      ,CASE 
            WHEN total_exit_delivered_orders != 0 THEN COALESCE(ROUND ((total_exit_delivered_orders / number_total_orders)*100, 2),0)
            ELSE 0 END AS percentage_exit_delivered_orders
      ,CASE 
            WHEN total_pizzas != 0 THEN COALESCE(ROUND ((total_modified_exit_delivered_pizzas / total_pizzas)*100, 2),0)
            ELSE 0 END AS percentage_exit_delivered_pizzas
FROM exit_delivered_orders_and_pizzas A
LEFT JOIN modified_exit_delivered_pizzas B
        ON A.runner_id = B.runner_id
LEFT JOIN total_orders C
        ON A.runner_id = C.runner_id
LEFT JOIN total_exit_pizzas_delivered D
        ON A.runner_id = D.runner_id
;

