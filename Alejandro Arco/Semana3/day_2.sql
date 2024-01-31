/* Day 2
    Para cada mes, ¿Cuántos clientes realizan más de 1 depósito y 1 compra o 1 retiro en un solo mes?
    Explicación: al menos 2 depósitos y 2 compras Ó al menos 2 retiros
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;

WITH COUNT_CUSTOMER AS (
    SELECT
        customer_id,
        EXTRACT(MONTH FROM TXN_DATE) as txn_month,
        SUM(CASE
                WHEN txn_type = 'deposit' THEN 1
                ELSE 0
            END
        ) as deposit_count,
        SUM(CASE
                WHEN txn_type = 'purchase' THEN 1
                ELSE 0
            END
        ) as purchase_count,
        SUM(CASE
                WHEN txn_type = 'withdrawal' THEN 1
                ELSE 0
            END
        ) as withdrawal_count
    FROM CUSTOMER_TRANSACTIONS
    GROUP BY customer_id, txn_type, EXTRACT(MONTH FROM TXN_DATE)
    ORDER BY EXTRACT(MONTH FROM TXN_DATE)
)

SELECT
    txn_month,
    COUNT(customer_id) as customer_count
FROM COUNT_CUSTOMER
WHERE (deposit_count > 1 AND purchase_count > 1)
    OR withdrawal_count > 1
GROUP BY txn_month;