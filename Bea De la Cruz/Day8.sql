select sum(beneficio) as beneficio_total
from (
    select 
        r.runner_id,
        ro.order_id,
        round(iff(ro.distance = 'null',null,REGEXP_REPLACE(ro.distance, '[^0-9.]', ''))*0.3,2) as pago_entrega,
        c.pizza_id,
        c.extras,
        iff(p.pizza_name like '%lover%',12,10) as precio_pizza,
        nvl(regexp_count(iff(extras in ('','null'),null,extras),',') + 1,0) AS precio_extras,
        (iff(p.pizza_name like '%lover%',12,10) + nvl(regexp_count(iff(extras in ('','null'),null,extras),',') + 1,0) - round(iff(ro.distance = 'null',null,REGEXP_REPLACE(ro.distance, '[^0-9.]', ''))*0.3,2)) as beneficio
    from runners r
    left join runner_orders ro
        on r.runner_id = ro.runner_id
    left join customer_orders c
        on ro.order_id = c.order_id    
    left join pizza_names p
        on c.pizza_id = p.pizza_id
    where lower(ro.cancellation) not like ('%cancellation%') 
        or ro.cancellation is null
    );