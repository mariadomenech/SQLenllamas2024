/* 
    Dia 5 Josep quiere repartir tarjetas de fidelización a sus clientes,
    si cada euro gastado equivale a 10 puntos y el sushi tiene un multiplicador de X2 puntos
    ¿Cuántos puntos tendría cada cliente?
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT
    MEMBERS.CUSTOMER_ID,
    NVL(SUM(
        CASE
            WHEN MENU.PRODUCT_NAME = 'sushi' 
                THEN 2 * 10 * MENU.PRICE
            ELSE 10 * MENU.PRICE
        END
    ),0) AS TOTAL_PUNTOS
FROM MEMBERS
LEFT JOIN SALES
    ON MEMBERS.CUSTOMER_ID = SALES.CUSTOMER_ID
LEFT JOIN MENU
    ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY MEMBERS.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto y la legibilidad del código ha mejorado. Me ha gustado que no lo des por hecho y añadas los use de la database y el schema a pesar de no ser algo global de SQL sino de Snowflake.

A modo de detalle, otra posible opción sería utilizar un iff en lugar del case:

SELECT
      A.CUSTOMER_ID
    , IFNULL(SUM(IFF(B.PRODUCT_ID = 1, 2*10*C.PRICE, 10*C.PRICE)), 0) AS PUNTOS
FROM MEMBERS A
    LEFT JOIN SALES B 
        ON A.CUSTOMER_ID = B.CUSTOMER_ID
    LEFT JOIN MENU C
        ON B.PRODUCT_ID = C.PRODUCT_ID
GROUP BY A.CUSTOMER_ID;

*/
