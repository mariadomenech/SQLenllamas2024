--Día 2. ¿Cuántos días ha visitado el restaurante cada cliente? 

select count(distinct(order_date))
from sales sales
right join members members
on members.customer_id=sales.customer_id
group by members.customer_id;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Bien planteado, pero, ¿dónde ha quedado la columna  members.customer_id en la select? si yo fuera Josep, me costaría adivinar a qué cliente corresponde cada conteo.

Por último, dale un alias a la columna count(distinct(order_date)) y PERFECTO!

*/
