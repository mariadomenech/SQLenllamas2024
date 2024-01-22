------------------------------- DÍA 4 -------------------------------------------------
--- ¿CUÁL ES EL PRIMER PRODUCTO MÁS PEDIDO DEL MENÚ Y CUÁNTAS VECES HA SIDO PEDIDO? ---
---------------------------------------------------------------------------------------

with num_orders as (
    select 
        s.product_id, 
        count(*) as product_orders
    from SQL_EN_LLAMAS.CASE01.SALES s
    group by s.product_id
)
select 
    p.product_name,
    n.product_orders as num_orders
from num_orders n
left join SQL_EN_LLAMAS.CASE01.MENU p
on n.product_id = p.product_id
order by product_orders desc
limit 1;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto! Se podría simplificar la query en una sola sin usar una CTE:

select 
      p.product_name
    , count(*) as num_orders
from SQL_EN_LLAMAS.CASE01.SALES s
    left join SQL_EN_LLAMAS.CASE01.MENU p
        on s.product_id = p.product_id
group by p.product_name
order by num_orders desc
limit 1;

*/
