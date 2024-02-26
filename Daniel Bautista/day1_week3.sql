SELECT 
ROUND(AVG(DATEDIFF(DAY, a.start_date, a.end_date)),2) AS media_reasignacion
FROM 
    SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES AS a
WHERE 
a.end_date <> '9999-12-31';
