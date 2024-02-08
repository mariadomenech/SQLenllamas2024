/*DESARROLLO EJERCICIO DIA 4*/
SELECT 
    PIZZA_TOPPINGS.TOPPING_NAME AS INGREDIENTE,
    COUNT(A.TOPPING_ID) AS NUM_VECES_USADO
FROM
(   
SELECT
    PIZZA_ID,
    TRIM(VALUE) AS TOPPING_ID
FROM PIZZA_RECIPES,
LATERAL SPLIT_TO_TABLE(PIZZA_RECIPES.TOPPINGS, ', ')
GROUP BY PIZZA_ID,
        TOPPING_ID
)A
JOIN PIZZA_TOPPINGS
ON A.TOPPING_ID = PIZZA_TOPPINGS.TOPPING_ID
GROUP BY PIZZA_TOPPINGS.TOPPING_NAME


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto, si te aburres algún día inténtalo con el UNPIVOT ;) 

*/
