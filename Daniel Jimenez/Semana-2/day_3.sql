/*DÍA 3- Una pizza meat lovers cuesta 12 euros y una vegetariana 10 euros, cada ingrediente extra supone 1 euro adicional, por otro lado, a cada corredor se le paga 0.30 euros por kilómetro recorrido. ¿Cuanto dinero le sobra a Giuseppe de estas entregas?*/



WITH pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   CUSTOMER_ID
        ,   PIZZA_ID
        ,   CASE WHEN EXCLUSIONS = 'null' OR EXCLUSIONS = '' THEN NULL ELSE EXCLUSIONS END AS ingredientes_excluidos
        ,   CASE WHEN EXTRAS = 'null' OR EXTRAS = '' THEN NULL ELSE EXTRAS END AS ingredientes_extras
        ,   ORDER_TIME
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
),
runner_pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID 
        ,   CASE WHEN PICKUP_TIME = 'null' THEN NULL ELSE PICKUP_TIME END AS hora_recogida
        ,   CASE WHEN DISTANCE = 'null' THEN NULL ELSE DISTANCE END AS distancia
        ,   CASE WHEN DURATION = 'null' THEN NULL ELSE DURATION END AS duracion_runner
        ,   CASE WHEN CANCELLATION = 'null' OR CANCELLATION = '' THEN NULL ELSE CANCELLATION END AS pedido_cancelado
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
),
tabla_runner_sin_nulls AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID
        ,   hora_recogida
        ,   CAST(REGEXP_REPLACE(duracion_runner, '(minutes|mins|minute)', '') AS INTEGER) AS duracion_minutos
        ,   CAST(REPLACE(distancia, 'km', '') AS FLOAT) AS distancia_kilometros
        ,   pedido_cancelado
    FROM runner_pedidos_limpitos
),
distancia_y_pago AS (
    SELECT  RUNNER_ID
         ,  ORDER_ID
         ,  distancia_kilometros
         ,  distancia_kilometros * 0.30 AS pago_total
    FROM 
        tabla_runner_sin_nulls
)
SELECT  p.ORDER_ID
     ,  p.CUSTOMER_ID
     ,  p.PIZZA_ID
     ,  pn.PIZZA_NAME AS nombre_pizza
     ,  CASE 
            WHEN pn.PIZZA_NAME = 'Meatlovers' THEN 12
            WHEN pn.PIZZA_NAME = 'Vegetarian' THEN 10
        END AS coste_base
     ,  CASE 
            WHEN p.ingredientes_extras IS NOT NULL THEN LENGTH(p.ingredientes_extras) - LENGTH(REPLACE(p.ingredientes_extras, ',', '')) + 1 /*He contado todas las comas al comprobar que los toppings están separados por comas, luego sumo 1 y así saco el total de extras que lleva la pizza.*/
            ELSE 0
        END AS numero_extras
     ,  CASE 
            WHEN p.ingredientes_extras IS NOT NULL THEN LENGTH(p.ingredientes_extras) - LENGTH(REPLACE(p.ingredientes_extras, ',', '')) + 1
            ELSE 0
        END AS coste_extras
     ,  (CASE 
            WHEN pn.PIZZA_NAME = 'Meatlovers' THEN 12
            WHEN pn.PIZZA_NAME = 'Vegetarian' THEN 10
        END + CASE 
            WHEN p.ingredientes_extras IS NOT NULL THEN LENGTH(p.ingredientes_extras) - LENGTH(REPLACE(p.ingredientes_extras, ',', '')) + 1
            ELSE 0
        END) AS coste_final
     ,  COALESCE(CAST(d.pago_total AS VARCHAR), 'Pedido cancelado') AS pago_runner_km
     ,  COALESCE(CAST(((CASE 
            WHEN pn.PIZZA_NAME = 'Meatlovers' THEN 12
            WHEN pn.PIZZA_NAME = 'Vegetarian' THEN 10
        END + CASE 
            WHEN p.ingredientes_extras IS NOT NULL THEN LENGTH(p.ingredientes_extras) - LENGTH(REPLACE(p.ingredientes_extras, ',', '')) + 1
            ELSE 0
        END) - d.pago_total) AS VARCHAR), 'Pedido cancelado') AS beneficio_por_envio /* Confio en que pueda haber una manera mas sencilla e intuitiva pero solo saqué esta */
