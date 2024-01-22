-- Dia 4 ¿Cuál es el producto más pedido del menú y cuántas veces ha sido pedido?

SELECT TOP 1
    PRODUCT_NAME,
    COUNT(PRODUCT_NAME) AS TOTAL_PEDIDOS
FROM
    MENU
LEFT JOIN
    SALES
ON MENU.PRODUCT_ID = SALES.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY TOTAL_PEDIDOS DESC;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. El TOP 1 es correcto y esta bien utilizado, pero comentar que tambien es posible utilizar LIMIT 1:

SELECT
      PRODUCT_NAME
    , COUNT(PRODUCT_NAME) AS TOTAL_PEDIDOS
FROM MENU
LEFT JOIN SALES
    ON MENU.PRODUCT_ID = SALES.PRODUCT_ID
GROUP BY PRODUCT_NAME
ORDER BY TOTAL_PEDIDOS DESC
LIMIT 1;

Mejoraría la legibilidad/visibilidad del código como he comentado en los ejercicios previos.

*/
