SELECT men.product_name AS "Producto Más Pedido Del Menú", COUNT(sal.product_id) AS "Número Veces Ha Sido Pedido"
FROM sales sal, menu men
WHERE
	men.product_id = sal.product_id
GROUP BY men.product_name
ORDER BY COUNT(sal.product_id) DESC
LIMIT 1;
