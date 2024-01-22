with sales_points as (
    select 
        s.customer_id,
        s.product_id,
        case 
            when mn.product_name = 'sushi' then mn.price * 10 * 2
            else mn.price * 10 
        end as points
    from 
        SQL_EN_LLAMAS.CASE01.SALES as s
    left join
        SQL_EN_LLAMAS.CASE01.MENU as mn on mn.product_id = s.product_id
)
select 
    mb.customer_id,
    sum(nvl(s.points,0)) as total_points
from 
    sales_points as s
full outer join 
    SQL_EN_LLAMAS.CASE01.MEMBERS as mb on mb.customer_id = s.customer_id
group by 
    mb.customer_id;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Parece que me repito, pero, resultado correcto, código correcto y tabulación correcta!

*/
