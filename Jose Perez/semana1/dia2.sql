select 
    mb.customer_id,
    count(distinct(s.order_date)) as numero_pedidos
from 
    SQL_EN_LLAMAS.CASE01.MEMBERS as mb
left 
    join SQL_EN_LLAMAS.CASE01.SALES as s on s.customer_id = mb.customer_id
group by 
    mb.customer_id;
