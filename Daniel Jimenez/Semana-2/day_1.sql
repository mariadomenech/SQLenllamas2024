//DIA 1 - ¿Cuantos pedidos y cuantas pizzas se han entregado con exito por cada runner, cual es su porcentaje de exito de cada runner? ¿que porcentaje de las pizzas entregadas tenían modificaciones?

WITH runner_pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   RUNNER_ID 
        ,   CASE WHEN PICKUP_TIME = 'null' THEN NULL ELSE PICKUP_TIME END AS hora_recogida
        ,   CASE WHEN DISTANCE = 'null' THEN NULL ELSE DISTANCE END AS distancia
        ,   CASE WHEN DURATION = 'null' THEN NULL ELSE DURATION END AS duracion_runner
        ,   CASE WHEN CANCELLATION = 'null' OR CANCELLATION = '' THEN NULL ELSE CANCELLATION END AS pedido_cancelado
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS
),
    
pedidos_limpitos AS (
    SELECT  ORDER_ID
        ,   CUSTOMER_ID
        ,   PIZZA_ID
        ,   CASE WHEN EXCLUSIONS = 'null' OR EXCLUSIONS = '' THEN NULL ELSE EXCLUSIONS END AS ingredientes_excluidos
        ,   CASE WHEN EXTRAS = 'null' OR EXTRAS = '' THEN NULL ELSE EXTRAS END AS ingredientes_extras
        ,   ORDER_TIME
    FROM SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
),
    
pedidos_pizza AS (
    SELECT  ORDER_ID
        ,   COUNT(PIZZA_ID) AS num_pizzas
    FROM pedidos_limpitos
    GROUP BY ORDER_ID
    ORDER BY ORDER_ID
),
    
pizzas_personalizadas AS (
    SELECT  r.RUNNER_ID
        ,   COUNT(*) AS num_pizzas_personalizadas
    FROM pedidos_limpitos c
    LEFT JOIN runner_pedidos_limpitos r
        ON c.ORDER_ID = r.ORDER_ID
    WHERE r.hora_recogida IS NOT NULL AND (ingredientes_excluidos IS NOT NULL OR ingredientes_extras IS NOT NULL)
    GROUP BY r.RUNNER_ID
),
    
pedidos AS (
    SELECT  r.RUNNER_ID
        ,   COUNT(ro.ORDER_ID) AS num_pedidos_totales
        ,   NVL(SUM(p.NUM_PIZZAS),0) AS pizzas_totales
    FROM pedidos_pizza p
    RIGHT JOIN runner_pedidos_limpitos ro
        ON p.ORDER_ID = ro.ORDER_ID
    RIGHT JOIN SQL_EN_LLAMAS.CASE02.RUNNERS R
        ON ro.RUNNER_ID = r.RUNNER_ID
    GROUP BY r.RUNNER_ID
),
    
pedidos_completados as (
    SELECT r.RUNNER_ID
        ,  COUNT(ro.ORDER_ID) AS pedidos_completados
        ,  NVL(SUM(p.NUM_PIZZAS), 0) AS total_pizzas_completadas
    FROM pedidos_pizza p
    RIGHT JOIN runner_pedidos_limpitos ro
        ON p.ORDER_ID = ro.ORDER_ID
    RIGHT JOIN SQL_EN_LLAMAS.CASE02.RUNNERS r
        ON ro.RUNNER_ID = r.RUNNER_ID
    WHERE hora_recogida IS NOT NULL
    GROUP BY r.RUNNER_ID
)
    
SELECT  t.RUNNER_ID
    ,   NVL(total_pizzas_completadas,0) AS total_pizzas_exito
    ,   NVL(pedidos_completados,0) AS total_pedidos_exito
    ,   ROUND(COALESCE(total_pedidos_exito * 100 / NULLIF(num_pedidos_totales, 0),0),2) AS rendimiento_runner_pct
    ,   ROUND(COALESCE(num_pizzas_personalizadas * 100 / NULLIF(total_pizzas_completadas, 0),0),2) AS pizzas_personalizadas_pct
FROM pedidos t
LEFT JOIN pedidos_completados e
    ON t.RUNNER_ID = e.RUNNER_ID
LEFT JOIN pizzas_personalizadas p
    ON t.RUNNER_ID = p.RUNNER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto! Solo comentar que, para que quede un poco más limpio el código, metería un salto de linea entre CTEs:

WITH runner_pedidos_limpitos AS (
    SELECT  ....
),

pedidos_limpitos AS (
    SELECT  ....
),

*/
