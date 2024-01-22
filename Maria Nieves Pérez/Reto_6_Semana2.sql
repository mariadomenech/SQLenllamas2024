WITH runner_order_pizza_1 AS (
    SELECT 
        DISTINCT n.runner_id AS corredor,
        M.ORDER_ID, 
        PIZZA_ID,
        CASE WHEN pickup_time is null THEN '0000-00-00 00:00:00'
            WHEN pickup_time = 'null' THEN '0000-00-00 00:00:00'
            ELSE pickup_time END AS pickup_time,
        COUNT(pizza_id) OVER (PARTITION BY corredor) AS pizzas_pedidas, 
        COUNT(DISTINCT M.ORDER_ID) OVER (PARTITION BY corredor) AS pedidos_totales,
        CASE WHEN cancellation IS NULL THEN 'En curso'
            WHEN cancellation = 'null' THEN 'En curso'
            WHEN CANCELLATION = '' THEN 'En curso'
            ELSE cancellation END AS Cancelaciones,
        CASE WHEN exclusions IS NULL THEN 'Sin exclusiones'
            WHEN exclusions = '' OR exclusions = 'null' THEN 'Sin exclusiones'
            ELSE exclusions END AS Exclusiones,
        CASE WHEN extras IS NULL THEN 'Sin extras'
            WHEN extras = '' OR extras = 'null' THEN 'Sin extras'
            ELSE extras END AS extras
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS M
    RIGHT JOIN SQL_EN_LLAMAS.CASE02.RUNNERS N
        ON M.RUNNER_ID=N.RUNNER_ID
    FULL JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS O
        ON M.ORDER_ID=O.ORDER_ID
    ORDER BY corredor, ORDER_ID, PIZZA_ID
),

runner_order_pizza_2 AS (
    SELECT 
        corredor,
        order_id,
        pizza_id,
        COUNT(distinct order_id) OVER (PARTITION BY corredor) AS pedidos_completados,
        COUNT(pizza_id) OVER (PARTITION BY corredor) AS pizzas_entregadas,
        pizzas_pedidas,
        pedidos_totales,
        pickup_time,
        exclusiones, 
        extras
    FROM runner_order_pizza_1
    WHERE 
        pickup_time != '0000-00-00 00:00:00'   --Cuando el pickup_time está a cero, los pedidos han sido cancelados--
            OR order_id IS NULL                --Cuando el order_id es nulo, el pedido no existe, no hay pedido--
),

exclusiones_y_extras AS (
    SELECT
        distinct corredor,
        COUNT (pizza_id) OVER (PARTITION BY corredor) AS pizzas_sin_exclusiones
    FROM runner_order_pizza_1 A
    WHERE 
        exclusiones != 'Sin exclusiones'        --Que tenga algun tipo de exclusion--
            OR extras != 'Sin extras'          --Que tenga algun extra--
            AND cancelaciones = 'En curso'      --Que no haya sido cancelada--
    order by corredor
),       


runner_order_pizza_3 AS (
    SELECT
        A.corredor,
        pedidos_totales,
        pedidos_completados,
        pizzas_entregadas,
        pizzas_pedidas,
        CASE WHEN pizzas_sin_exclusiones IS NULL THEN 0
            ELSE pizzas_sin_exclusiones END AS pizzas_sin_exclusiones,
        CASE WHEN pedidos_totales = 0 THEN 0                    --Para controlar la división por 0--
            ELSE (pedidos_completados / pedidos_totales) * 100 END AS porc_exito_pedidos, 
        CASE WHEN pizzas_pedidas = 0 THEN 0                     --Para controlar la división por 0--
            ELSE (pizzas_entregadas / pizzas_pedidas) * 100 END AS porc_exito_pizzas,
        CASE WHEN pizzas_sin_exclusiones = 0 THEN 0 
            WHEN pizzas_sin_exclusiones IS NULL THEN 0          --Para controlar la división por 0--
            ELSE (pizzas_sin_exclusiones / pizzas_entregadas) * 100 END AS porc_pizzas_modificadas
    FROM runner_order_pizza_2 A
    FULL JOIN exclusiones_y_extras B
        ON A.corredor=B.corredor
)

SELECT      
    DISTINCT corredor AS corredor,          
    --pedidos_totales,                          
    pedidos_completados,
    --pizzas_pedidas,
    pizzas_entregadas,
    ROUND(porc_exito_pedidos,2) AS porc_exito_pedidos,
    --pizzas_sin_exclusiones,
    --pizzas_totales_con_exclusiones
    --round(porc_exito_pizzas,2) AS porc_exito_pizzas,
    ROUND(porc_pizzas_modificadas, 2) AS porc_pizzas_modificadas
FROM runner_order_pizza_3
ORDER BY corredor;

--Dejo comentadas las columnas auxiliares que he usado para comprobar que los resultados eran correctos--
--Ha sido dificil pero ha merecido la pena =D --