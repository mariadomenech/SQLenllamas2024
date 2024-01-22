WITH CTE_PUNTOS_PROD AS 
(
    SELECT product_id,
    product_name,
    price,
    CASE
        WHEN product_id=1 THEN price * 20
        ELSE price * 10
    END PUNTOS
    FROM SQL_EN_LLAMAS.CASE01.MENU
)
SELECT A.customer_id AS CLIENTE,
ZEROIFNULL(SUM(C.puntos)) AS TOTAL_PUNTOS
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
ON A.customer_id=B.customer_id
LEFT JOIN CTE_PUNTOS_PROD C
ON B.product_id=C.product_id
GROUP BY 1
ORDER BY 2 DESC

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! Muy bien usado el with para evitar subconsutlas. Si algo decirte tal vez que se pueden tabular algunas cosas para un código más limpio,
aunque esto siempre es una cuestión subjetiva.
*/

