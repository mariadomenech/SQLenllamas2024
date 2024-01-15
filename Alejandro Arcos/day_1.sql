select 
    members."customer_id",
    case 
        when sum(menu."price") is null then 0
        else sum(menu."price")
    end as total_price
from
    members
left join
    sales
on members."customer_id" = sales."customer_id"
left join
    menu
on sales."product_id" = menu."product_id"
group by 
    members."customer_id";