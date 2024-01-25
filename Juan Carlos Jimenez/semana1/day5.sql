------DIA 5---------
SELECT CUSTOMER_ID,
    SUM(ZEROIFNULL(TOTAL_GASTADO)) AS GASTADO
FROM(
    SELECT M.CUSTOMER_ID,
        S.PRODUCT_ID,
        PRODUCT_NAME,
        CASE WHEN S.PRODUCT_ID = 1 THEN SUM(PRICE)*2*10 ELSE (SUM(PRICE)*10) END AS TOTAL_GASTADO
    FROM SALES S
    RIGHT JOIN MEMBERS M
    ON M.CUSTOMER_ID = S.CUSTOMER_ID
    LEFT JOIN MENU ME
    ON S.PRODUCT_ID = ME.PRODUCT_ID
    GROUP BY M.CUSTOMER_ID,S.PRODUCT_ID,PRODUCT_NAME
) AS SUB
GROUP BY 1
ORDER BY CUSTOMER_ID
/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Juanqui!!

*/
