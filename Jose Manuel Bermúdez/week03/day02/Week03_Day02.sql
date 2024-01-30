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