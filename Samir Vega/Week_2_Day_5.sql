--------------------------------------------------------------DIA_5----------------------------------------------------------
--No entiendo porque Bacon me salen 11 en lugar de 12 ;(

CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.INDICADORES AS
WITH PIZZA_RECIPES_PIVOT AS
    (WITH AUX AS (
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
        PIZZA_ID,
        TOPPING_NAME,
        B.TOPPING_ID
    FROM AUX
        UNPIVOT (TOPPING_ID
                 FOR INGREDIENTES IN (INGREDIENTE_1,INGREDIENTE_2,INGREDIENTE_3,INGREDIENTE_4,INGREDIENTE_5,INGREDIENTE_6,INGREDIENTE_7,INGREDIENTE_8)) A
    RIGHT JOIN PIZZA_TOPPINGS B
        ON A.TOPPING_ID = B.TOPPING_ID)
SELECT 
    TOPPING_NAME,
    TOPPING_ID,
    CASE
        WHEN (  CASE
                    WHEN UPPER(TRIM(NULLIF(SPLIT_PART(EXCLUSIONS, ',', 1), ''))) = TRIM(UPPER(TOPPING_NAME)) THEN TOPPING_ID
                    WHEN UPPER(TRIM(NULLIF(SPLIT_PART(EXCLUSIONS, ',', 1), ''))) != TRIM(UPPER(TOPPING_NAME))
                        AND RLIKE(NULLIF(SPLIT_PART(EXCLUSIONS, ',', 1), ''), '[[:digit:]]') THEN TO_NUMBER(NULLIF(SPLIT_PART(EXCLUSIONS, ',', 1), ''))
                    ELSE NULL
                END) = TOPPING_ID
        THEN 1 ELSE 0
    END AS EXCLUSION_1,
    CASE
        WHEN TO_NUMBER(NULLIF(SPLIT_PART(EXCLUSIONS, ',', 2), '')) = TOPPING_ID
        THEN 1 ELSE 0
    END AS EXCLUSION_2,
    CASE
        WHEN TO_NUMBER(NULLIF(SPLIT_PART(EXTRAS, ',', 1), '')) = TOPPING_ID
        THEN 1 ELSE 0
    END AS EXTRA_1,
    CASE
        WHEN TO_NUMBER(NULLIF(SPLIT_PART(EXTRAS, ',', 2), '')) = TOPPING_ID
        THEN 1 ELSE 0
    END AS EXTRA_2
FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CUSTOMER_ORDERS_CLEAN A
RIGHT JOIN ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.RUNNER_ORDERS_CLEAN B
    ON A.ORDER_ID = B.ORDER_ID
INNER JOIN PIZZA_RECIPES_PIVOT C
    ON A.PIZZA_ID = C.PIZZA_ID
WHERE CANCELLATION IS NULL
ORDER BY A.ORDER_ID;

WITH CONTEO AS (
    SELECT
        TOPPING_NAME,
        COUNT(*) + SUM(EXTRA_1) + SUM(EXTRA_2) - SUM(EXCLUSION_1) - SUM(EXCLUSION_2) AS CONTEO_TOTAL
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.INDICADORES
    GROUP BY TOPPING_NAME)
SELECT
    DENSE_RANK() OVER (ORDER BY CONTEO_TOTAL DESC) AS RANKING,
    CONTEO_TOTAL,
    LISTAGG( DISTINCT TOPPING_NAME, ' ,') AS INGREDIENTES
FROM CONTEO
GROUP BY CONTEO_TOTAL;


/*
RESULTADO: INCORRECTO, Bacon son 12. El extra de bacon de la pizza del pedido 7 no te sale en tu query.

CÓDIGO: INCORRECTO. Pues en tu logica que la idea es bueana ya que va poniendo una flag si el ingredinete se pone o se quita PERO lo haces a los ingredientes de
base de cada pizza, eso hace que una pizza vegetariana no tiene bacon en su receta pero si alguien le añade bacon no te está saliendo, que es el caso de la pizza
del pedido 7. Tú idea parece buena pero tendrías que matizar. Bien usado el unpivot y de hecho podrias haberlo usado el unpivot para la columna extra y exclusiones
teniendo en cuenta claro si hay alguna cancelada no contarla. De hecho mi versión del ejercicio es 3 tablas donde en cada una pivoto los ingredintes una los extras
otra las exclusiones y otra la receta. Luego jugando bien con las que se cancelan y cuantas veces esta cada pizza acabo haciendo las suma y resta de ingredientes.

LEGIBILIDAD: CORRECTA

EXTRA: Bien mostrada la salida usando el listagg.

Si no eres capaz de sacar el bacon que te falta dimelo y lo vemos, pues no se si para tenerlo en cuenta se puede adaptar tu query o implica un cambio mayor.
*/
