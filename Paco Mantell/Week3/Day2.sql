WITH CTE_COUNT_TXN_TYPE AS(
    /*Contamos cuantos tipos de transacciones hace cada cliente cada mes*/
    SELECT customer_id,
        MONTH(txn_date) txn_month,
        txn_type,
        COUNT(txn_type) cant_type_txn
    FROM sql_en_llamas.case03.customer_transactions
    GROUP BY 1,2,3
)
/*Cuento el numero de transacciones con más de un tipo de cada por mes*/
SELECT txn_month "month",
    COUNT(customer_id) cust_quantity
FROM CTE_COUNT_TXN_TYPE
WHERE cant_type_txn > 1
GROUP BY 1
