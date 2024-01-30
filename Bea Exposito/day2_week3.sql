/* Para cada mes,¿ cuántos clientes realizan más de 1 deposito y 1 compra o 1 retiro en un solo mes  ?*/
SELECT
    month_date AS month
   ,COUNT(customer_id) AS total_clients
FROM (
        SELECT
            customer_id
           ,n_month
           ,month_date
        FROM (
            SELECT
                customer_id
               ,EXTRACT(MONTH FROM txn_date) AS n_month
               ,MONTHNAME(txn_date) AS month_date
               ,CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END AS deposit
               ,CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END AS purchase
               ,CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END AS withdrawl
            FROM CUSTOMER_TRANSACTIONS
        ) A
        GROUP BY 1,2,3
        HAVING (SUM(A.deposit) > 1 AND SUM(A.purchase) > 1) OR SUM(A.withdrawl) > 1
        ORDER BY 2
)
GROUP BY 1;