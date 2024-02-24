
with tabla_no_dupl as (
    select distinct *
    from sales
)
select style_name,sum(qty)
from tabla_no_dupl a
left join product_details b
    on a.prod_id = b.product_id
where lower(category_name) = 'womens'
    and lower(segment_name) = 'jeans'
group by style_name;


create or replace function sql_en_llamas.case04.bcm_cat_seg (categoria varchar, segmento varchar)
returns table(product_name varchar, venta int)
as
$$

    with tabla_no_dupl as (
        select distinct *
        from sales
    )
    select 
        style_name,
        sum(qty) as venta
    from tabla_no_dupl a
    left join product_details b
        on a.prod_id = b.product_id
    where lower(category_name) = categoria
        and lower(segment_name) = segmento
    group by style_name
    limit 1

$$
;

select * from table(sql_en_llamas.case04.bcm_cat_seg('womens','jeans'));

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto del todo ya que, tal cual lo estas haciendo, te faltaria ordenar los registros por venta desc, asi el limit 1 se queda siempre con el mayor.

*/
