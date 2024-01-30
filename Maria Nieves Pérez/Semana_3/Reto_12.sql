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
