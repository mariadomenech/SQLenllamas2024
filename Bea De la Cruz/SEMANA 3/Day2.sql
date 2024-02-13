
with tabla as(
    select
        customer_id,
        mes
    from (
        select 
            customer_id,
            monthname(txn_date) as mes,
            iff(txn_type = 'deposit',1,0) as deposit,
            iff(txn_type = 'purchase',1,0) as purchase,
            iff(txn_type = 'withdrawal',1,0) as withdrawal
        from customer_transactions
        )
    group by customer_id,mes
    having (sum(deposit) > 1 and sum(purchase) > 1) or sum(withdrawal) > 1
)
select mes,count(*) as num_clientes
from tabla
group by mes;
