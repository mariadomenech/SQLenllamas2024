-- Dia 4
select top 1
    'El producto más popular es el ' || product_name || ', ha sido pedido ' || count(*) || ' veces.' as Respuesta
from sales a
join menu b
on a.product_id = b.product_id
group by product_name
order by count(*) desc
;
