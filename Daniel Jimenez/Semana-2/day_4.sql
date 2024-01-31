/*DÍA-4 - Partiendo de la receta de cada una de las pizzas, cuantas veces se repite cada TOPPING/INGREDIENTE. EJ: Si la pizza MEATLOVERS y la VEGETARIANA tiene queso, el ingrediente queso se repite 2 veces*/

WITH toppings_separados AS (
    SELECT  PIZZA_ID
        ,   TRIM(T.VALUE)::string AS topping_id
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES
        ,   LATERAL FLATTEN (input=>SPLIT(TOPPINGS, ',')) AS T /*He aprendido justo hoy a usar LATERAL FLATTEN, en este caso dividimos los toppings de cada receta en filas separadas. Luego SPLIT divide los toppings en una array y FLATTEN convierte esta array en filas. */
)
    
SELECT  PIZZA_TOPPINGS.TOPPING_NAME AS nombre_topping
    ,   COUNT(toppings_separados.TOPPING_ID) AS numero_repeticiones
FROM SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS 
LEFT JOIN toppings_separados
    ON PIZZA_TOPPINGS.TOPPING_ID = toppings_separados.TOPPING_ID
GROUP BY PIZZA_TOPPINGS.TOPPING_NAME;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
