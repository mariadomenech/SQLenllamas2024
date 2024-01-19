/* 

He considerado que se deben calcular los puntos por fecha, es decir, 
sumas el precio total gastado en una fecha concreta y lo multiplicas 
por 2^(nº de sushis pedidos ese día). Después agrupamos por customer_id
para obtener los puntos totales.

*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE01;

SELECT CUSTOMER_ID, SUM(TOTAL_POINTS_PER_DATE) AS TOTAL_POINTS FROM (
    SELECT 
        CUSTOMER_ID,
        ORDER_DATE,
        SUM(10*(PRICE)) * POW(2, SUM(CASE WHEN PRODUCT_NAME = 'sushi' THEN 1 ELSE 0 END)) AS TOTAL_POINTS_PER_DATE
    FROM (
        SELECT 
            M.CUSTOMER_ID,
            MEN.PRODUCT_NAME,
            IFNULL(MEN.PRICE,0) AS PRICE,
            S.ORDER_DATE
        FROM SALES S
        LEFT JOIN MENU MEN 
            ON S.PRODUCT_ID = MEN.PRODUCT_ID
        RIGHT JOIN MEMBERS M 
            ON S.CUSTOMER_ID = M.CUSTOMER_ID
    ) AS A
    GROUP BY CUSTOMER_ID, ORDER_DATE
    ORDER BY CUSTOMER_ID, ORDER_DATE
)
GROUP BY CUSTOMER_ID;