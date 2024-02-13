select  a.customer_id
        ,sum(case   when c.product_name != 'sushi' then c.price * 10
                    when c.product_name = 'sushi' then c.price * 10 *2
            else 0 end) as puntos_finalizacion
from    members a
left join sales b
    on  a.customer_id = b.customer_id
left join menu c
    on  b.product_id = c.product_id
group by a.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. Solo mejoraría un poco la legibilidad/visibilidad del código un poco.

A modo de detalle, otra posible opción sería utilizar un IFF en lugar del CASE (personalmente solo usaria CASE cuando se den varias condiciones o la única condición se algo compleja),
haciendo asi el código más limpio:

select
      a.customer_id
    , ifnull(sum(iff(c.product_name != 'sushi', c.price * 10, c.price * 10 *2)), 0) as puntos_finalizacion
from members a
left join sales b
    on  a.customer_id = b.customer_id
left join menu c
    on  b.product_id = c.product_id
group by a.customer_id;

*/
