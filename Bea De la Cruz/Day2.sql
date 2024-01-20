select  members.customer_id
        ,count(sales.order_date) as num_visitas
from    sales
full outer join members
    on  sales.customer_id = members.customer_id
group by members.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto pero la utilización de FULL OUTER JOIN no lo es, en este caso en concreto con pocos registros que cruzar no supone un problema de rendimiento pero en casos con millones de registros el
uso de FULL OUTER JOIN lastra el rendimiento de la consulta consumiendo muchos recursos. Por ello, yo utilizaría como tabla principal la tabla de MEMBERS y utilizaría LEFT JOIN.

Mejoraría la legibilidad/visibilidad del código un poco y utilizaría alias siempre que se hagan cruces de tablas, ya que puede darse el caso en que los nombres de las tablas sean largos o poco claros, lo cual
dificultaría la lectura del código. 

select
      a.customer_id
    , count(b.order_date) as num_visitas
from members a
left join sales b
    on  a.customer_id = b.customer_id
group by a.customer_id;

*/
