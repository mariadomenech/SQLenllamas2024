with tabla_pivoteada as  (
    select  pizza_id , trim(value) as topping_id
    from 
        SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES, 
        LATERAL SPLIT_TO_TABLE(toppings, ',')
        
)
SELECT 
    pt.topping_id,
    pt.topping_name,
    count(t.topping_id) as repetitions
FROM 
    SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS as pt
left join 
    tabla_pivoteada as t on  pt.topping_id = t.topping_id
group by 
    pt.topping_id,
    pt.topping_name
;
