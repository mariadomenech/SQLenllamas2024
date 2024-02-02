--Calculamos la frecuencia con la que aparecen los toppings en las pizzas.
WITH frecuencia_topping AS (
    SELECT 
        TRIM(VALUE) AS topping_id,
        COUNT(TRIM(VALUE)) AS frecuencia
    FROM SQL_EN_LLAMAS.CASE02.PIZZA_RECIPES,
    LATERAL SPLIT_TO_TABLE(toppings, ',')
    GROUP BY TRIM(VALUE)
)
--Mostramos los nombres de los toppings y sus frecuencias, estén o no en la receta de alguna pizza.
SELECT
    pt.topping_name,
    NVL(ft.frecuencia, 0) frecuencia
FROM SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS pt
LEFT JOIN frecuencia_topping ft USING (topping_id)



/*
COMENTARIOS JUANPE: me gusta el SPLIT_TO_TABLE más que otras alternativas (que son igualemnte válidas) 

RESULTADO: CORRECTO.

CÓDIGO: CORRECTOS 

LEGIBILIDAD: CORRECTA

*/
