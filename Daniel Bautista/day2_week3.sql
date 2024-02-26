SELECT 
    MONTHNAME(a.txn_date) as mes,
    COUNT(DISTINCT a.customer_id) AS conteo
FROM 
    SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS AS a
WHERE 
    a.txn_type in ('deposit','purchase') OR a.TXN_TYPE = 'withdrawal'
GROUP BY 
    MONTHNAME(a.txn_date)
HAVING 
    COUNT(DISTINCT CASE WHEN a.txn_type IN ('deposit', 'purchase') THEN a.customer_id ELSE NULL END) > 1
    OR COUNT(DISTINCT CASE WHEN a.txn_type = 'withdrawal' THEN a.customer_id ELSE NULL END) = 1;
