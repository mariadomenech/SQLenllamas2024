with pizza_name as (
    select 
        *,
        decode(pizza_name,'Meatlovers', 12, 'Vegetarian', 10, null) as price
    from    
        SQL_EN_LLAMAS.CASE02.PIZZA_NAMES
),
runner_orders_clean as (
    select 
        order_id,
        runner_id,
        case 
            when cancellation not in ('Restaurant Cancellation', 'Customer Cancellation') then null::string
            else cancellation
        end as cancellation,
        decode(pickup_time,'null',null,pickup_time) as pickup_time,
        decode(distance, 'null',null,trim(replace(distance, 'km', '')))::number(35,2) as distance,
        decode(duration, 'null',null,trim(regexp_replace(duration,'[A-z]',' ')))::number(35,2) as duration
        
    from SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS

), customer_orders_clean AS (
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
),
metricas_pedidos as (
    select 
        co.order_id,
        sum(p.price + nvl( ARRAY_SIZE( STRTOK_TO_ARRAY(co.extras, ',') ) ,0))  as  pizza_price
        
    from 
        customer_orders_clean as co
    inner join 
        pizza_name as p on co.pizza_id = p.pizza_id
    group by 
        order_id

)
select 

    sum(mp.pizza_price - ro.distance * 0.3) as total_profits
from 
    metricas_pedidos as mp
inner join
    runner_orders_clean as ro on mp.order_id = ro.order_id and ro.cancellation is null;
