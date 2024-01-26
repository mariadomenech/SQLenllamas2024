//** ¿Qué es mejor? Así **//

SELECT MB.CUSTOMER_ID AS CLIENTE, ZEROIFNULL(SUM(P.PUNTOS)) AS PUNTOS
FROM (
    SELECT S.CUSTOMER_ID AS CLIENTE,
          CASE WHEN M.PRODUCT_NAME = 'sushi' THEN 20
            ELSE 10
          END AS PUNTOS
    FROM SQL_EN_LLAMAS.CASE01.SALES AS S
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU AS M
    ON S.PRODUCT_ID = M.PRODUCT_ID
    ) AS P
RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS AS MB
ON P.CLIENTE = MB.CUSTOMER_ID
GROUP BY MB.CUSTOMER_ID


//** ¿o con el SUM en la Subslect? **//

SELECT MB.CUSTOMER_ID AS CLIENTE, ZEROIFNULL(P.PUNTOS) AS PUNTOS
FROM (
    SELECT S.CUSTOMER_ID AS CLIENTE,
           SUM (CASE WHEN M.PRODUCT_NAME = 'sushi'
                THEN 20
                ELSE 10
            END) AS PUNTOS
    FROM SQL_EN_LLAMAS.CASE01.SALES AS S
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU AS M
    ON S.PRODUCT_ID = M.PRODUCT_ID
    GROUP BY S.CUSTOMER_ID
    ) AS P
RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS AS MB
ON P.CLIENTE = MB.CUSTOMER_ID

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
En cuanto a cual es mejor de tus opciones teniendo en cuanto cuando usar el sum daría igual. Pero en cualquier caso no es correcto tu resultado,
le has dado 20 puntos por haber comprado sushi pero son 200, porque son 20 por cada € gastado es decir 20x10 vale 10€ el sushi, igual con los otros platos.
Te animo a que lo reahagas de cualquiera de las dos formas que dices aunque si quieres probar otra prueba a usar tablas temporales con el with, son muy útiles 
cuando se requieren subconsultas. Cualquier duda de como se hace no dudes en contactarme.
*/

SELECT MB.CUSTOMER_ID AS CLIENTE, ZEROIFNULL(P.PUNTOS) AS PUNTOS
FROM (
    SELECT S.CUSTOMER_ID AS CLIENTE,
           SUM (CASE WHEN M.PRODUCT_NAME = 'sushi'
                THEN M.PRICE*20
                ELSE M.PRICE*10
            END) AS PUNTOS
    FROM SQL_EN_LLAMAS.CASE01.SALES AS S
    LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU AS M
    ON S.PRODUCT_ID = M.PRODUCT_ID
    GROUP BY S.CUSTOMER_ID
    ) AS P
RIGHT JOIN SQL_EN_LLAMAS.CASE01.MEMBERS AS MB
ON P.CLIENTE = MB.CUSTOMER_ID
