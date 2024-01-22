------------------------------- DÍA 1 -----------------------------
--- ¿CUÁNTO HA GASTADO EN TOTAL CADA CLIENTE EN EL RESTAURANTE? ---
-------------------------------------------------------------------

select
    m.customer_id, 
    sum(ifnull(p.price,0)) as total_gastado 
from SQL_EN_LLAMAS.CASE01.MEMBERS m 
left join SQL_EN_LLAMAS.CASE01.SALES s
on m.customer_id = s.customer_id
left join SQL_EN_LLAMAS.CASE01.MENU p 
on s.product_id = p.product_id 
group by m.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto!

*/
