SELECT M.customer_id,ZEROIFNULL(SUM(price)) as total_gastado
FROM SALES S
JOIN MENU ME
ON S.product_id = ME.product_id
full JOIN MEMBERS M
ON M.customer_id= S.customer_id
GROUP BY 1;
