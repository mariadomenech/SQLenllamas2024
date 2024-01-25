--PARTIENDO DE LA RECETA DE CADA UNA DE LAS PIZZAS,
--CUÁNTAS VECES SE REPITE CADA TOPPING/INGREDIENTE
/*SOLUCIÓN USANDO SPLIT_TO_TABLE QUE CONVIERTE UN STRING
  A DISTINTAS ROWS ESPECIFICANDO UN DELIMITADOR */ 

SELECT 
     B.TOPPING_NAME AS NOMBRE_TOPPING
    ,COUNT(A.TOPPING_ID) AS REPETICIONES
FROM(   
        SELECT
             PIZZA_ID
            ,TRIM(VALUE) AS TOPPING_ID
        FROM PIZZA_RECIPES,
        LATERAL SPLIT_TO_TABLE(PIZZA_RECIPES.TOPPINGS, ',')
        GROUP BY PIZZA_ID, TOPPING_ID
        )A
RIGHT JOIN PIZZA_TOPPINGS B
       ON A.TOPPING_ID = B.TOPPING_ID
GROUP BY 1;