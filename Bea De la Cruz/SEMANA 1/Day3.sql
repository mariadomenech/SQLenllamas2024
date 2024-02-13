-- Versión con order_date
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

-- Versión con join_date (por el cambio de las fechas comentado en el grupo)
select  customer_id
        ,join_date
        ,coalesce(nullif(listagg(product_name, ', ') within group (order by customer_id,join_date),''),'sin pedido') as primer_producto_pedido --por si el cliente no entiende el null
        ,nullif(listagg(product_name, ', ') within group (order by customer_id,join_date),'') as primer_producto_pedido --si el cliente entiende el null
from    (select  distinct a.customer_id
                ,join_date
                ,product_name
        from    members a
        left join sales b
            on  a.customer_id = b.customer_id
            and a.join_date = b.order_date
        left join menu c
            on b.product_id = c.product_id)
group by customer_id,join_date
order by customer_id

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Quitaría la fecha del resultado final ya que no se pide en el ejercicio. Me ha gustado mucho la utilización de COALESCE y de LISTAGG para hacer mas visible la salida de la query!
Otra forma posible de hacer el ejercicio es mediante la funcion de ventana RANK, échale un vistazo.

Mejoraría la legibilidad/visibilidad del código un poco.

select
      customer_id
    , coalesce(nullif(listagg(product_name, ', ') within group (order by customer_id,join_date),''),'sin pedido') as primer_producto_pedido --por si el cliente no entiende el null
from (
    select distinct
          a.customer_id
        , a.join_date
        , c.product_name
    from members a
    left join sales b
        on a.customer_id = b.customer_id
        and a.join_date = b.order_date
    left join menu c
        on b.product_id = c.product_id
    )
group by customer_id,join_date
order by customer_id;

*/
