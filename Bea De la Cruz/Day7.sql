select 
    runner_id,
    sum(distancia_km) as distancia_acum_km,
    round(sum(distancia_km)/(sum(duracion_min)/60),2) as vel_promedio_km_h
from (
select 
    runner_id,
    order_id,
    distance,
    duration,
    iff(distance = 'null',null,REGEXP_REPLACE(distance, '[^0-9.]', '')) AS distancia_km,
    iff(distance = 'null',null,REGEXP_REPLACE(duration, '[^0-9.]', '')) as duracion_min
from runner_orders
order by runner_id
)
group by runner_id