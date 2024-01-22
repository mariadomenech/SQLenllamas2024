--------------------------- DÍA 3 -----------------------------
--- ¿CUÁL ES EL PRIMER PRODUCTO QUE HA PEDIDO CADA CLIENTE? ---
---------------------------------------------------------------
with ranking_prod_customer as (
select 
    s.customer_id, 
    s.product_id, 
    s.order_date,
    rank() over (partition by s.customer_id order by s.order_date asc) as date_order_ranking
from SQL_EN_LLAMAS.CASE01.SALES s
)
select 
    r.customer_id,
    r.product_id as first_product_order,
    r.order_date
from ranking_prod_customer r
where r.date_order_ranking = 1;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Quitaría el campo order_date, ya que no se pide en el ejercicio, y cambiaría el campo product_id por product_name. Además añadiría un cruce con la tabla MEMBERS para asi traer aquellos clientes que no
tienen pedidos, y usaría LISTAGG para simplificar la salida de la query teniendo un único registro por cada cliente.

with ranking_prod_customer as (
    select 
        mb.customer_id, 
        IFNULL(m.product_name, 'Sin producto') as product_name,
        rank() over (partition by s.customer_id order by s.order_date asc) as date_order_ranking
    from SQL_EN_LLAMAS.CASE01.SALES s
        inner join SQL_EN_LLAMAS.CASE01.MENU m
            on s.product_id = m.product_id
        right join SQL_EN_LLAMAS.CASE01.MEMBERS mb 
            on s.customer_id = mb.customer_id
)

select 
    r.customer_id,
    LISTAGG(distinct r.product_name, ', ') as product_name
from ranking_prod_customer r
where r.date_order_ranking = 1
group by customer_id;

*/
