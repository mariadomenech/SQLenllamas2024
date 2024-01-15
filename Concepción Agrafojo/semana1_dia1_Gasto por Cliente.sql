USE DATABASE sql_en_llamas;

select sales.customer_id CLIENTE, sum(menu.price) GASTO
from case01.sales
inner join case01.menu
    on sales.product_id= menu.product_id
group by sales.customer_id