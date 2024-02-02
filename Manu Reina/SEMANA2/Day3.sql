
/*UNA PIZZA MEAT LOVERS CUESTA 12 EUROS Y UNA VEGETARIANA 10 EUROS, Y
CADA INGREDIENTE EXTRA SUPONE 1 EURO ADICIONAL. POR OTRO LADO, A CADA CORREDOR SE LE PAGA 0.30 EUROS/KM RECORRIDO.
¿CUÁNTO DINERO LE SOBRA A GIUSEPPE DESPUÉS DE ESTAS ENTREGAS?*/



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
       ,DURATION_MIN/60.0 AS DURATION_H
       ,CASE
            WHEN TRIM(CANCELLATION) IN ('null', '') THEN NULL
            ELSE CANCELLATION
        END AS CANCELLATION
    FROM RUNNER_ORDERS;


SELECT 
     ROUND(SUM(A.PRECIO_PIZZA + A.INGREDIENTES_EXTRA) -
     SUM(GASTO_POR_RUNNER),2) AS BENEFICIO_TOTAL
   
FROM (
        SELECT
             A.ORDER_ID
            ,DISTANCE_KM*0.3 AS GASTO_POR_RUNNER
            ,CASE
                 WHEN PIZZA_ID = '1' THEN 12
                 WHEN PIZZA_ID = '2' THEN 10
             END AS PRECIO_PIZZA
            ,CASE
                 WHEN EXTRAS IS NULL THEN 0
                 ELSE ARRAY_SIZE(SPLIT(EXTRAS,','))
             END AS INGREDIENTES_EXTRA
        FROM ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.CLEANED_CUSTOMER_ORDERS A
        JOIN ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.CLEANED_RUNNER_ORDERS B
          ON A.ORDER_ID = B.ORDER_ID
         AND B.CANCELLATION IS NULL)A;
/*
COMENTARIO JUANPE:

RESULTADO: Incorrecto. El problema está en el gasto por km. Este gasto solo cuenta una vez por pedido, no una vez por pizza, que es lo que has hecho.
Si ejecutas solo tu subselect lo puedes comprobar. Ya que si una pedido tiene varias 3 pizzas no recorre la distancia 3 veces pues las lleva juntas.

CÓDIGO: Muy bien visto el ARRAY_SIZE(SPLIT()) pero dado el problema que te he comentaod en el RESULDATO, el código no es correcto.

LEGIBILIDD: Correcta y poco que decir me gusta no solo que haces tabulaciones si no que además alineas estas para mejor legibilidad.

EXTRA: Poco que comentar.
*/

