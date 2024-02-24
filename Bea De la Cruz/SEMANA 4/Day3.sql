
select 
    a.product_id,
    a.price,
    b.level_text||' - '||d.level_text as product_name,
    c.parent_id as category_id,
    b.parent_id as segment_id,
    b.id as style_id,
    d.level_text as category_name,
    c.level_text as segment_name,
    b.level_text as style_name
from product_prices a
inner join product_hierarchy b
    on a.id = b.id
inner join product_hierarchy c
    on b.parent_id = c.id
inner join product_hierarchy d
    on c.parent_id = d.id

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

*/
