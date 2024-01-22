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


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Casi. A la hora de hacer el producto con el multiplicador se ha liado un poco.

Si separas en columnas diferentes SUM(10*(PRICE)) y
POW(2, SUM(CASE WHEN PRODUCT_NAME = 'sushi' THEN 1 ELSE 0 END)) AS TOTAL_POINTS_PER_DATE
lo verás más claro.

Estás diciendo en tu consulta, súmame el total gastado por CLIENTE y FECHA, y si en esta partición (cliente + fecha) encuentras un pedido de sushi,
multiplica por 2 el total gastado.

Es decir, no solo estás multiplicando por 2 lo gastado en sushi por el cliente A, al hacer la sumatoria por fecha y no por producto, estás multiplicando por 2
todo lo gastado el día 2021-01-01, que fue el día que el cliente A pidió SUSHI.

Pero en realidad solo queremos multiplicar el producto sushi, a la hora de hacer sumatoria y producto, tienes que sacarte todas las columnas necesarias y
que influyen en el cálculo de puntos. En este caso, CUSTOMER_ID y PRODUCT_NAME.

*/
