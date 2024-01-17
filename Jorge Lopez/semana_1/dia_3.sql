//Día 3: ¿Cuál es el primer producto que ha pedido cada cliente?
select sales.customer_id as Cliente, LISTAGG ( distinct menu.product_name, ',') as Productos, sales.order_date as Fecha
from case01.sales
inner join case01.menu
on sales.product_id = menu.product_id
where sales.order_date = (select min(sales.order_date) 
                          from case01.sales)
group by sales.customer_id, sales.order_date
order by sales.customer_id;
