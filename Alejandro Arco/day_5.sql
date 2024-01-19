/* 
    Dia 5 Josep quiere repartir tarjetas de fidelización a sus clientes,
    si cada euro gastado equivale a 10 puntos y el sushi tiene un multiplicador de X2 puntos
    ¿Cuántos puntos tendría cada cliente?
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT
    MEMBERS.CUSTOMER_ID,
    NVL(
        SUM(
            CASE
                WHEN MENU.PRODUCT_NAME = 'sushi' 
                    THEN 2 * 10 * MENU.PRICE
                ELSE 10 * MENU.PRICE
            END
        )
    ,0) AS TOTAL_PUNTOS
FROM
    MEMBERS
LEFT JOIN
    SALES
ON MEMBERS.CUSTOMER_ID = SALES.CUSTOMER_ID
FULL JOIN
    MENU
ON  SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY MEMBERS.CUSTOMER_ID;