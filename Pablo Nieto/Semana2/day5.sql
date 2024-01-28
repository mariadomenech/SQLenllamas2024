/*
Primero, limpio los campos extras y exclusions de falsos nulos y vacíos además de convertir 'beef' a su correspondiente id.
Esto último está hecho manualmente, si hubiera más registros con el nombre del ingrediente en lugar de su id habría que cruzar la tabla
con la de ingredientes, lo cual intenté pero sin éxito.
*/
WITH ingredientes_limpios AS (
    SELECT
        pr.toppings,
        CASE
            WHEN co.exclusions IN ('', 'null') THEN NULL
            WHEN co.exclusions = 'beef' THEN '3'
            ELSE co.exclusions
        END AS exclusions,
        CASE
            WHEN co.extras IN ('', 'null') THEN NULL
            ELSE co.extras
        END AS extras
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES pr
    LEFT JOIN SQL_EN_LLAMAS.CASE02.CUSTOMER_ORDERS co USING (pizza_id)
    LEFT JOIN SQL_EN_LLAMAS.CASE02.RUNNER_ORDERS ro USING (order_id)
    WHERE ro.cancellation IS NULL OR ro.cancellation IN ('', 'null')
),
/*
Ahora separo en columnas los ingredientes principales, extras y excluidos de cada pizza. De nuevo, lo hice fijándome en que
el máximo de ingredientes principales en las pizzas son 8 y que no hay más de dos ingredientes extras o excluidos. No sé cómo
hacerlo de forma dinámica (supongo que con un bucle en PL/SQL) por si hubieran muchos ingredientes y dejara de ser razonable hacer tantos
SPLIT_PART's.
*/
pivot_toppings AS (
    SELECT
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 1), '')) AS topping1,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 2), '')) AS topping2,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 3), '')) AS topping3,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 4), '')) AS topping4,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 5), '')) AS topping5,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 6), '')) AS topping6,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 7), '')) AS topping7,
        TRIM(NULLIF(SPLIT_PART(toppings, ',', 8), '')) AS topping8,
        TRIM(NULLIF(SPLIT_PART(exclusions, ',', 1), '')) AS exclusion1,
        TRIM(NULLIF(SPLIT_PART(exclusions, ',', 2), '')) AS exclusion2,
        TRIM(NULLIF(SPLIT_PART(extras, ',', 1), '')) AS extra1,
        TRIM(NULLIF(SPLIT_PART(extras, ',', 2), '')) AS extra2
    FROM ingredientes_limpios
),
/*
Ahora creo una columna llamada frecuencia que siempre vale 1 para cada ingrediente principal o extra de cada pizza que posteriormente
sumaremos entre sí y restaremos a las frecuencias de los ingredientes excluidos. Para ello utilizo UNPIVOT creando las columnas topping_id 
y topping_category, utilizando solo la primera de ellas.
*/
toppings_and_extras AS (
    SELECT 
        topping_id,
        1 AS freq
    FROM pivot_toppings
    UNPIVOT(topping_id FOR topping_category IN (topping1, topping2, topping3, topping4, topping5, topping6, topping7, topping8, extra1, extra2))
    WHERE topping_id IS NOT NULL
),
/*
Aquí aplico el mismo razonamiento anterior pero indicando en el campo frecuencia el valor -1.
*/
exclusions AS (
    SELECT 
        topping_id,
        -1 AS freq
    FROM pivot_toppings
    UNPIVOT(topping_id FOR exclusion_category IN (exclusion1, exclusion2))
    WHERE topping_id IS NOT NULL
),
/*
Uno ambas tablas para poder sumar todas las frecuencias.
*/
combined AS (
    SELECT * FROM toppings_and_extras
    UNION ALL
    SELECT * FROM exclusions
)
/*
Obtengo finalmente el nombre del ingrediente y su frecuencia, es decir, el número de veces utilizado en las pizzas que se entregaron.
Ordeno el resultado por frecuencia de forma descendente.
*/
SELECT 
    pt.topping_name,
    SUM(c.freq) AS frecuencia
FROM SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS pt
LEFT JOIN combined c USING (topping_id)
GROUP BY pt.topping_name
ORDER BY frecuencia DESC;
