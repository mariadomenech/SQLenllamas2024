WITH PrimerPedido AS (
    SELECT 
        a.customer_id,
        a.product_id,
        a.order_date,
        ROW_NUMBER() OVER (PARTITION BY a.customer_id ORDER BY a.order_date) as row_num
    FROM 
        SQL_EN_LLAMAS.CASE01.SALES as a
)
SELECT 
    b.customer_id,
    c.product_name,
    b.order_date as fecha_primer_pedido
FROM 
    PrimerPedido b
JOIN 
    SQL_EN_LLAMAS.CASE01.MENU c ON b.product_id = c.product_id
WHERE 
    b.row_num = 1;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

La fecha no se pide en el ejercicio y el ROW_NUMBER no saca los empates por lo que perderías registros, en su lugar usaría RANK.
También usaría LISTAGG para simplificar la salida de la query teniendo un único registro por cada cliente, y cruzaría con la tabla MEMBERS para sacar los clientes sin pedidos.

WITH PrimerPedido AS (
    SELECT 
        c.customer_id,
        a.product_id,
        b.product_name,
        a.order_date,
        RANK() OVER (PARTITION BY a.customer_id ORDER BY a.order_date) as rk
    FROM SQL_EN_LLAMAS.CASE01.SALES as a
    INNER JOIN SQL_EN_LLAMAS.CASE01.MENU b 
        ON a.product_id = b.product_id
    RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS c
        ON a.customer_id = c.customer_id
)

SELECT 
    customer_id,
    LISTAGG(distinct ifnull(product_name, 'Sin producto'), ', ') as product
FROM PrimerPedido
WHERE rk = 1
GROUP BY customer_id;

*/
