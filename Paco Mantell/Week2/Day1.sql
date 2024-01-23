WITH CTE_STATUS AS (
    /*Creamos dos estados de entrega*/
    SELECT A.runner_id,
        B.order_id,
        CASE
            WHEN B.cancellation = 'Restaurant Cancellation' THEN 'C'
            WHEN B.cancellation = 'Customer Cancellation' THEN 'C'
            ELSE 'D'
        END status
    FROM sql_en_llamas.case02.runners A
    LEFT JOIN sql_en_llamas.case02.runner_orders B
    ON A.runner_id=B.runner_id
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
    AND B.status = 'D'
    GROUP BY 1,3
)
/*Mostramos todo*/
SELECT A.runner_id,
    A.pedidos_entregados,
    A.pizzas_entregadas,
    (A.pedidos_entregados / B.pedidos_totales) * 100 SUCCESS_ORDER_PERCENT,
    (D.tot_mod_pizzas / A.pizzas_entregadas) * 100 PIZZA_MOD_PERCENT
FROM CTE_DELIVERED A
RIGHT JOIN CTE_TOTALS B
    ON A.runner_id=B.runner_id
RIGHT JOIN CTE_MOD_PIZZAS D
    ON A.runner_id=D.runner_id


/*************************/
/*** COMENTARIO JUANPE***/
/************************/
/*
La PIZZA_ID 2 del ORDER_ID 3, te sale como ‘SI modificada’ y no lo es el motivo de que te salga es que estás poniendo:
    LENGTH(A.extras) = null
y eso sql no lo hace bien, tienes que cambiar el "=" por "is":
    LENGTH(A.extras) is null
Veras que con este cambio los resultados salen igual a lo que María ha pasado por el grupo.
*/

--El comentario anterior se borro al actuilizar tu código lo vuelvo a poner:

/*************************/
/*** COMENTARIO JUANPE***/
/************************/
/*
La PIZZA_ID 2 del ORDER_ID 3, te sale como ‘SI modificada’ y no lo es, revisa tu query.
A parte la pizza del pedido ORDER_ID 9 aunque si tiene modificaciones está cancelada por tanto no puedes sumarla, 
ya que el porcentaje de pizzas modificadas es respecto de las entregadas.
Hecho en falta al runner que no ha realizado ningun pedido. 
Vsualmente queda mejor si los porcentajes los redondeas a dos decimales.
En cuanto a la lógica establecida en tu query, el orden de los with, decir que muy clara y ordenada, primero el status, 
luego las entregas, luego toales, modificaciones y finalmente el resultado final, todo en pequeñas select muy claras, 
muy bien, solo faltaría los matices que te he comentado.
*/
