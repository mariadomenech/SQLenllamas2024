
with conteos as (
    select
        txn_id,
        count(distinct prod_id) as conteo_prod
    from sales
    group by txn_id
    having conteo_prod > 3
),
lista as (
    select
        s.txn_id,
        listagg(product_name,', ') within group (order by prod_id) as lista_prod
    from sales s
    inner join product_details pd
        on s.prod_id = pd.product_id
    group by s.txn_id
)
select 
    b.lista_prod,
    count(distinct a.txn_id) as num_transacciones
from conteos a
inner join lista b
    on a.txn_id = b.txn_id
group by b.lista_prod
order by num_transacciones desc
limit 1;
