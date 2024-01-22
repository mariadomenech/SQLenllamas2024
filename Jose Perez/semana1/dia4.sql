--Utilizo rank para quedarme con varios productos en caso de empate
with number_order as (
    select 
        product_id,
        count(*) as total
    from 
        SQL_EN_LLAMAS.CASE01.SALES
    group by 
        product_id
),
ranking as (
    select 
        product_id,
        total,
        rank() over (order by total desc) as _rn
    from number_order
)
select 
    mn.product_name,
    r.total as total_purchases
from 
    ranking as r 
left join 
    SQL_EN_LLAMAS.CASE01.MENU as mn on r.product_id = mn.product_id
where _rn = 1;

*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Jose! Y me gusta que hagas uso del RANK(), porque justo eso, nos permite sacar más de un producto en caso de empate.

*/
