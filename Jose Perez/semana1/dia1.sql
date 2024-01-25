select 
    mb.customer_id, 
    sum(nvl(mn.price,0)) as total_spent
from 
    SQL_EN_LLAMAS.CASE01.MEMBERS as mb
left join 
    SQL_EN_LLAMAS.CASE01.SALES as s on s.customer_id = mb.customer_id
left join 
    SQL_EN_LLAMAS.CASE01.MENU as mn on mn.product_id = s.product_id
group by 
    mb.customer_id;
/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto
*/
