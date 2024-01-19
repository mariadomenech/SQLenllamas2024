
select  a.customer_id
        ,sum(case   when c.product_name != 'sushi' then c.price * 10
                    when c.product_name = 'sushi' then c.price * 10 *2
            else 0 end) as puntos_finalizacion
from    members a
left join sales b
    on  a.customer_id = b.customer_id
left join menu c
    on  b.product_id = c.product_id
group by a.customer_id;