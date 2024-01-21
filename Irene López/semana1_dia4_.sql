-- ¿Cuál es el producto más pedido del menú y cuantas veces ha sido pedido?
WITH CTE AS(
  SELECT
    PRODUCT_ID
    , COUNT(PRODUCT_ID) AS "Veces pedido"
    FROM SALES
    GROUP BY PRODUCT_ID
)
SELECT
    PRODUCT_NAME AS "Producto más pedido del menú"
    , "Veces pedido"
FROM CTE C
    LEFT JOIN MENU M
        ON C.PRODUCT_ID = M.PRODUCT_ID
WHERE "Veces pedido"=(SELECT MAX("Veces pedido") FROM CTE)
;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Muy bien Irene!!

No hace falta hacer una subconsulta de nuevo en el WHERE de la línea 15. Puedes directamente hacer un TOP 1 al crear la tabla CTE y ahorras tiempo de CPU.

Las dobles comillas para los alias no son necesarias, por si quieres ahorrarte escribirlas.

*/
