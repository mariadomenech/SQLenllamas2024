-- Dia 5
with tmp as(
select
    c.customer_id
    , case
        when product_name = 'sushi' then price*20
        else price*10
    end as puntos
from sales a
join menu b
on a.product_id = b.product_id
right join members c
on a.customer_id = c.customer_id
)

select 'El cliente ' || customer_id || ' recibirá ' || sum(nvl(puntos, 0)) || ' puntos.'
from tmp
group by customer_id
order by customer_id
;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto Ignacio!

*/
