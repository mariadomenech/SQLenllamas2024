
select  members.customer_id
        ,case   when sum(menu.price) is null then 0 
                else sum(menu.price) end as "TOTAL PRICE"
from    sales
full outer join members
    on  sales.customer_id = members.customer_id
left join menu
    on  sales.product_id = menu.product_id
group by members.customer_id;