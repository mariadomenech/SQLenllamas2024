--Dia 2
select 
    'El cliente ' || b.customer_id || ' ha visitado el restaurante ' || count(distinct order_date) || ' veces.' AS Respuesta
from sales a
right join members b
on a.customer_id = b.customer_id
group by b.customer_id
;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 
El resultado es completamente correcto, buen uso de la tabla de dimensiones members con el RIGHT JOIN.

Y la visualización de la salida, bastante original. Bien hecho!

*/
