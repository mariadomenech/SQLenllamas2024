select  members.customer_id
        ,count(sales.order_date) as num_visitas
from    sales
full outer join members
    on  sales.customer_id = members.customer_id
left join menu
    on  sales.product_id = menu.product_id
group by members.customer_id;