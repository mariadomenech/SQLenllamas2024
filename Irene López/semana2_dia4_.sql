--///------------------------------------
--// DÍA 4
--///------------------------------------
-- Partiendo de la receta de cada una de las pizzas, ¿cuántas veces se repite cada topping/ingrediente?
-- Ej: si la pizza meatlover y la vegetariana llevan queso, el ingrediente "queso" se repite 2 veces.
WITH ToppingsTable AS (
      SELECT
        PIZZA_ID
        , TO_VARIANT(SPLIT(TOPPINGS, ',')) AS TOPPINGS_ARRAY
      FROM
        PIZZA_RECIPES
), VECES AS (
    SELECT
      TRIM(VALUE)::STRING AS TOPPING
      , COUNT(*) AS OCCURRENCES
    FROM
      ToppingsTable
      , LATERAL FLATTEN(INPUT => ToppingsTable.TOPPINGS_ARRAY) AS f
    GROUP BY
      TOPPING
)
SELECT
  TOPPING_NAME
  , OCCURRENCES
FROM 
  VECES V
JOIN
    PIZZA_TOPPINGS PT
ON TOPPING = TOPPING_ID;
