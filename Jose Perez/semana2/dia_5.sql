--Hecho antes de que pasarais más ayuda por el grupo. Está hecho un poco a mi manera y quizás me he liado mucho por querer hacerlo de forma dinámica para
--no fijar un número máximo de ingredientes
create or replace temporary table SQL_EN_LLAMAS.CASE02.pizzas as 
with customer_orders_clean AS (
    select 
        order_id,
        customer_id,
        pizza_id,
        case 
            when trim(exclusions) = '' or lower(trim(exclusions)) = 'null' then null
            when trim(exclusions) = 'beef' then '3'
            else exclusions
        end as exclusions,
        case 
            when trim(extras) = '' or lower(trim(extras)) = 'null' then null
            else extras
        end as extras
    from SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS
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
),
ingredientes_array as (
    select 
        co.order_id,
        co.pizza_id,
        STRTOK_TO_ARRAY(replace(co.exclusions, ', ', ','), ',') as array_exclusions,
        STRTOK_TO_ARRAY(replace(co.extras, ', ', ','), ',') as array_extras,
        STRTOK_TO_ARRAY(replace(pr.toppings, ', ', ','), ',') as array_toppings
        
    from 
        customer_orders_clean as co
    inner join 
        SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES as pr on co.pizza_id = pr.pizza_id
    inner join 
        runner_orders_clean as ro on ro.order_id = co.order_id
    where 
        ro.cancellation is null
),
array_restas as (
    select
        order_id,
        pizza_id,
        array_exclusions,
        array_extras,
        array_toppings,
        case 
            when array_extras is not null and array_exclusions is null then array_cat(array_extras ,array_toppings)
            when array_extras is null and array_exclusions is not null then array_except(array_toppings, array_exclusions)
            when array_extras is not null and array_exclusions is not null then array_cat(array_except(array_toppings, array_exclusions),array_extras)
            else  array_toppings
        end as ingredientes,
        array_size(ingredientes) as tamanio
    from ingredientes_array
   
)
 select * from array_restas;

declare
  sql string;
  res resultset;
  max_size int;
begin
    max_size := (select max(tamanio) from SQL_EN_LLAMAS.CASE02.pizzas);
    sql := 'create or replace temporary table  SQL_EN_LLAMAS.CASE02.pizzas_sin_unpivot as select ';
    FOR i IN 0 TO max_size - 1 DO
            sql := sql || 'INGREDIENTES[' || i || ']::int as topping_'||i||',';
    END FOR;
    sql := sql || '* from SQL_EN_LLAMAS.CASE02.pizzas';
    res := (execute immediate :sql);
    --return sql;
end;

declare
  sql string;
  res resultset;
  max_size int;
  last int;
begin
    max_size := (select max(tamanio) from SQL_EN_LLAMAS.CASE02.pizzas);
    sql := 'create or replace temporary table  SQL_EN_LLAMAS.CASE02.pizzas_unpivot as select order_id, pizza_id, topping_id from SQL_EN_LLAMAS.CASE02.pizzas_sin_unpivot unpivot(topping_id for topping_position in (';
    FOR i IN 0 TO max_size - 2 DO
            sql := sql || 'topping_'|| i ||',';
    END FOR;
    last := max_size - 1;
    sql := sql || 'topping_'|| last ||'))';
    res := (execute immediate :sql);
end;

select 
    pt.topping_id,
    pt.topping_name,
    count(pt.topping_id) as numero_veces_repetidos
from 
    SQL_EN_LLAMAS.CASE02.pizzas_unpivot as pu
inner join  
    SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS as pt on pt.topping_id = pu.topping_id
group by pt.topping_id, pt.topping_name
order by 1;
