//Día 2: ¿Cuántos días ha visitado el restaurante cada cliente?
select sales.customer_id as Clientes, count(sales.order_date) as Cantidad_de_dias
from case01.sales
group by sales.customer_id;
