--------------------------------------------------------------DIA_4----------------------------------------------------------

WITH AUX AS (
    SELECT
        PIZZA_ID,
        ' '||TOPPINGS AS TOPPINGS
    FROM PIZZA_RECIPES
)
SELECT
    TOPPING_NAME,
    TO_CHAR(COUNT(PIZZA_ID)) AS CONTEO_INGREDIENTE        --Lo convierto a CHAR solo para que los registros aparezcan a la izquierda de la columna
FROM AUX A,
    LATERAL FLATTEN(input=>SPLIT(TOPPINGS, ',')) C
INNER JOIN PIZZA_TOPPINGS B
    ON B.TOPPING_ID = C.value::string
GROUP BY TOPPING_NAME;

--USANDO UNPIVOT
WITH AUX AS (
    SELECT
        PIZZA_ID,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 1), '')) AS INGREDIENTE_1,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 2), '')) AS INGREDIENTE_2,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 3), '')) AS INGREDIENTE_3,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 4), '')) AS INGREDIENTE_4,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 5), '')) AS INGREDIENTE_5,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 6), '')) AS INGREDIENTE_6,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 7), '')) AS INGREDIENTE_7,
        TRIM(NULLIF(SPLIT_PART(TOPPINGS, ',', 8), '')) AS INGREDIENTE_8
    FROM PIZZA_RECIPES)
SELECT
    TOPPING_NAME,
   COUNT(B.TOPPING_ID) AS CONTEO_INGREDIENTE
FROM AUX
    UNPIVOT (TOPPING_ID
             FOR INGREDIENTES IN (INGREDIENTE_1,INGREDIENTE_2,INGREDIENTE_3,INGREDIENTE_4,INGREDIENTE_5,INGREDIENTE_6,INGREDIENTE_7,INGREDIENTE_8)) A
RIGHT JOIN PIZZA_TOPPINGS B
    ON A.TOPPING_ID = B.TOPPING_ID
GROUP BY TOPPING_NAME;



/*
COMENTARIOS JUANPE: 

RESULTADOS: CORRECTOS.

CÓDIGOS: CORRECTOS (No entiendo porque poner el with en el primer código, concatenas un espacio en blanco pero realmente puedes no hacerlo,
no sé si se me esacapa algo que no veo)

LEGIBILIDAD: CORRECTA

EXTRAS: Genial por las dos soluiciones muy bien por la primera con el uso del lateral flatten y muy bien por el uso del unpivot que realmente no es 
necesario para ejercicio incluso para descomponer una lista no es ni siquiera lo mejor porque implica conecer el tamaña de todas las listas pero
el objetivo de usarlo era que os familiarizarais con él y veo que no has tenido problema asique genial!

*/
