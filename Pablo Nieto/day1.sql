/*Calculamos cuánto ha gastado cada cliente en total en el restaurante*/
SELECT
    s.customer_id,
    SUM(m.price) AS total_gastado
FROM SQL_EN_LLAMAS.CASE01.SALES s
JOIN SQL_EN_LLAMAS.CASE01.MENU m
    ON s.product_id = m.product_id
GROUP BY s.customer_id;