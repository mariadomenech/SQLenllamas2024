USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT MEN.PRODUCT_NAME AS MOST_POPULAR_PRODUCT, COUNT(1) AS NUM_SALES
    FROM MENU MEN
    LEFT JOIN SALES S
        ON MEN.PRODUCT_ID = S.PRODUCT_ID
    GROUP BY MEN.PRODUCT_NAME
    ORDER BY COUNT(1) DESC
    LIMIT 1;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Perfecto Javi!

*/

