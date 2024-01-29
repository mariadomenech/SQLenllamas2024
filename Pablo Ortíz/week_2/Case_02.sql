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
 -- hago los calculos de la distancia acumulada y velocidad media
 select runner_id
 , round(Sum(distancia_Km),2) as Distancia_acumulada_Km
 , round(avg(distancia_Km/duracion_minutos)*60,2) as Velocidad_promedio_Kmh
 from datos_limpios
 group by runner_id
 ;
