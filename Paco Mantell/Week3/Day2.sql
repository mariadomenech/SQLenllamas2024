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


/*COMENTARIOS JUANPE

RESULTADO: INCORRECTO

CÓDIGO: INCORRECTO. El problema está en que lo que pedía el ejercicio era: contar aquellos que cumplant (DEPOSITO > 1 AND COMPRA > 1) OR RETIRO > 1

La solución era:
SELECT ANYO
     , MES
     , COUNT(CUSTOMER_ID) AS CLIENTES
FROM (SELECT CUSTOMER_ID
           , EXTRACT(YEAR FROM TXN_DATE) AS ANYO
           , EXTRACT(MONTH FROM TXN_DATE) AS MES
           , SUM(DECODE(TXN_TYPE,'deposit',1,0))    AS DEPOSITO
           , SUM(DECODE(TXN_TYPE,'purchase',1,0))   AS COMPRA
           , SUM(DECODE(TXN_TYPE,'withdrawal',1,0)) AS RETIRO
       FROM CUSTOMER_TRANSACTIONS
       GROUP BY ANYO, MES, CUSTOMER_ID
      ) A
WHERE (DEPOSITO > 1 AND COMPRA > 1) OR RETIRO > 1
GROUP BY ANYO, MES
ORDER BY ANYO, MES;
*/
