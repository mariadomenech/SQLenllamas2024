with previus_and_next_nodes as (
    select 
        *,
        LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY end_date) as next_node

    from 
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    where 
        end_date != to_date('9999-12-31') 
        
    order by customer_id, end_date, region_id, node_id
)
select 
    avg((end_date + 1) - start_date)::number(10,2) as average_node_change 
from previus_and_next_nodes
where 
    next_node != node_id ; 
