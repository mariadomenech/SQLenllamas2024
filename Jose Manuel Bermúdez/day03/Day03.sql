SELECT DISTINCT sal.customer_id AS "CLIENTE", men.product_name "PRIMER PRODUCTO PEDIDO", sal.order_date AS "FECHA"
FROM sales sal
INNER JOIN
	(SELECT customer_id, MIN(order_date) AS fecha_primer_pedido
		FROM sales
		GROUP BY customer_id) PRIMER_PEDIDO
	ON sal.customer_id = PRIMER_PEDIDO.customer_id AND sal.order_date = PRIMER_PEDIDO.fecha_primer_pedido
JOIN menu men ON sal.product_id = men.product_id
ORDER BY sal.order_date, sal.customer_id, men.product_name;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 


Perfecto Jose Manuel!

Quizás como extra, porque lo que pedimos lo cumples, mejoraría la visualización de los resultados finales, de modo que sean más sencillos de interpretar
para alguien que vea el resultado en forma de tabla. Te invito a explorar la función LISTAGG.

*/
