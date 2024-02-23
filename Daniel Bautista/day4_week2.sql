WITH temporal AS (

SELECT 
    a.pizza_id,
    REPLACE(GET(SPLIT(a.toppings, ','),0),'"','') AS ingrediente_1,
    REPLACE(GET(SPLIT(a.toppings, ','),1),'"','') AS ingrediente_2,
    REPLACE(GET(SPLIT(a.toppings, ','),2),'"','') AS ingrediente_3,
    REPLACE(GET(SPLIT(a.toppings, ','),3),'"','') AS ingrediente_4,
    REPLACE(GET(SPLIT(a.toppings, ','),4),'"','') AS ingrediente_5,
    REPLACE(GET(SPLIT(a.toppings, ','),5),'"','') AS ingrediente_6,
    REPLACE(GET(SPLIT(a.toppings, ','),6),'"','') AS ingrediente_7,
    REPLACE(GET(SPLIT(a.toppings, ','),7),'"','') AS ingrediente_8
FROM 
    SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES AS a
)

SELECT
    c.topping_name,
    COUNT(c.topping_name) AS conteo
FROM
    temporal AS b
INNER JOIN
    SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS AS c
ON 
    b.ingrediente_1 = c.topping_id OR
    b.ingrediente_2 = c.topping_id OR
    b.ingrediente_3 = c.topping_id OR
    b.ingrediente_4 = c.topping_id OR
    b.ingrediente_5 = c.topping_id OR
    b.ingrediente_6 = c.topping_id OR
    b.ingrediente_7 = c.topping_id OR
    b.ingrediente_8 = c.topping_id
GROUP BY 
    c.topping_name;
