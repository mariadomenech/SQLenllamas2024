/* Crear una sola consulta para replicar la tabla product_details,hay que trnasformar los conjuntos de datos 
product_hierarchy  y product_prices*/

CREATE OR REPLACE TEMPORARY TABLE SQL_EN_LLAMAS.CASE04.DAY3_WEEK4_BEA AS (
with table_category as (
 select distinct id 
        ,level_text
        from case04.product_hierarchy
        where level_name ='Category'
), 
table_segment as (
 select distinct id
        ,level_text 
        ,parent_id
        from case04.product_hierarchy
        where level_name = 'Segment'
), 
table_style as (
 select distinct id
        ,level_text
        ,parent_id
        from case04.product_hierarchy
        where level_name ='Style'
)
select  D.product_id 
        ,D.price
        ,concat(C.level_text,' ',B.level_text,' - ',A.level_text) as product_name
        ,A.id as category_id
        ,B.id as segment_id
        ,C.id as styel_id
        ,A.level_text as category_name
        ,B.level_text as segment_name
        ,C.level_text as style_name
from table_category A
left join (select id,parent_id,level_text from table_segment) B
    on A.id = B.parent_id
left join (select id,parent_id, level_text from table_style) C
    on B.id = C.parent_id
left join case04.product_prices D
    on C.id = D.id
);

SELECT * FROM SQL_EN_LLAMAS.CASE04.DAY3_WEEK4_BEA; 

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

*/
