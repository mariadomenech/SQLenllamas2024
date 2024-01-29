--1º intento, solo consigo las cuentas. 
SELECT  a.runner_id AS runner,
        COUNT(b.order_id) AS pizzasentregadas,
        COUNT(DISTINCT(b.order_id)) AS pedidosentregados
        FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS a
            LEFT JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS b
                ON a.order_id = b.order_id
            WHERE a.pickup_time <> 'null'
            GROUP BY a.runner_id

--En realidad es parte de un código más largo pero no funcional. Tendré que comenzar de cero el código ahora que sé que puedo enlazar tablas temporales una detrás de otra
WITH 
t_entregas AS (
SELECT  a.runner_id AS runner,
        COUNT(b.order_id) AS pizzasentregadas,
        COUNT(DISTINCT(b.order_id)) AS pedidosentregados
        FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS a
            LEFT JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS b
                ON a.order_id = b.order_id
            WHERE a.pickup_time <> 'null'
            GROUP BY a.runner_id
            ),
t_totales AS (
SELECT  a.runner_id AS runner,
        COUNT(b.order_id) AS pizzas,
        COUNT(DISTINCT(b.order_id)) AS pedidos
        FROM SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS a
            LEFT JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS b
                ON a.order_id = b.order_id
            GROUP BY a.runner_id
            )
SELECT  a.runner_id,
        pizzasentregadas/pizzas,
        pedidosentregados/pedidos
        FROM t_entregas
            LEFT JOIN t_totales
                ON a.runner_id
                GROUP BY a.runner_id

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

¿No está el código acabado? Tiene buena pinta, pero acábame los cruces del final, te va a salir el resultado correcto.

*/
