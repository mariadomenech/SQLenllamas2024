
create temporary table tabla (runner_id,order_id,pizza_id,cancelaciones,modificaciones) as
select 
    r.runner_id,
    ro.order_id,
    c.pizza_id,
    iff(lower(ro.cancellation) like ('%cancellation%'),1,0) as cancelaciones,
    iff((c.exclusions is null or c.exclusions in ('','null')) and (c.extras is null or c.extras in ('','null')),0,1) as modificaciones
from runners r
left join runner_orders ro
    on r.runner_id = ro.runner_id
left join customer_orders c
    on ro.order_id = c.order_id
order by r.runner_id;

select 
    runner_id,
    pedidos_ok,
    pizzas_ok,
    iff(pedidos_total = 0,0,round(pedidos_ok*100/pedidos_total,2)) as porc_pedidos_ok,
    iff(pizzas_ok = 0,0,round(pizzas_mod*100/pizzas_ok,2)) as porc_pizzas_mod
from (
    select a.*,b.pedidos_total,c.pizzas_mod
    from (
        select 
            runner_id,
            count(distinct order_id) as pedidos_ok,
            count(pizza_id) as pizzas_ok
        from tabla
        where cancelaciones = 0
        group by runner_id
        ) a
    inner join (
        select 
            runner_id,
            count(distinct order_id) as pedidos_total
        from tabla
        group by runner_id
        ) b
        on a.runner_id = b.runner_id
    left join (
        select 
            runner_id,
            count(pizza_id) as pizzas_mod 
        from tabla
        where cancelaciones = 0 and modificaciones = 1
        group by runner_id
        ) c
        on b.runner_id = c.runner_id
    );