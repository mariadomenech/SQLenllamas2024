/*Partiendo de la receta de cada una de las pizzas,
¿cuántas veces se repite cada una topping/ingrediente?*/


SELECT B.topping_name
       ,count(*) AS toppings_used
FROM case02.pizza_recipes A,
LATERAL FLATTEN(input=>split(toppings, ', ')) C
INNER JOIN case02.pizza_toppings B
       ON C.value::string = B.topping_id
GROUP BY 1;
