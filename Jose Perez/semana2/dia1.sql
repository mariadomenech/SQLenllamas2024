with runner_orders_clean as (
    select 
        order_id,
        runner_id,
        case 
            when cancellation not in ('Restaurant Cancellation', 'Customer Cancellation') then null::string
            else cancellation
        end as cancellation
        
        
    from SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS

), 
customer_orders_clean AS (
    select 
        order_id,
        customer_id,
        pizza_id,
        case 
            when trim(exclusions) = '' or lower(trim(exclusions)) = 'null' then null
            else exclusions
        end as exclusions,
        case 
            when trim(extras) = '' or lower(trim(extras)) = 'null' then null
            else extras
        end as extras
    from SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
), orders_metrics as (
    select
        ro.runner_id, 
        count( distinct ro.order_id ) as total_orders,
        count( distinct case
                            when ro.cancellation is not null then ro.order_id
                       end ) as total_cancelled_orders,
        count( case
                when ro.cancellation is null then co.pizza_id
              end ) as total_pizzas,
        count(case
                when 
                    ro.cancellation is null and 
                    ( co.exclusions is not null or co.extras is not null)
                then co.pizza_id
              end ) total_pizzas_with_modification
    from runner_orders_clean as ro
    inner join customer_orders_clean as co
        on ro.order_id = co.order_id 
    group by 
        ro.runner_id
)
select 
    runner_id,
    total_orders - total_cancelled_orders as total_uncancelled_orders,
    total_pizzas,
    (100 * (case 
                when total_orders = 0 then 1
                else total_uncancelled_orders / total_orders
            end))::number(35,2) as delivery_percentage,   
    (100 * (case 
                when total_pizzas = 0 then 1
                else total_pizzas_with_modification / total_pizzas
            end))::number(35,2) as deliveries_with_modifications
    
from orders_metrics;
