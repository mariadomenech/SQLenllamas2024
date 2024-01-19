/*Calculamos cuántos días ha visitado cada cliente el restaurante*/
SELECT
    mb.customer_id,
    nvl(COUNT(DISTINCT s.order_date), 0) AS days_visited
FROM SQL_EN_LLAMAS.CASE01.MEMBERS mb
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES s
    ON mb.customer_id = s.customer_id
GROUP BY mb.customer_id;
