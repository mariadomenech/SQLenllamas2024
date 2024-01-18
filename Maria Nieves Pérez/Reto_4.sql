SELECT 
    product_name AS "Producto más vendido",
    COUNT(a.product_id) AS "Cantidad"
    
FROM SQL_EN_LLAMAS.CASE01.SALES a
    INNER JOIN SQL_EN_LLAMAS.CASE01.MENU b
        ON a.product_id=b.product_id
WHERE a.product_id = (
    SELECT max(product_id) 
    FROM SQL_EN_LLAMAS.CASE01.SALES
    )
GROUP BY product_name;

