SELECT A."customer_id" AS CLIENTE,
SUM(B."price") AS TOTAL
FROM SALES A
JOIN MENU B
ON A."product_id"=B."product_id"
GROUP BY A."customer_id"
ORDER BY A."customer_id"
