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
