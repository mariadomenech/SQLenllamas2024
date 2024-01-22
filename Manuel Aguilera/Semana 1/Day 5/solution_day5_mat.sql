SELECT C.CUSTOMER_ID, 
        NVL(SUM(
                CASE WHEN PRODUCT_NAME='sushi'
                    THEN PRICE*20 
                    ELSE PRICE*10 
                END)
            ,0) AS GASTO_TOTAL
FROM SQL_EN_LLAMAS.CASE01.MEMBERS C
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES A 
    ON (C.CUSTOMER_ID=A.CUSTOMER_ID)
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU B 
    ON (A.PRODUCT_ID = B.PRODUCT_ID)
GROUP BY C.CUSTOMER_ID;

/*********************************/
/***** COMENTARIO JUAN PEDRO *****/
/*********************************/
/*
¡Todo correcto enhorabuena! Realmente te has dado cuenta que no hace falta una subconsulta y has usado solo una select, muy bien optimizado el código.
*/
