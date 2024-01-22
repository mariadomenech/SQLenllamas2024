//Día 3: ¿Cuál es el primer producto que ha pedido cada cliente?
select sales.customer_id as Cliente, LISTAGG ( distinct menu.product_name, ',') as Productos, sales.order_date as Fecha
from case01.sales
inner join case01.menu
on sales.product_id = menu.product_id
where sales.order_date = (select min(sales.order_date) 
                          from case01.sales)
group by sales.customer_id, sales.order_date
order by sales.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

El resultado es correcto.

¡¡¿Sabías usar la función LISTAGG?!! Muy bien.

Pero aquí ten cuidado con cómo has montado la subconsulta, porque en este caso, coincide que los 3 clientes pidieron por primera vez en el mismo día, pero 
y, ¿si no hubiera sido así?

Te propongo que le des una vuelta a cómo montarías esa misma subconsulta, para que coja la fecha mínima dependiendo del cliente.

*/
