with sales_ranking as (
    select 
        customer_id,
        product_id,
        rank() over ( partition by customer_id order by order_date asc) as _rn
    from SQL_EN_LLAMAS.CASE01.SALES
    
)
select
    mb.customer_id,
    array_agg(distinct nvl(mn.product_name, 'No realizo compra')) as products
from 
    SQL_EN_LLAMAS.CASE01.MEMBERS as mb
left join 
    sales_ranking as sr on mb.customer_id = sr.customer_id
left join 
    SQL_EN_LLAMAS.CASE01.MENU as mn on sr.product_id = mn.product_id
where 
    sr._rn = 1 or sr._rn is null
group by 
    mb.customer_id
;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Jose! Buen uso del RANK() y del  array_agg() que facilita la visualización. Hay una función muy parecida, LISTAGG(), 
que hace la misma función y puedes elegir el separador de lista. 

*/
