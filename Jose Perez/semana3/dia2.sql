with create_colum_txn_type as(
    select 
        customer_id,
        concat(split(txn_date, '-')[0],'-',split(txn_date, '-')[1]) as year_month,
        decode(txn_type,'deposit',1,0) as deposit,
        decode(txn_type,'purchase',1,0) as purchase,
        decode(txn_type,'withdrawal',1,0) as withdrawal
    from SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
),
total_txn_type as (
    select 
        customer_id, 
        year_month
    from 
        create_colum_txn_type
    group by 
        customer_id, year_month
    having 
        (sum(deposit) > 1 and sum(purchase) > 1) or sum(withdrawal) > 1
)  
select
    year_month,
    count(*) as total_customers
from 
    total_txn_type
group by 
    year_month;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto Jose!! Para sacar los meses, en vez de splitear la fecha también puedes hacer uso de la función MONTHNAME(TXN_DATE)


*/
