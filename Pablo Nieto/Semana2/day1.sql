/*
Creamos una columna nueva que nos indique si una pizza ha sido modificada o no.
*/
WITH pizzas_pedido AS (
    SELECT
        order_id,
        pizza_id,
        CASE
            WHEN (exclusions IN ('', 'null') OR exclusions IS NULL) AND (extras IN ('', 'null') OR extras IS NULL) THEN 'No'
            ELSE 'Si'
        END AS modificada
    FROM SQL_EN_LLAMAS.CASE02.customer_orders
),
/*
Ahora calculamos el número de pizzas y el número de pizzas modificadas de cada pedido
además de una columna nueva que nos indique si el pedido ha sido cancelado o no.
*/
pedidos_runner AS (
    SELECT
        ro.runner_id,
        ro.order_id,
        nvl(COUNT(pizza_id), 0) AS pizzas,
        nvl(SUM(CASE WHEN pp.modificada = 'Si' THEN 1 ELSE 0 END), 0) AS pizzas_mod,
        CASE
            WHEN ro.cancellation IS NULL OR ro.cancellation IN ('', 'null') THEN 'No'
            ELSE 'Si'
        END AS cancelado
    FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS ro
    LEFT JOIN pizzas_pedido pp
       ON ro.order_id = pp.order_id
    GROUP BY ro.runner_id, ro.order_id, ro.cancellation
)
/*
Finalmente, para cada runner calculamos:
1.-Pedidos entregados correctamente.
2.-Pizzas entregadas correctamente.
3.-Porcentaje de pedidos entregados correctamente.
4.-Porcentaje de pizzas modificadas del total de pizzas entregadas correctamente.
*/
SELECT
    r.runner_id,
    nvl(SUM(CASE WHEN pr.cancelado = 'No' THEN 1 ELSE 0 END), 0) AS num_pedidos_ok,
    nvl(SUM(CASE WHEN pr.cancelado = 'No' THEN pr.pizzas ELSE 0 END), 0) AS num_pizzas_ok,
    nvl(SUM(CASE WHEN pr.cancelado = 'No' THEN 1 ELSE 0 END) * 100 / NULLIF(SUM(CASE WHEN pr.cancelado IN ('Si', 'No') THEN 1 ELSE 0 END), 0), 0) AS pct_pedidos_ok,
    nvl(SUM(CASE WHEN pr.cancelado = 'No' THEN pr.pizzas_mod ELSE 0 END) * 100 / NULLIF(SUM(CASE WHEN pr.cancelado = 'No' THEN pr.pizzas ELSE 0 END), 0), 0) AS pct_pizzas_ok_mod
FROM SQL_EN_LLAMAS.CASE02.RUNNERS r
LEFT JOIN pedidos_runner pr
       ON r.runner_id = pr.runner_id
GROUP BY r.runner_id;



/*
JUANPE: 

Resultado: Correcto.  

Código: Correcto. La lógica de tu solución me ha gustado mucho, es similar a unas de las solucioens que yo tengo. Usar dos columnas 
de flag "modificado" y "cancelado" es muy original. Yo prefiero un 1 o 0 en vez de si o no para que en la select final poder ahorrarme 
tanto case when y jugar con unas multiplicaciones.

Legibilidad: Correcta. Bien tabulado y ordenado. Y bien por lo "corto" que se te ha quedado al usar esas columnas que te han servido de FLAG. 
En la select final considero mejor una subselect donde tener todos los conteos y luego por fuera dar los resultados y hacer la division para
los porcentajes, es decir, yo personalmente sacrifico tener unas lineas más de código por no tener la linea de pct_pedidos_ok y pct_pizzas_ok_mod
tan larga.

Extra: Hubiera estado bien ver los porcentajes redondeados a dos decimales. Muy bien por los resutlados del 4 venir 0 en lugar de nulos.

*/
