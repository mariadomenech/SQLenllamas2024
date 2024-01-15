--Día 1. ¿Cuánto ha gastado en total cada cliente en el restaurante?

select mem.customer_id, sum(price)
from members mem
left join sales s
on mem.customer_id=s.customer_id
left join menu men
on s.product_id=men.product_id
group by mem.customer_id;
