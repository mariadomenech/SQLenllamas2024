select
    round(avg(datediff(day, start_date, end_date)),2) as diferencia
from (
    select 
        customer_id,  
        node_id, 
        start_date, 
        end_date, 
        lead(customer_id) over (order by customer_id, start_date) as cliente_posterior,
        lead(node_id) over (order by customer_id, start_date) as nodo_posterior
    from SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    )
where end_date != '9999-12-31' 
    and (nodo_posterior != node_id or customer_id != cliente_posterior)
order by customer_id, start_date;

