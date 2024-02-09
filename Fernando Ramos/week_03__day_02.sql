with pivot as (
select 
    *
from SQL_EN_LLAMAS.CASE03.customer_transactions
    PIVOT (count(txn_type)
        FOR txn_type IN ('deposit','purchase','withdrawal'))
            AS A (customer_id, txn_date, txn_amount, deposit, purchase, withdrawall)
),

cuenta as (
select
      customer_id
    , month(txn_date) as month
from pivot
    group by 1,2
    having (sum(deposit)>1 and sum(purchase)>1) or sum(withdrawall)>1
)

select
      month as mes
    , count (customer_id) as n_clientes
from cuenta
    group by month
    order by mes asc

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Muy bien Fernando, resultado correcto. Y guay que hayas utilizado el pivot!! 

*/
