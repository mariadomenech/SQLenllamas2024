--Día 2. ¿Cuántos días ha visitado el restaurante cada cliente? 

select count(distinct(order_date))
from sales sales
right join members members
on members.customer_id=sales.customer_id
group by members.customer_id;
