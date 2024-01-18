
select  b.product_name,count(*) as num_pedidos
from    sales a
left join menu b
    on  a.product_id = b.product_id
group by b.product_name
order by count(*) desc
fetch first 1 rows only;
