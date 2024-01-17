with primero as (
    select 
        s.customer_id, 
        case when s.order_date = (min(s.order_date) over (partition by s.customer_id)) then m.product_name 
            --when s.product_id = 0 then s.product_id 
            else null end as primer_producto,
        s.order_date
    from SQL_EN_LLAMAS.CASE01.SALES s
        inner join SQL_EN_LLAMAS.CASE01.MENU m on s.product_id=m.product_id 
    order by primer_producto
),

segundo as (
    select 
        me.customer_id,
        --case when p.primer_producto is null then 'No tiene pedidos' else primer_producto end as primer_producto,
        p.order_date,
        primer_producto
    from primero p
    right join SQL_EN_LLAMAS.CASE01.MEMBERS me on p.customer_id=me.customer_id 
    where primer_producto is not null or p.order_date is null
)

select 
    customer_id, 
    coalesce(order_date::varchar(10),'No hay producto'),
    case when primer_producto is null then 'No hay producto'
        else primer_producto end as primer_producto
from segundo;
