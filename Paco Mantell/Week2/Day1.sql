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
), CTE_DELIV_ORDERS AS(
    /*Pedidos entregados*/
    SELECT runner_id,
        COUNT(order_id) pedidos_entregados
    FROM cte_status
    WHERE status='D'
    GROUP BY 1
), CTE_TOT_ORDERS AS (
    /*Pedidos Totales*/
    SELECT A.runner_id,
        COUNT(DISTINCT A.order_id) pedidos_totales,
        COUNT(B.pizza_id) pizzas_totales
    FROM cte_status A
    RIGHT JOIN sql_en_llamas.case02.customer_orders B
        ON A.order_id=B.order_id
    GROUP BY 1
), CTE_DELIV_PIZZAS AS(
    /*Pizzas entregadas*/
    SELECT A.runner_id,
        COUNT(B.pizza_id) num_pizzas
    FROM CTE_STATUS A
    RIGHT JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS B
        ON A.order_id=B.order_id
    WHERE A.status='D'
    GROUP BY 1
), CTE_MOD_PIZZAS AS (
    /*Pizzas entregadas con modificaciones*/
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
    C.num_pizzas PIZZAS_ENTREGADAS,
    (A.pedidos_entregados / B.pedidos_totales) * 100 SUCCESS_ORDER_PERCENT,
    (D.tot_mod_pizzas / B.pizzas_totales) * 100 PIZZA_MOD_PERCENT
FROM CTE_DELIV_ORDERS A
RIGHT JOIN CTE_TOT_ORDERS B
    ON A.runner_id=B.runner_id
RIGHT JOIN CTE_DELIV_PIZZAS C
    ON A.runner_id=C.runner_id
RIGHT JOIN CTE_MOD_PIZZAS D
    ON A.runner_id=D.runner_id
