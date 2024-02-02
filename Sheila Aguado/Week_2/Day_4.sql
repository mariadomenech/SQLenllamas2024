/*He hecho dos soluciones diferentes.
Esta primera es usando el split part, pero es un poco estática porque se ajusta al numero de elementos maximo en las recetas.
*/
WITH TOPPINGS AS (
    SELECT SPLIT_PART(TOPPINGS, ',', 1) AS TOPPING FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 2) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 3) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 4) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 5) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 6) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 7) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES UNION ALL
    SELECT SPLIT_PART(TOPPINGS, ',', 8) FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES
)

SELECT PT.TOPPING_NAME, COUNT(T.TOPPING_ID) AS NUM_VECES_TOPPING
FROM SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS PT
LEFT JOIN (
    SELECT
        REPLACE(T.TOPPING,' ','') AS TOPPING_ID
    FROM TOPPINGS T
    WHERE TOPPING_ID <> ''
) T
ON PT.TOPPING_ID = T.TOPPING_ID
GROUP BY PT.TOPPING_NAME;

/*
Esta segunda solucion es llevando ambos registros a un unico registro en string y haciendo un cross join con ese registro y
la tabla de toppings, miro cuantas veces esta el topping id en la lista.
He tenido que cada topping meterlo entre dobles comillas y contar asi porque si no me contaba el 1 por ejemplo, en el topping
1 y en el 10, 11 o 12.
*/
SELECT
    TOPPING_NAME,
    REGEXP_COUNT(A.TOPPINGS_TOTALES, CONCAT('"',TOPPING_ID,'"')) AS NUM_VECES_TOPPING
FROM SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS PT
CROSS JOIN (
    SELECT
        REPLACE(CONCAT('"',REPLACE(LISTAGG(TOPPINGS, ','),',','","'), '"'),' ','') AS TOPPINGS_TOTALES
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES
) A;


/*
COMENTARIOS JUANPE: ¡GUAU! no solo por ofrecer dos soluciones si no por la segunda pues yo tenia varias propuesta de solucines y no cai en esa y considero una 
solución muy sencilla de entender y explicar.

RESULTADOS: CORRECTOS.

CÓDIGO: CORRECTOS
        - El segundo genial como te he dicho, me gusta la lógica usada para resolverlo
        - El primero como bien dices tiene el problema de que implica conecer la cantidad de ingredientes (igual que si se hace con un unpivot, 
          tiene ese invonveniente, para el ejercicio 5 que pediamos el uso del unpivot era solo para que lo practiqueis pero realmente no es 
          lo más genérico debido a ese problema)

LEGIBILIDAD: CORRECTA

EXTRAS: genial por las dos propuesta explicando la ventaja de la segunda y el inconveniente de la primera.

*/

