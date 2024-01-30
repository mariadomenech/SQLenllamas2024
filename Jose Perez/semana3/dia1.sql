with nodes_previous_and_next as(
    select
        customer_id,
        region_id,
        node_id,
        start_date,
        end_date,
        nvl(LAG(node_id) OVER (PARTITION BY customer_id ORDER BY end_date), -1) as previous_node,
        nvl(LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY end_date), -1) as next_node

    from 
        SQL_EN_LLAMAS.CASE03.CUSTOMER_NODES
    where 
        end_date != to_date('9999-12-31')
    order by customer_id, end_date, region_id, node_id
),
clean_intermediates as (
    select
        *
    from nodes_previous_and_next
    where not (next_node = node_id  and previous_node = node_id)
    order by  start_date

),
get_date_ranges as (
    select
        distinct customer_id,
        region_id,
        node_id,
        case 
            when previous_node = node_id then LAG(start_date) OVER (PARTITION BY customer_id ORDER BY end_date)
            when previous_node != node_id then start_date
        end as new_start_date,
        case 
            when next_node = node_id then LEAD(end_date) OVER (PARTITION BY customer_id ORDER BY end_date)
            when next_node != node_id then end_date
        end as new_end_date
    from 
        clean_intermediates
    order by  
        new_start_date
) 
select 
    avg( (new_end_date + 1) - new_start_date)::number(10,2) as average_node_change
from get_date_ranges;
