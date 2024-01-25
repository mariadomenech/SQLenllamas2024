--------------------------------------------------------------DIA_4----------------------------------------------------------

WITH AUX AS (
    SELECT
        PIZZA_ID,
        ' '||TOPPINGS AS TOPPINGS
    FROM PIZZA_RECIPES
)
SELECT
    TOPPING_NAME,
    TO_CHAR(COUNT(PIZZA_ID)) AS CONTEO_INGREDIENTE    
FROM AUX A,
    LATERAL FLATTEN(input=>SPLIT(TOPPINGS, ',')) C
INNER JOIN PIZZA_TOPPINGS B
    ON B.TOPPING_ID = C.value::string
GROUP BY TOPPING_NAME;