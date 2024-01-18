SELECT 
    a.customer_id AS cliente,
    SUM(b.price) AS precio_total
FROM 
    SQL_EN_LLAMAS.CASE01.SALES AS a
INNER JOIN 
    SQL_EN_LLAMAS.CASE01.MENU AS b
ON 
    a.product_id = b.product_id
GROUP BY 
    a.customer_id;