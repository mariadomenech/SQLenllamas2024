-- Limpio la tabla runners_order
with Runnersorder as (
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
) ,

-- Paso los valores de distancia y duracion a datos numericos
 Datos_limpios as (
 select runner_ID
 ,cast(replace(distance,'km','') as number(6,2)) as distancia_Km
 ,CAST(REPLACE(REPLACE(REPLACE(DURATION,'minutes',''),'mins',''),'minute','') AS NUMBER(6,2)) as duracion_minutos
 from runnersorder
 )
 ,

 -- Tabla con lo distancia por runner
 distancia_runners as (
 select runner_id
 , round(Sum(distancia_Km),2) as Distancia_acumulada_Km
 from Datos_limpios
group by runner_id
)
,

-- Tabla de lo que se paga a cada runner
Gasto_runner as (
select runner_id
, Round(Distancia_acumulada_Km*0.3,2) as pago_Euros
from distancia_runners
),

-- Tabla de gasto total
gasto_total as (
select sum(pago_euros) as Gasto_total
from Gasto_runner
),

-- Ahora voy a contar cuantas pizzas se venden en total y no son canceladas

-- Limpio la tabla customer_orders
Customersorders as (
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
Runnersorders as (
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

-- hago join en customersorders y runners orders para sacar la cantidad de pizzas que se venden (hay que excluir las canceladas, por eso necesito el join)

TablaAuxPizzas as (
select b.runner_id,a.pizza_id
from customersorders as a
left join runnersorders as b
on a.order_id=b.order_id
where cancellation is null
),
-- Tabla de beneficios
Beneficio_pizzas as (
select runner_id
, Case 
    when pizza_id=1 then 12
    when pizza_id=2 then 10
    else 0 end as precio_pizza
from tablaauxpizzas
),
-- Tabla de beneficio total
beneficio_total as (
select sum(precio_pizza) as beneficio_total
from beneficio_pizzas
)

--Calculo del beneficio final
select beneficio_total-gasto_total as Beneficio_final
from gasto_total
full join
 beneficio_total
;
 
