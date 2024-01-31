WITH CUSTOMER_TRANSACTIONS_PIVOT AS (
SELECT *
FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    PIVOT(COUNT(TXN_TYPE) FOR TXN_TYPE IN('withdrawal','deposit', 'purchase')) AS p
ORDER BY CUSTOMER_ID,TXN_DATE
)
---Consulta principal para calcular el distinto numero de clientes por cada mes que cumple la condicion del where
SELECT 
    MES,
    COUNT(DISTINCT CUSTOMER_ID) AS NUM_CLIENTES    
FROM(
    ---Subconsulta para calcular el total de depositos,compras y retiros por cada mes
    SELECT 
        CUSTOMER_ID, 
        EXTRACT(MONTH,TXN_DATE) AS MES, 
        SUM("'withdrawal'") AS WITHDRAWAL,
        SUM("'deposit'") AS DEPOSIT, 
        SUM("'purchase'") AS PURCHASE
    FROM CUSTOMER_TRANSACTIONS_PIVOT
    GROUP BY 1,2
)
WHERE DEPOSIT>1 AND PURCHASE>1 OR WITHDRAWAL>1
GROUP BY 1
ORDER BY 1;