SELECT A.CUSTOMER_ID, 
    CASE WHEN B.CUSTOMER_ID IS NULL THEN COUNT(A.JOIN_DATE)
        ELSE COUNT(DISTINCT B.ORDER_DATE) END  AS NUM_DIAS_VISITA
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
ON A.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY A.CUSTOMER_ID,B.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es correcto del todo, ya que el cliente D es miembro pero nunca ha ido al restaurante por lo que, en lugar de contar la fecha de union, habría que ponerle un 0.

SELECT 
    A.CUSTOMER_ID, 
    CASE WHEN B.CUSTOMER_ID IS NULL THEN 0
         ELSE COUNT(DISTINCT B.ORDER_DATE) 
    END AS NUM_DIAS_VISITA
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
    ON A.CUSTOMER_ID = B.CUSTOMER_ID
GROUP BY A.CUSTOMER_ID,B.CUSTOMER_ID;

*/
