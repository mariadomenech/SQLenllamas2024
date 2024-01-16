select  members.customer_id
        ,count(sales.order_date) as num_visitas
from    sales
full outer join members
    on  sales.customer_id = members.customer_id
group by members.customer_id;
