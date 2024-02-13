
select  top 1 b.product_name,count(*) as num_pedidos
from    sales a
left join menu b
    on  a.product_id = b.product_id
group by b.product_name
order by count(*) desc;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. Respecto al cruce, podríamos utilizar INNER JOIN para sacar única y exclusivamente los productos del menu que se han vendido, ya que LEFT JOIN utilizando como tabla principal SALES 
no tendría mucho sentido ya que resultaría extraño tener ventas de un prodcuto que no se tiene en carta y tampoco usaría RIGHT JOIN ya que asi sacaríamos productos del menú que no se han vendido, lo cual nos
resultaría poco útil de cara a este ejercicio.

Destacar que TOP 1 funciona perfectamente pero otra opción válida es utilizar LIMIT 1.

Mejoraría la legibilidad/visibilidad del código un poco.

select
      b.product_name
    , count(*) as num_pedidos
from sales a
inner join menu b
    on a.product_id = b.product_id
group by b.product_name
order by num_pedidos desc
limit 1;

*/
