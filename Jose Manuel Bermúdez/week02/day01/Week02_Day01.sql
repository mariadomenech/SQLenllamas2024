USE sql_en_llamas;
USE SCHEMA case02;

SELECT runner_id AS "Runner",
		(COUNT(DISTINCT(CASE WHEN NOT (cancellation <> 'null' AND cancellation <> '' AND cancellation IS NOT NULL) THEN ro.order_id END))) AS "Número de pedidos entregados con éxito",
		(COUNT(CASE WHEN NOT (cancellation <> 'null' AND cancellation <> '' AND cancellation IS NOT NULL) THEN ro.order_id END)) AS "Número de pizzas entregadas con éxito",
		((COUNT(DISTINCT(CASE WHEN NOT (cancellation <> 'null' AND cancellation <> '' AND cancellation IS NOT NULL) THEN ro.order_id END))) /
			(COUNT(DISTINCT(ro.order_id))) * 100)  AS "Porcentaje Éxito Pedidos",
		(COUNT(CASE WHEN ((exclusions <> 'null' AND exclusions <> '' AND exclusions IS NOT NULL) OR (extras <> 'null' AND extras <> '' AND extras IS NOT NULL)) AND NOT (cancellation <> 'null' AND cancellation <> '' AND cancellation IS NOT NULL) THEN co.pizza_id END) /
			((COUNT(CASE WHEN NOT (cancellation <> 'null' AND cancellation <> '' AND cancellation IS NOT NULL) THEN ro.order_id END))) * 100) AS "Porcentaje Pizzas Entregadas Con Modificaciones"
FROM customer_orders co 
	JOIN runner_orders ro
	ON co.order_id = ro.order_id
GROUP BY ro.runner_id;
