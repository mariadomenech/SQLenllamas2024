SELECT 
    DISTINCT AA.toppings AS codigo_ingrediente,
    BB.topping_name AS nombre_ingrediente,
    COUNT(toppings) OVER (PARTITION BY topping_id) AS repeticiones_veces
FROM (
        SELECT 
            pizza_id,
            TRIM(C.value::string,' ') AS toppings
        FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES A,
            LATERAL FLATTEN(input=>SPLIT(toppings, ',')) C
) AA
INNER JOIN SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS BB
    ON AA.toppings=BB.topping_id
ORDER BY toppings;
