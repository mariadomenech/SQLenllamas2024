WITH temporal AS
(
SELECT 
    d.topping_name,
    COUNT(d.topping_name) AS conteo
FROM 
    SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS AS a
INNER JOIN 
    SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS AS b
ON 
    a.order_id = b.order_id
INNER JOIN 
    SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES AS c
ON 
    a.pizza_id = c.pizza_id
INNER JOIN 
    SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS AS d
ON 
    REPLACE(GET(SPLIT(c.toppings, ','),0),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),1),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),2),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),3),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),4),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),5),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),6),'"','') = d.topping_id OR
    REPLACE(GET(SPLIT(c.toppings, ','),7),'"','') = d.topping_id 
    
WHERE b.pickup_time is not null OR b.pickup_time <> 'null'
GROUP BY topping_name
ORDER BY conteo DESC
)

SELECT
    e.topping_name,
    CASE WHEN e.topping_name = 'Cheese' THEN (e.conteo -3)
     WHEN e.topping_name = 'Beef' THEN (e.conteo-1)
     WHEN e.topping_name = 'Bacon' THEN (e.conteo+4)
     WHEN e.topping_name = 'Chicken' THEN (e.conteo+1)
     WHEN e.topping_name = 'BBQ Sauce' THEN (e.conteo-1)
    ELSE e.conteo
    END AS conteo

FROM temporal AS e
ORDER BY conteo DESC;
