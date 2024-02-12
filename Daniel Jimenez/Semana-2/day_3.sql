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
    FROM    tabla_runner_sin_nulls
),

pizzas_por_pedido AS(
    SELECT  ORDER_ID
        ,   COUNT(*) AS num_pizzas
    FROM    pedidos_limpitos
    GROUP BY ORDER_ID
),

beneficio_por_pizza AS (
    SELECT  p.ORDER_ID
         ,  p.PIZZA_ID
         ,  (CASE 
                WHEN pn.PIZZA_NAME = 'Meatlovers' THEN 12
                WHEN pn.PIZZA_NAME = 'Vegetarian' THEN 10
            END + CASE 
                WHEN p.ingredientes_extras IS NOT NULL THEN LENGTH(p.ingredientes_extras) - LENGTH(REPLACE(p.ingredientes_extras, ',', '')) + 1
                ELSE 0
            END) AS beneficio
    FROM    pedidos_limpitos p
    LEFT JOIN SQL_EN_LLAMAS.CASE02.PIZZA_NAMES pn 
        ON p.PIZZA_ID = pn.PIZZA_ID
),

beneficio_por_pedido AS (
    SELECT  b.ORDER_ID
        ,   SUM(b.beneficio) AS beneficio_total
    FROM    beneficio_por_pizza b
    GROUP BY b.ORDER_ID
)

SELECT  bp.ORDER_ID
     ,  bp.beneficio_total
     ,  d.pago_total AS costo_runner
     ,  (bp.beneficio_total - d.pago_total) AS beneficio_por_envio
FROM    beneficio_por_pedido bp
LEFT JOIN distancia_y_pago d
    ON bp.ORDER_ID = d.ORDER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto ya que para pedidos en los que se reparten más de 1 pizza contabilizas varias veces la distancia del reparto (esta es igual independientemente de la cantidad de pizzas repartidas).
Para solucionar esto habría que calcular de forma independiente las ganancias y los gastos, sumando posteriormente las ganancias de las pizzas de cada pedido.

*/
