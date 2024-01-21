SELECT 
       M.PRODUCT_NAME AS PRODUCTO_MAS_VENDIDO
     , COUNT (S.PRODUCT_ID) AS VENTAS
FROM SQL_EN_LLAMAS.CASE01.SALES S
JOIN SQL_EN_LLAMAS.CASE01.MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY VENTAS DESC
LIMIT 1

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Correcto Fernando!!

*/
