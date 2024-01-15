SELECT 
     S.customer_id
    ,SUM(price) as total_gastado
FROM SQL_EN_LLAMAS.CASE01.SALES S
JOIN SQL_EN_LLAMAS.CASE01.MENU M
    ON S.product_id = M.product_id
GROUP BY 1;
