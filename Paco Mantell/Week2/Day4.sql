WITH CTE_SPLIT_ING AS (
    /* Desgloso los ingredientes por pizza y lo reuno en dos columnas*/
    SELECT pizza_id,
        CAST(C.value AS INT) topping_id
    FROM sql_en_llamas.case02.pizza_recipes,
    LATERAL FLATTEN(input=>SPLIT(toppings, ',')) C
)
/* Cuento las veces que aparece cada ingrediente*/
SELECT topping_name,
    ZEROIFNULL(COUNT(B.topping_id)) times_used
FROM sql_en_llamas.case02.pizza_toppings A
RIGHT JOIN CTE_SPLIT_ING B
    ON A.topping_id=B.topping_id
GROUP BY 1
ORDER BY 2 DESC



/*
COMENTARIOS JUANPE: 

RESULTADO: CORRECTO.

CÓDIGO: CORRECTOS 

LEGIBILIDAD: CORRECTA

EXTRAS: bien por ordenar la salida y por usar el lateral flatten

*/
