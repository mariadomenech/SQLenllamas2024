SELECT 
    a.customer_id AS cliente,
    COUNT(distinct a.order_date) AS visitas
FROM 
    SQL_EN_LLAMAS.CASE01.SALES AS a
GROUP BY 
    a.customer_id;
