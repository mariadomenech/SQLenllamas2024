//Día 1: ¿Cuánto ha gastado cada cliente en total?
select sales."customer_id", sum(menu."price")
from case01.sales
inner join case01.menu
on sales."product_id" = menu."product_id"
group by sales."customer_id";
