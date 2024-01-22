SELECT B.CLIENTE,
SUM(B.PUNTOS) AS "PUNTOS TARJETA"
FROM (
    SELECT A.CLIENTE,
    CASE WHEN A.PRODUCTO = 'sushi'
    THEN SUM((A.GASTO*10)*2)
    ELSE SUM(A.GASTO*10)
    END AS "PUNTOS"
    FROM (
        SELECT MEMBERS.CUSTOMER_ID AS "CLIENTE",
        MENU.PRODUCT_NAME AS "PRODUCTO",
        CASE WHEN SUM(MENU.PRICE) IS NULL
        THEN 0
        ELSE SUM(MENU.PRICE)
        END AS "GASTO"
        FROM MEMBERS
        LEFT JOIN SALES
        ON MEMBERS.CUSTOMER_ID = SALES.CUSTOMER_ID
        LEFT JOIN MENU
        ON MENU.PRODUCT_ID = SALES.PRODUCT_ID
        GROUP BY MEMBERS.CUSTOMER_ID,
        MENU.PRODUCT_NAME)A
    GROUP BY A.CLIENTE,
    A.PRODUCTO)B
GROUP BY B.CLIENTE


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Oye, muy bien Fran!!

Las dobles comillas para los alias no hacen falta.

*/
