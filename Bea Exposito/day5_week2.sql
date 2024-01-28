
/*¿Cuántas veces ha sido usado cada ingrediente sobre el total de pizzas entregadas? 
Ordernar del más frecuente al menos*/

--TABLAS LIMPIAS--
CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED AS
    SELECT 
        order_id
        ,pizza_id
        ,CASE
            WHEN trim(exclusions) IN ('', 'null') THEN NULL
            WHEN trim(exclusions) = 'beef' THEN '3'
            ELSE exclusions
        END AS exclusions
        ,CASE
            WHEN trim(extras) IS NULL OR TRIM(extras) IN ('', 'null')  THEN NULL
            ELSE extras
        END AS extras
    FROM case02.customer_orders;

    
CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED AS
    SELECT
        order_id
        ,CASE
              WHEN TRIM(cancellation) IS NULL OR TRIM(cancellation) IN ('', 'null') THEN NULL
              ELSE 'cancelled'
         END AS cancellation  
    FROM case02.runner_orders;


--SPLIT INGREDIENTES Y EXTRAS
WITH data AS(
    SELECT 
        A.toppings
        ,B.exclusions
        ,B.extras
    FROM case02.pizza_recipes A
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED B
        ON A.pizza_id = B.pizza_id
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED C
        ON B.order_id = C.order_id        
    WHERE C.cancellation is null
)
,ingredients_extras AS (
    SELECT
        split(toppings, ', ') C
        ,C[0]::int as ingredient_1
        ,C[1]::int as ingredient_2
        ,C[2]::int as ingredient_3
        ,C[3]::int as ingredient_4
        ,C[4]::int as ingredient_5
        ,C[5]::int as ingredient_6
        ,C[6]::int as ingredient_7
        ,C[7]::int as ingredient_8
        ,split(extras, ', ') D
        ,D[0]::int as extra_1
        ,D[1]::int as extra_2
    FROM data

)
 ,ingredients_extras_split AS (
    SELECT A.topping
           , 1 AS quantity
    FROM ingredients_extras A
    UNPIVOT (topping 
        FOR ingredients 
            IN (ingredient_1,ingredient_2,ingredient_3,ingredient_4,ingredient_5,ingredient_6,ingredient_7,ingredient_8,extra_1,extra_2))
)
--SPLIT EXCLUSIONES
 ,exclusions AS (  
    SELECT DISTINCT 
        order_id
        ,pizza_id
        ,split(exclusions, ', ') C
        ,C[0]::int as exclusion_1
        ,C[1]::int as exclusion_2
    FROM ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED
)
  ,exclusions_split AS (
    SELECT A.topping,
            -1 AS quantity
    FROM exclusions A
    UNPIVOT (topping 
        FOR exclusions
            IN (exclusion_1,exclusion_2))
) --UNIR SPLIT
,unions AS
(
    SELECT * FROM ingredients_extras_split
    UNION ALL
    SELECT * FROM exclusions_split
) 
--TOTAL TOPPINGS UTILIZADOS
SELECT 
    A.topping_name
   ,SUM(B.quantity) AS total_quantity
FROM case02.pizza_toppings A
LEFT JOIN unions B 
    ON A.topping_id = B.topping
GROUP BY 1
ORDER BY 2 DESC;
