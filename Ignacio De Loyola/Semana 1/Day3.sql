--Dia 3
with tmp as(
    select
        c.customer_id
        , product_name
        , dense_rank() over (partition by c.customer_id order by order_date) as ranking
    from sales a
    join menu b
    on a.product_id = b.product_id
    right join members c
    on a.customer_id = c.customer_id
)

select 'El cliente ' || customer_id ||
    case
        when count(distinct product_name) > 1 then (' pidió los siguientes productos primero: ' || array_agg(distinct product_name)::varchar)
        when count(distinct product_name) = 0 then ' aun no ha realizado su primer pedido'
        else (' pidió el siguiente producto primero: ' || listagg(distinct product_name))
    end as Respuesta
from tmp
where ranking = 1
group by customer_id
order by customer_id
;
