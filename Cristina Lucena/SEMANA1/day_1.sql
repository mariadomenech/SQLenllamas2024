SELECT A.CUSTOMER_ID
    ,IFNULL(SUM(C.PRICE),0) AS GASTO
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
ON A.CUSTOMER_ID = B.CUSTOMER_ID
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU C
ON B.PRODUCT_ID = C.PRODUCT_ID
GROUP BY A.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto, aunque el IFNULL fuera de la suma podria generar resultados erróneos.

Respecto a la legibilidad del código tabularía los ONs de los joins:

SELECT A.CUSTOMER_ID
    ,SUM(IFNULL(C.PRICE,0)) AS GASTO
FROM SQL_EN_LLAMAS.CASE01.MEMBERS A
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES B
    ON A.CUSTOMER_ID = B.CUSTOMER_ID
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU C
    ON B.PRODUCT_ID = C.PRODUCT_ID
GROUP BY A.CUSTOMER_ID;

*/
