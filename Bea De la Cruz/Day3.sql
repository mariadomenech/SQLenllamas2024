
select  customer_id
        ,order_date
        ,nullif(listagg(product_name, ', ') within group (order by customer_id,order_date),'') as primer_producto_pedido
from    (select distinct a.customer_id
                ,b.order_date
                ,c.product_name
        from    members a
        left join   (select customer_id
                            ,order_date
                            ,product_id
                            ,min(order_date) over (partition by customer_id order by order_date) as min_fecha
                    from    sales) b
            on  a.customer_id = b.customer_id
        left join   menu c
            on  b.product_id = c.product_id
        where   order_date = min_fecha
                or order_date is null)
group by customer_id,order_date
order by customer_id