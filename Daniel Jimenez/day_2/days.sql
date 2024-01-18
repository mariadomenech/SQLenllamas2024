//¿Cuantos días ha visitado cada cliente el restaurante?
SELECT  A.customer_id as id_cliente ,
        COUNT(DISTINCT B.order_date) as dias_totales
FROM    SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN    SQL_EN_LLAMAS.CASE01.SALES B
    ON A.customer_id = B.customer_id
GROUP BY 1
ORDER BY 2 DESC;
