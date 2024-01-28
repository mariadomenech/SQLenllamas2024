USE SQL_EN_LLAMAS;
USE SCHEMA CASE02;

SELECT pt.topping_name AS "Ingrediente",
		COUNT(value) AS "Número Veces Se Repite"
FROM pizza_recipes pr,
		lateral flatten(input=>split(pr.toppings, ', '))
INNER JOIN pizza_toppings pt ON CAST(value AS int) = pt.topping_id
GROUP BY "Ingrediente"
ORDER BY "Número Veces Se Repite" DESC, "Ingrediente" ASC;
