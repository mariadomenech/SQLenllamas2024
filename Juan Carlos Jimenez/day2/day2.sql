SELECT M.customer_id, ZEROIFNULL(count(distinct S.order_date)) AS DIAS_VISITADOS
FROM MEMBERS M
FULL JOIN SALES S
ON M.customer_id= S.customer_id
GROUP BY 1;
