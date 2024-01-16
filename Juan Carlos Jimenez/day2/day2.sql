SELECT customer_id, count(distinct order_date) AS DIAS_VISITADOS
FROM SALES S
GROUP BY 1;
