USE SQL_EN_LLAMAS;
USE SCHEMA case03;

SELECT AVG(days_to_reassign) as "Número de días promedio en que se reasignan los clientes a un nodo diferente"
FROM
	(SELECT customer_id,
			start_date,
			CASE
				WHEN LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY start_date) IS NOT NULL THEN
					(end_date - start_date) 
				ELSE
					0
			END AS days_to_reassign
	 FROM customer_nodes)
	 WHERE days_to_reassign > 0;
