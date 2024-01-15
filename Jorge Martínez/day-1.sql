select a.customer_id, 
        sum(ifnull(b.price,0)) as price
    from SQL_EN_LLAMAS.CASE01.MEMBERS a
        left join SQL_EN_LLAMAS.CASE01.SALES c 
            on a.customer_id = c.customer_id
        left join SQL_EN_LLAMAS.CASE01.MENU b
            on b.product_id = c.product_id
        group by a.customer_id;