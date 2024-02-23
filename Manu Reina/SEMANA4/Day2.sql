-- DAY 2--
--¿cuál es la combinación más repetida de productos en una sola transacción
--La combinación debe ser al menos de 3 productos distintos--

USE SCHEMA SQL_EN_LLAMAS.CASE04;

WITH PRODUCTOS_POR_TRANSACCION AS
(
    SELECT
        TXN_ID
       ,COUNT(DISTINCT PROD_ID) AS PRODUCTOS
    FROM SALES
    GROUP BY 1
    HAVING (PRODUCTOS >= 3)

),
PRODUCTOS_AGG AS
(
    SELECT
        TXN_ID
       ,LISTAGG((PROD_ID||': '||PRODUCT_NAME),', ') WITHIN GROUP (ORDER BY PROD_ID) AS LISTA_PRODUCTOS
    FROM SALES
    INNER JOIN PRODUCT_DETAILS PD
            ON SALES.PROD_ID = PD.PRODUCT_ID
    GROUP BY 1
)

SELECT
    LISTA_PRODUCTOS
   ,N_TRANSACCIONES
FROM (
        SELECT
            LISTA_PRODUCTOS
           ,COUNT(A.TXN_ID) AS N_TRANSACCIONES
           ,RANK() OVER(ORDER BY N_TRANSACCIONES DESC) AS RANKING_LISTA_PRODUCTOS
        FROM PRODUCTOS_AGG A
        INNER JOIN PRODUCTOS_POR_TRANSACCION B
                ON A.TXN_ID = B.TXN_ID
        GROUP BY 1)A
WHERE RANKING_LISTA_PRODUCTOS = 1;

/*
COMENTARIOS JUANPE:
Correcto el resultado, el código y la legibilidad. Tal vez la sálida se podía haber intentado montar de otra forma pero correcto.
*/
