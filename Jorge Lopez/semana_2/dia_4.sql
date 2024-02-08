/* Día 4: ¿Cuánto se repite cada ingrediente en las dos pizzas? Teniendo en cuenta todos los ingredientes que hay 

  Para ser totalmente sincero, me costó mucho y si no llega ser por chat gpt no lo saco T_T El uso de lateral flatten 
o T1.TOPPINGS_VALUE::INTEGER  para convertir a entero, lo desconocía por completo*/

SELECT * FROM CASE02.PIZZA_NAMES;
SELECT * FROM CASE02.PIZZA_TOPPINGS;

SELECT
    PT.TOPPING_ID,
    PT.TOPPING_NAME,
    COUNT(*) AS COUNT_T1
FROM CASE02.PIZZA_TOPPINGS PT
INNER JOIN (SELECT
        VALUE::STRING AS TOPPINGS_VALUE
    FROM CASE02.PIZZA_RECIPES,
    LATERAL FLATTEN(INPUT => SPLIT(TOPPINGS, ','))) AS T1
ON PT.TOPPING_ID = T1.TOPPINGS_VALUE::INTEGER 
GROUP BY PT.TOPPING_ID, PT.TOPPING_NAME
ORDER BY PT.TOPPING_ID;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto, si te aburres algún día inténtalo con el UNPIVOT ;) 

*/
