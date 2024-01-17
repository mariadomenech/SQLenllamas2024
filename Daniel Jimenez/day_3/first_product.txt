//¿Cual es el primer producto que ha pedido cada cliente?
WITH PrimerPedido AS (
    SELECT customer_id, 
    MIN(order_date) as PrimerFecha
    FROM SQL_EN_LLAMAS.CASE01.SALES
    GROUP BY customer_id
)

SELECT  members.customer_id ,
        COALESCE(menu.product_name, 'No ha hecho pedidos') as product_name, 
        COALESCE(CAST(menu.price AS VARCHAR), 'No ha hecho pedidos') as price,
        COALESCE(CAST(pp.PrimerFecha AS VARCHAR), 'No ha hecho pedidos') as PrimerFecha
FROM SQL_EN_LLAMAS.CASE01.MEMBERS
LEFT JOIN PrimerPedido pp 
    ON members.customer_id = pp.customer_id
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES 
    ON members.customer_id = sales.customer_id
    AND pp.PrimerFecha = sales.order_date
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
    ON sales.product_id = menu.product_id;
