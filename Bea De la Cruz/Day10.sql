
create temporary table tabla (order_id,pizza_id,cancelacion,excl1,excl2,ext1,ext2) as
select 
    a.order_id,
    a.pizza_id,
    iff(b.cancellation is null or b.cancellation in ('null',''),0,1) as cancelacion,
    to_char(get(split(replace(replace(a.exclusions,'beef','3'),' ',''),','),0)) as excl1,
    to_char(get(split(replace(replace(a.exclusions,'beef','3'),' ',''),','),1)) as excl2,
    to_char(get(split(replace(iff(a.extras is null,'null',a.extras),' ',''),','),0)) as ext1,
    to_char(get(split(replace(iff(a.extras is null,'null',a.extras),' ',''),','),1)) as ext2
from customer_orders a
left join runner_orders b
    on a.order_id = b.order_id;

select 
    num_ingredientes,
    listagg(topping_name,',') within group (order by num_ingredientes) as ingredientes
from (
    with tabla_global as (
        select 
                a.order_id,
                a.pizza_id,
                a.cancelacion,
                iff(a.excl1 in ('null',''),null,a.excl1) as excl1,
                a.excl2,
                iff(a.ext1 in ('null',''),null,a.ext1) as ext1,
                a.ext2,
                b.ingrediente  
            from tabla a
            left join (
                with tabla as(
                        select 
                            pizza_id,
                            to_char(get(split(replace(toppings,' ',''),','),0)) as ing1,
                            to_char(get(split(replace(toppings,' ',''),','),1)) as ing2,
                            to_char(get(split(replace(toppings,' ',''),','),2)) as ing3,
                            to_char(get(split(replace(toppings,' ',''),','),3)) as ing4,
                            to_char(get(split(replace(toppings,' ',''),','),4)) as ing5,
                            to_char(get(split(replace(toppings,' ',''),','),5)) as ing6,
                            to_char(get(split(replace(toppings,' ',''),','),6)) as ing7,
                            to_char(get(split(replace(toppings,' ',''),','),7)) as ing8
                        from pizza_recipes
                        )
                    select pizza_id,ingrediente
                    from tabla
                        unpivot(ingrediente for ing_col in (ing1,ing2,ing3,ing4,ing5,ing6,ing7,ing8))
                ) b
                on a.pizza_id = b.pizza_id
            where cancelacion = 0
        )
    select
        sum(a.conteo) as num_ingredientes,
        b.topping_name
    from (
        select 
            *,
            case 
                when excl1 is null and excl2 is null and ext1 is null and ext2 is null then 1
                when excl1 = ingrediente then 0
                when excl2 = ingrediente then 0
                when ext1 = ingrediente then 2
                when ext2 = ingrediente then 2
                else 1
            end as conteo
        from tabla_global
        ) a
    left join pizza_toppings b
        on a.ingrediente = b.topping_id
    group by b.topping_name
    )
group by num_ingredientes
order by num_ingredientes desc;