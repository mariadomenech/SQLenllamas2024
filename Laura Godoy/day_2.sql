--Día 2. ¿Cuántos días ha visitado el restaurante cada cliente? 

select count(distinct(order_date))
from sales
group by customer_id;