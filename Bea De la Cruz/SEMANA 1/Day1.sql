
select  members.customer_id
        ,case   when sum(menu.price) is null then 0 
                else sum(menu.price) end as "TOTAL PRICE"
from    sales
full outer join members
    on  sales.customer_id = members.customer_id
left join menu
    on  sales.product_id = menu.product_id
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
      mb.customer_id
    , case
          when sum(mn.price) is null then 0 
          else sum(mn.price)
      end as "TOTAL PRICE"
from members mb
left join sales s
    on  mb.customer_id = s.customer_id
left join menu mn
    on  s.product_id = mn.product_id
group by mb.customer_id;

*/
