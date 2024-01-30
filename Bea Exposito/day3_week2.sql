/*1.¿Cuanto dinero le sobra a Giuseppe después de estas entregas?
  Ingresos:
           - Meatlovers 12€
           - Vegetariana 10€
           - Cada ingrediente extra 1€
  Gastos:
           - 0.30€/km recorrido a cada runner
*/  

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
        ,extras
        ,order_time
    FROM case02.customer_orders;

    
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
        SUM(ROUND ((A.incomes - A.costs),2)) AS revenue
    FROM
    (
    SELECT 
           COALESCE(DECODE(D.pizza_name,'Meatlovers',12,'Vegetarian',10):: NUMBER (2,0),0) as pizza_price
          ,CASE
                WHEN TRIM(extras) IS NULL OR TRIM(extras) IN ('', 'null')  THEN NULL
                ELSE ARRAY_SIZE(SPLIT(extras,','))
           END AS num_extras
          ,CASE 
                WHEN C.num_extras IS NULL THEN 0
                ELSE COALESCE((C.num_extras),0)*1
           END AS extra_pizza_price
         ,COALESCE((pizza_price + extra_pizza_price),0) as incomes
         ,DISTANCE * 0.3 AS costs
    FROM case02.runners A
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.RUNNER_ORDERS_CLEANED B
         ON A.runner_id = B.runner_id
    LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.CUSTOMER_ORDERS_CLEANED C
         ON B.order_id = C.order_id
    LEFT JOIN case02.pizza_names D
         ON C.pizza_id = D.pizza_id   
    WHERE B.cancellation IS NULL
    )A

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Hay algunos errores que hace que no se ejecute el código, estos son:


        ,CASE
            WHEN trim(exclusions) IS NULL OR TRIM(exclusions) IN ('', 'null')  THEN NULL
            ELSE exclusions
        END AS exclusions, <-- Esa coma da error ya que extras tiene la suya delante
        ,extras


        ,CASE
              WHEN TRIM(extras) IS NULL OR TRIM(extras) IN ('', 'null')  THEN NULL
              ELSE ARRAY_SIZE(SPLIT(extras,','))
         END AS num_extras
        ,CASE 
              WHEN C.num_extras IS NULL THEN 0
              ELSE COALESCE((C.num_extras),0)*1
         END AS extra_pizza_price -->Utilizas el campo NUM_EXTRAS (generado anteriormente) pero le referencias como que es procedente de la tabla con alias C, por lo que da error ya que no existe en la tabla C.


Corrigiendo esto el resultado no es correcto ya que, para pedidos en los que se reparten más de 1 pizza contabilizas varias veces la distancia del reparto (esta es igual independientemente de la cantidad
de pizzas repartidas).
Para solucionar esto habría que calcular de forma independiente las ganancias y los gastos, sumando posteriormente las ganancias de las pizzas de cada pedido.

*/
