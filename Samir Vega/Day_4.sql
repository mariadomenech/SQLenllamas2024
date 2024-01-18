--------------------------------------------------------------DIA_4----------------------------------------------------------

SELECT TOP 1
    PRODUCT_NAME,
    COUNT(*) AS CONTEO_PEDIDOS
FROM SALES A
INNER JOIN MENU B
    ON A.PRODUCT_ID = B.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY CONTEO_PEDIDOS DESC;