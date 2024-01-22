WITH CTE_STATUS AS (
    /*Creamos dos estados de entrega*/
    SELECT runner_id,
        order_id,
        CASE
            WHEN cancellation = 'Restaurant Cancellation' THEN 'C'
            WHEN cancellation = 'Customer Cancellation' THEN 'C'
            ELSE 'D'
        END status
    FROM sql_en_llamas.case02.runner_orders
), CTE_DELIVERED AS(
    /*Pedidos entregados*/
    SELECT A.runner_id,
        COUNT(DISTINCT A.order_id) pedidos_entregados,
        COUNT(B.pizza_id) pizzas_entregadas
    FROM cte_status A
    RIGHT JOIN sql_en_llamas.case02.customer_orders B
        ON A.order_id=B.order_id
    WHERE status='D'
    GROUP BY 1
), CTE_TOTALS AS (
    /*Pedidos Totales*/
    SELECT A.runner_id,
        COUNT(DISTINCT A.order_id) pedidos_totales,
        COUNT(B.pizza_id) pizzas_totales
    FROM cte_status A
    RIGHT JOIN sql_en_llamas.case02.customer_orders B
        ON A.order_id=B.order_id
    GROUP BY 1
), CTE_MOD_PIZZAS AS (
    /*Pizzas con modificaciones*/
    SELECT B.runner_id,
        COUNT(A.pizza_id) TOT_MOD_PIZZAS,
        CASE
            WHEN (A.exclusions='null' OR LENGTH(A.exclusions)=0) AND (A.extras = 'null' OR LENGTH(A.extras) = 0 OR LENGTH(A.extras) = null) THEN 'No'
            ELSE 'Si'
        END MODS
    FROM sql_en_llamas.case02.customer_orders A
    RIGHT JOIN CTE_STATUS B
        ON A.order_id=B.order_id
    WHERE MODS='Si'
    GROUP BY 1,3
)
/*Mostramos todo*/
SELECT A.runner_id,
    A.pedidos_entregados,
    A.pizzas_entregadas,
    (A.pedidos_entregados / B.pedidos_totales) * 100 SUCCESS_ORDER_PERCENT,
    (D.tot_mod_pizzas / B.pizzas_totales) * 100 PIZZA_MOD_PERCENT
FROM CTE_DELIVERED A
RIGHT JOIN CTE_TOTALS B
    ON A.runner_id=B.runner_id
RIGHT JOIN CTE_MOD_PIZZAS D
    ON A.runner_id=D.runner_id
