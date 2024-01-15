        
select 
    m."customer_id" as customer, 
    case when sum(mn."price") is null then 0
        else sum(mn."price") end as gasto_total
from SQL_EN_LLAMAS.CASE01.MEMBERS m
left join SQL_EN_LLAMAS.CASE01.sales s on s."customer_id"=m."customer_id"
left join SQL_EN_LLAMAS.CASE01.MENU mn on s."product_id"=mn."product_id"
group by m."customer_id"
order by gasto_total desc;
