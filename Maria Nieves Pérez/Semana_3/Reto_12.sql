WITH primera AS (

SELECT 
    distinct customer_id,
    txn_type, 
    TO_DATE(txn_date) as txn_date,
    count(txn_type) over (partition by customer_id, txn_type) as num_operaciones_total
FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
order by customer_id, txn_date
),

segunda AS (
    SELECT 
        customer_id,
        month(txn_date) as mes,
        CASE WHEN txn_type = 'deposit' THEN num_operaciones_total 
            ELSE 0 END AS num_depositos,
        CASE WHEN txn_type = 'purchase' THEN num_operaciones_total 
            ELSE 0 END AS num_compras,
        CASE WHEN txn_type = 'withdrawal' THEN num_operaciones_total
            ELSE 0 END AS num_retiros
    FROM primera
),

tercera AS (
    SELECT 
        mes,
        count(customer_id) as num_clientes
    FROM segunda
    WHERE (num_depositos > 1 AND num_compras > 1) OR num_retiros > 1
    GROUP BY mes
    ORDER BY mes asc
)

select * from tercera;
/*COMENTARIOS JUANPE

RESULTADO: INCORRECTO

CÓDIGO: INCORRECTO. En la CTE primera en el partition by te falta txn_date y en la CTE segunda te falta GROUP BY customer_id,mes y cada uno de los CASE WHEN meterlos dentro de un SUM.

LEGIBILIDAD: CORRECTA

EXTRA: lo haces un poco enrevesado te paso una solución más simple:

SELECT MES
     , COUNT(CUSTOMER_ID) AS CLIENTES
FROM (SELECT CUSTOMER_ID
           , EXTRACT(MONTH FROM TXN_DATE) AS MES
           , SUM(CASE WHEN TXN_TYPE = 'deposit'    THEN 1 ELSE 0 END) AS DEPOSITO
           , SUM(CASE WHEN TXN_TYPE = 'purchase'   THEN 1 ELSE 0 END) AS COMPRA
           , SUM(CASE WHEN TXN_TYPE = 'withdrawal' THEN 1 ELSE 0 END) AS RETIRO
       FROM CUSTOMER_TRANSACTIONS
       GROUP BY MES, CUSTOMER_ID
      ) A
WHERE (DEPOSITO > 1 AND COMPRA > 1) OR RETIRO > 1
GROUP BY MES
ORDER BY MES;
*/
