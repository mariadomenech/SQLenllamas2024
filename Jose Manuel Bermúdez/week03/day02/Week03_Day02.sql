USE SQL_EN_LLAMAS;
USE SCHEMA case03;

WITH customer_transactions_by_type_of_operation AS (
    SELECT customer_id,
            txn_date,
            CASE
				WHEN LOWER(txn_type) = 'deposit' THEN
					1
				ELSE
					0
				END AS "deposit",
            CASE
				WHEN LOWER(txn_type) = 'purchase' THEN
					1
				ELSE
					0
				END AS "purchase",
            CASE
				WHEN LOWER(txn_type) = 'withdrawal' THEN
					1
				ELSE
					0
				END AS "withdrawal"
    FROM customer_transactions
),
customer_transactions_operations_executed AS (
	SELECT customer_id,
			TO_VARCHAR(txn_date, 'MM-yyyy') AS "MES",
			operation,
			SUM(num_ops) AS TOTAL
	FROM customer_transactions_by_type_of_operation
			unpivot(num_ops for operation in ("deposit", "purchase", "withdrawal"))
	GROUP BY customer_id, "MES", operation, num_ops
	HAVING num_ops = 1
	ORDER BY "MES" ASC
),
customer_transactions_operations_executed_criteria as (
	SELECT customer_id,
			"MES"
	FROM customer_transactions_operations_executed
	WHERE (((operation = 'deposit' AND total >= 2) AND (operation = 'purchase' AND total >= 2)) OR
			(operation = 'withdrawal' AND total >= 2))
	GROUP BY customer_id, "MES"
)

SELECT "MES",
		count(*) AS "NÚMERO CLIENTES +1 DEPÓSITO Y COMPRA Ó +1 RETIRO"
FROM customer_transactions_operations_executed_criteria
GROUP BY "MES";

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

La lógica del ejercicio tal cual la planteas empieza bien, pero, no creo que meter el unpivot en este ejercicio sea buena idea.

CÓDIGO: te explico con un ejemplo. Esta es la salida de tu CTE "customer_transactions_operations_executed_criteria" después del UNPIVOT para el customer_id = 389:

CUSTOMER_ID	MES		OPERATION	TOTAL
389		01-2020		deposit		2
389		01-2020		withdrawal	1
389		01-2020		purchase	1
389		02-2020		deposit		3
389		02-2020		purchase	2
389		02-2020		withdrawal	1
389		03-2020		deposit		2
389		04-2020		deposit		1

Según tu query debemos filtrar cuando:
(((operation = 'deposit' AND total >= 2) AND (operation = 'purchase' AND total >= 2)) OR
			(operation = 'withdrawal' AND total >= 2))

Tu resultado: nada, ninguna de las líneas cumplen el criterio. No es coherente, si le dices operation = 'purchase' nunca va a ser también operation = 'deposit'
Resultado correcto: en 02-2020 debemos contar este cliente 1 vez. 


Conclusión, te animo a intentar el código de nuevo, quitando las CTES customer_transactions_operations_executed y customer_transactions_operations_executed_criteria.
Desde tu primera CTE, puedes hacer algo parecido a lo que te propongo:

SELECT ANIO
	,MES
	,SUM(CASE 
			WHEN (
					NUM_DEPOSIT > 1
					AND NUM_PURCHASE > 1
					)
				OR NUM_withdrawal > 1
				THEN 1
			ELSE 0
			END) NUM_CLIENTES
FROM (
	SELECT MONTHNAME(TXN_DATE) AS MES
		,EXTRACT(YEAR FROM TXN_DATE) AS ANIO
		,CUSTOMER_ID
		,SUM(CASE 
				WHEN TXN_TYPE = 'deposit'
					THEN 1
				ELSE 0
				END) NUM_DEPOSIT
		,SUM(CASE 
				WHEN TXN_TYPE = 'purchase'
					THEN 1
				ELSE 0
				END) NUM_PURCHASE
		,SUM(CASE 
				WHEN TXN_TYPE = 'withdrawal'
					THEN 1
				ELSE 0
				END) NUM_withdrawal
	FROM CUSTOMER_TRANSACTIONS
	GROUP BY CUSTOMER_ID
		,MES
		,ANIO
	) 
GROUP BY ANIO
	,MES

*/
