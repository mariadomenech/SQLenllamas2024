SELECT 
    S.CUSTOMER_ID AS CLIENTE,
    M.PRODUCT_NAME AS PRODUCTO
FROM SALES S
JOIN (
    SELECT
        CUSTOMER_ID,
        MIN(ORDER_DATE) AS FECHA_PRIMER_PEDIDO
    FROM SALES
    GROUP BY 1
    ) AS MIN_FECHA
ON S.ORDER_DATE = MIN_FECHA.FECHA_PRIMER_PEDIDO
LEFT JOIN MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1,2

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. Como detalle, se podría mejorar la salida de la query utilizando LISTAGG, teniendo así un único registro por cliente.

*/
