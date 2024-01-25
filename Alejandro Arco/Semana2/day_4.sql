/* Day 4
    Partiendo de la receta de cada una de las pizzas,
    ¿Cuántas veces se repite cada toping/ingrediente?
    Ej: si la pizza Meatlover y la vegetariana llevan queso
    el ingrediente queso se repite dos veces.
*/

WITH FLATTEN_TOPPINGS AS (
    SELECT 
        PIZZA_ID, 
        TRIM(T.VALUE)::STRING AS TOPPING_ID
    FROM PIZZA_RECIPES,
         LATERAL FLATTEN(input=>split(TOPPINGS, ',')) AS T
)

SELECT
    P.TOPPING_NAME,
    COUNT(F.TOPPING_ID) AS COUNTER_TOPPINGS
FROM PIZZA_TOPPINGS AS P
LEFT JOIN FLATTEN_TOPPINGS AS F 
    ON P.TOPPING_ID = F.TOPPING_ID
GROUP BY P.TOPPING_NAME;