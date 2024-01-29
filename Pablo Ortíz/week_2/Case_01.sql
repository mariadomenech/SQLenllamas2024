-- Limpio la tabla customer_orders
with Customersorders as (
select order_ID
, CUSTOMER_ID
, pizza_id
,case 
    when exclusions in('null','') then null
    else exclusions
    end as exclusions
, case 
    when extras in('null','') then null
    else extras
    end as extras
, order_time
from customer_orders
),
-- limpio la tabla de runners_orders
Runnersorder as (
select order_id
, runner_id
, case 
    when pickup_time in('null','') then null
    else pickup_time end as pickup_time
, case 
    when distance in('null','') then null
    else distance end as distance
, case 
    when duration in('null','') then null
    else duration end as duration
, case 
    when cancellation in('null','') then null
    else cancellation end as cancellation
from runner_orders
),

-- pedidos por runner
pedidos_runner as (
select b.runner_id
, count(a.order_ID) as pedidos
from runnersorder as a
right join runners as b
on a.runner_id=b.runner_id
group by b.runner_id
),

--pedidos bien por runner
pedidos_ok_runner as (
select b.runner_id
, count(a.order_ID) as pedidos_OK
from runnersorder as a
right join runners as b
on a.runner_id=b.runner_id
where a.cancellation is null
group by b.runner_id
),

-- pizzas por runner
pizzas_runner as (
select c.runner_id
, count(pizza_id) as pizzas
from Customersorders as a
left join Runnersorder as b
on a.order_id=b.order_id
right join runners as c
on b.runner_id=c.runner_id
group by c.runner_id
),

-- pizzas OK por runner
pizzas_OK_runner as (
select c.runner_id
, count(pizza_id) as pizzas_OK
from Customersorders as a
right join runnersorder as b
on a.order_id=b.order_id
right join runners as c
on b.runner_id=c.runner_id
where b.cancellation is null
group by c.runner_id
),

-- pizzas con modificaciones
pizzas_modificadas as(
select c.runner_id
, count(pizza_id) as pizzas_modificadas
from Customersorders as a
right join runnersorder as b
on a.order_id=b.order_id
right join runners as c
on b.runner_id=c.runner_id
where b.cancellation is null and (a.exclusions is not null or a.extras is not null)
group by c.runner_id

),
-- Tabla resumen

resumen as(
select a.runner_id
,pedidos
,pedidos_OK
,pizzas
,pizzas_OK
,case 
    when pizzas_modificadas is null then 0 else pizzas_modificadas end as pizzas_modificadas
from pedidos_runner as a
left join pedidos_ok_runner as b
on a.runner_id=b.runner_id
left join pizzas_runner as c
on a.runner_id=c.runner_id
left join pizzas_ok_runner as d
on a.runner_id=d.runner_id
left join pizzas_modificadas as e
on a.runner_id=e.runner_id
)

-- Resultado
select runner_id
, pedidos_ok
, pizzas_ok
,case 
    when pedidos <> 0 then round((pedidos_ok/pedidos)*100,2) else 0 end as pct_exito_pedidos
, case
    when pizzas <> 0 then round((pizzas_ok/pizzas)*100,2) else 0 end as pct_exito_pizzas
, case 
when pizzas_ok <> 0 then round((pizzas_modificadas/pizzas_ok)*100,2) else 0 end as pct_pizzas_modificadas
from resumen
 order by runner_id asc
;

-- He estado muy liado con el trabajo la semana pasada y el finde, intentare ponerme al día esta semana, lo siento! 
-- Pero no penseis que estoy desanimado, me está pareciendo muy chulo el reto :)

-- He estado muy liado con el trabajo la semana pasada y el finde, intentare ponerme al día esta semana, lo siento! 
-- Pero no penseis que estoy desanimado, me está pareciendo muy chulo el reto :)
