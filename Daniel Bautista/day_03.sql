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
