SELECT TOP 1
    M.PRODUCT_NAME AS PRODUCTO_MAS_VENDIDO,
    COUNT(S.PRODUCT_ID) AS VECES_VENDIDO
FROM SALES S
JOIN MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1
ORDER BY 2 DESC

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. También sería posible utilizar LIMIT 1 al final de la query en logar de TOP 1.

*/
