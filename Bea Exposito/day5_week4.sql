/*Crea una función que,introduciéndole una categoría y segmento,muestre el producto más vendido de cada categoría y segmento  */

create or replace function SQL_EN_LLAMAS.CASE03.BEA_EXPOSITO_LEADING_PRODUCT (category varchar, segment varchar)
returns table ( product_name varchar , quantity number)
as 
$$
    select 
        product_name
       ,quantity
    from (
        select B.product_name
              ,sum(qty) as quantity
              , rank () over(order by quantity desc ) ranking
        from ( select distinct * 
               from case04.sales
             ) A
        left join case04.product_details B   
            on A.prod_id = B.product_id
        where upper(category_name) = upper(trim(category)) and upper(segment_name) = upper(trim(segment))
        group by 1
          )
    where ranking = 1

$$
;

SELECT * FROM TABLE( SQL_EN_LLAMAS.CASE03.BEA_EXPOSITO_LEADING_PRODUCT('Womens', 'Jeans'));

