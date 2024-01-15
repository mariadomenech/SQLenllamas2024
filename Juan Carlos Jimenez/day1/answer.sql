SELECT M."customer_id",SUM("price") as total_gastado
FROM SALES S
JOIN MEMBERS M
ON M."customer_id"= S."customer_id"
JOIN MENU ME
ON S."product_id" = ME."product_id"
GROUP BY 1;
