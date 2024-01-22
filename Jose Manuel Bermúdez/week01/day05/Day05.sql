SELECT mem.customer_id AS "CLIENTE",
	   COALESCE(SUM(CASE WHEN men.product_id = 1 THEN 2 * 10 * men.price
		    		ELSE 10 * men.price
					END)
				, 0) AS "PUNTOS TOTALES"
FROM sales sal
	JOIN menu men ON sal.product_id = men.product_id
	RIGHT JOIN members mem ON mem.customer_id = sal.customer_id
GROUP BY mem.customer_id
ORDER BY mem.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Jose Manuel!

*/
