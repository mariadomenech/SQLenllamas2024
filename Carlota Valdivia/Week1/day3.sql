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
