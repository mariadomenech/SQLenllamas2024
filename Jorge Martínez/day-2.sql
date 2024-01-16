
//mostrando solo los clientes que han ido alguna vez
select customer_id, 
        count(cast(order_date as text)) as days
        from SQL_EN_LLAMAS.CASE01.SALES
        group by customer_id

//mostrando todos los clientes (aprovechando el script del día 1)
select a.customer_id,
        count(cast(c.order_date as text)) as days
    from SQL_EN_LLAMAS.CASE01.MEMBERS a
        left join SQL_EN_LLAMAS.CASE01.SALES c 
            on a.customer_id = c.customer_id
        left join SQL_EN_LLAMAS.CASE01.MENU b
            on b.product_id = c.product_id
        group by a.customer_id;
