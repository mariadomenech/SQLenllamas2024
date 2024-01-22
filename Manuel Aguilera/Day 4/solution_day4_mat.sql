SELECT PRODUCT_NAME, 
        VECES 
FROM(
SELECT B.PRODUCT_NAME, 
        ROW_NUMBER () OVER(ORDER BY COUNT(B.PRODUCT_ID) DESC) AS ROW_NUM, 
        COUNT(B.PRODUCT_ID) AS VECES
FROM SQL_EN_LLAMAS.CASE01.SALES A
INNER JOIN SQL_EN_LLAMAS.CASE01.MENU B 
        ON (A.PRODUCT_ID=B.PRODUCT_ID)
GROUP BY B.PRODUCT_NAME)
WHERE ROW_NUM=1;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! PERO OJO, usar ROW_NUMBER puede que en caso de empate en el producto más repetido solo te saque uno en vez de tantos como obtengan el 
primer puesto. Lo mejor hubiera sido una función ventana RANK.
*/
