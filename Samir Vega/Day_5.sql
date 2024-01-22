WITH AUX AS
    (SELECT 
       C.CUSTOMER_ID,
       B.PRODUCT_ID,
       SUM(IFNULL(B.PRICE, 0)) AS PRICE,
        CASE
            WHEN B.PRODUCT_ID != 1 THEN SUM(PRICE*10)
            ELSE SUM(PRICE*20)
        END AS PUNTOS 
    FROM SALES A
    INNER JOIN MENU B
        ON A.PRODUCT_ID = B.PRODUCT_ID
    RIGHT JOIN MEMBERS C
        ON A.CUSTOMER_ID= C.CUSTOMER_ID
    GROUP BY C.CUSTOMER_ID, B.PRODUCT_ID)
SELECT 
    CUSTOMER_ID,
    SUM(IFNULL(PUNTOS, 0)) AS PUNTOS
FROM AUX
GROUP BY CUSTOMER_ID;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! Muy bien usado el with para evitar subconsutlas, nada que objetar pues también me gusta mucho como está tabulado y limpio el código.
*/
