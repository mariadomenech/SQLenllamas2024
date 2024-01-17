with first_product as(
select a.customer_id,
        c.order_date,
        b.product_name,
        row_number() over (partition by a.customer_id order by c.order_date) as fila,
        first_value(c.product_id) over (partition by a.customer_id order by c.order_date) as product
    from SQL_EN_LLAMAS.CASE01.MEMBERS a
        left join SQL_EN_LLAMAS.CASE01.SALES c 
            on a.customer_id = c.customer_id
        left join SQL_EN_LLAMAS.CASE01.MENU b
            on b.product_id = c.product_id
        group by a.customer_id, c.product_id, c.order_date, b.product_name
        order by c.order_date asc
)
select customer_id, product, product_name
    from first_product
        where fila=1
    order by customer_id;
