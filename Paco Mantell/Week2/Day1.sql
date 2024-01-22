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
    SELECT runner_id,
    COUNT(order_id) pedidos_totales
    FROM cte_status
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
    COUNT(A.pizza_id) MOD_PIZZAS,
    CASE
        WHEN A.exclusions='null' OR LENGTH(A.exclusions)=0 THEN 'No'
        ELSE 'Si'
    END EXCL_MODS,
    CASE
        WHEN A.extras = 'null' OR LENGTH(A.extras) = 0 OR LENGTH(A.extras) = null THEN 'No'
        ELSE 'Si'
    END EXTR_MODS
    FROM sql_en_llamas.case02.customer_orders A
    RIGHT JOIN CTE_STATUS B
    ON A.order_id=B.order_id
    WHERE (EXCL_MODS = 'Si' OR EXTR_MODS='Si')
    AND B.status='D'
    GROUP BY 1,3,4
)
/*Mostramos todo*/
SELECT A.runner_id,
A.pedidos_entregados,
C.num_pizzas PIZZAS_ENTREGADAS,
(A.pedidos_entregados / B.pedidos_totales) * 100 success_rate,
/*Mostramos Porcentaje de pizzas entregadas con modificaciones*/
(SELECT 
SUM(MP.mod_pizzas) / SUM(DP.num_pizzas) * 100
FROM CTE_MOD_PIZZAS MP
RIGHT JOIN CTE_DELIV_PIZZAS DP
ON MP.runner_id=DP.runner_id) PIZZAS_MOD_RATE
FROM CTE_DELIV_ORDERS A
JOIN CTE_TOT_ORDERS B
ON A.runner_id=B.runner_id
JOIN CTE_DELIV_PIZZAS C
ON A.runner_id=C.runner_id
