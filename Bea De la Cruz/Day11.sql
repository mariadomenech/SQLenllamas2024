
with tmp as (
    select 
        case
            when node_id = lead(node_id) over (order by customer_id,region_id,start_date) 
                and end_date is not null then datediff(day,start_date,lead(iff(end_date = '9999-12-31',null,end_date)) over (order by customer_id,region_id,start_date))
            when node_id != lead(node_id) over (order by customer_id,region_id,start_date) 
                and node_id = lag(node_id) over (order by customer_id,region_id,start_date) then null
            when node_id != lead(node_id) over (order by customer_id,region_id,start_date) 
                and node_id != lag(node_id) over (order by customer_id,region_id,start_date) then datediff(day,start_date,iff(end_date = '9999-12-31',null,end_date))
            when end_date is null then null
            else '999999'
        end as dias
    from tabla
)
select round(avg(dias)) as media_nodos
from tmp;