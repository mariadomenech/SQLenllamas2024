WITH parte1 AS (
    SELECT
        a.runner_id,
        COUNT(DISTINCT b.order_id) AS pedidos_entregados,
        COUNT(b.pizza_id) AS pizzas_entregadas
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS AS a
    INNER JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS AS b
        ON a.order_id = b.order_id
    WHERE a.pickup_time <> 'null'
    GROUP BY a.runner_id
)
SELECT
    parte1.runner_id,
    parte1.pedidos_entregados,
    parte1.pizzas_entregadas,
    (parte1.pedidos_entregados * 100) / SUM(parte1.pedidos_entregados) OVER () AS porcentaje_exito
FROM 
    parte1;
--Tengo dudas de cómo calcular la última pregunta
