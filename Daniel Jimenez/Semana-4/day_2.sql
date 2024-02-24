/*¿Cual es la combinación de productos distintos mas repetida en una sola transacción? La combinación debe ser de al menos 3 productos diferentes.*/


WITH    productos_vendidos AS (
    SELECT  TXN_ID
        ,   COUNT(DISTINCT PROD_ID) AS numero_productos
    FROM SALES
    GROUP BY TXN_ID
    HAVING COUNT(DISTINCT PROD_ID) >= 3
),

combinaciones_productos AS (
    SELECT  TXN_ID
        ,   LISTAGG(PRODUCT_NAME, ', ') WITHIN GROUP (ORDER BY PRODUCT_NAME) AS combinacion_producto
    FROM SALES
    INNER JOIN PRODUCT_DETAILS
        ON SALES.PROD_ID = PRODUCT_DETAILS.PRODUCT_ID
    WHERE TXN_ID IN (SELECT TXN_ID FROM productos_vendidos)
    GROUP BY TXN_ID
)

SELECT  combinacion_producto
    ,   COUNT(*) AS frecuencia
FROM combinaciones_productos
GROUP BY combinacion_producto
ORDER BY frecuencia DESC
LIMIT 1;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

*/