FROM 
    pedidos_limpitos p
LEFT JOIN SQL_EN_LLAMAS.CASE02.PIZZA_NAMES pn 
    ON p.PIZZA_ID = pn.PIZZA_ID
LEFT JOIN tabla_runner_sin_nulls r 
    ON p.ORDER_ID = r.ORDER_ID
LEFT JOIN distancia_y_pago d
    ON r.RUNNER_ID = d.RUNNER_ID AND r.ORDER_ID = d.ORDER_ID;


/*DÍA 3 solo mostrando KPI de BENEFICIOS TOTALES*/

WITH pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   CUSTOMER_ID
        ,   PIZZA_ID
        ,   CASE WHEN EXCLUSIONS = 'null' OR EXCLUSIONS = '' THEN NULL ELSE EXCLUSIONS END AS ingredientes_excluidos
        ,   CASE WHEN EXTRAS = 'null' OR EXTRAS = '' THEN NULL ELSE EXTRAS END AS ingredientes_extras
        ,   ORDER_TIME
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
),
runner_pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID 
        ,   CASE WHEN PICKUP_TIME = 'null' THEN NULL ELSE PICKUP_TIME END AS hora_recogida
        ,   CASE WHEN DISTANCE = 'null' THEN NULL ELSE DISTANCE END AS distancia
        ,   CASE WHEN DURATION = 'null' THEN NULL ELSE DURATION END AS duracion_runner
        ,   CASE WHEN CANCELLATION = 'null' OR CANCELLATION = '' THEN NULL ELSE CANCELLATION END AS pedido_cancelado
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
),
tabla_runner_sin_nulls AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID
        ,   hora_recogida
        ,   CAST(REGEXP_REPLACE(duracion_runner, '(minutes|mins|minute)', '') AS INTEGER) AS duracion_minutos
        ,   CAST(REPLACE(distancia, 'km', '') AS FLOAT) AS distancia_kilometros
        ,   pedido_cancelado
    FROM runner_pedidos_limpitos
),
distancia_y_pago AS (
    SELECT  RUNNER_ID
         ,  ORDER_ID
         ,  distancia_kilometros
         ,  distancia_kilometros * 0.30 AS pago_total
    FROM 
        tabla_runner_sin_nulls
)
SELECT SUM(COALESCE(CAST(((CASE 
            WHEN pn.PIZZA_NAME = 'Meatlovers' THEN 12
            WHEN pn.PIZZA_NAME = 'Vegetarian' THEN 10
        END + CASE 
            WHEN p.ingredientes_extras IS NOT NULL THEN LENGTH(p.ingredientes_extras) - LENGTH(REPLACE(p.ingredientes_extras, ',', '')) + 1
            ELSE 0
        END) - d.pago_total) AS FLOAT), 0)) AS suma_total_beneficio_por_envio
FROM 
    pedidos_limpitos p
LEFT JOIN SQL_EN_LLAMAS.CASE02.PIZZA_NAMES pn 
    ON p.PIZZA_ID = pn.PIZZA_ID
LEFT JOIN tabla_runner_sin_nulls r 
    ON p.ORDER_ID = r.ORDER_ID
LEFT JOIN distancia_y_pago d
    ON r.RUNNER_ID = d.RUNNER_ID AND r.ORDER_ID = d.ORDER_ID;



SELECT * FROM SQL_EN_LLAMAS.CASE02.PIZZA_NAMES;
