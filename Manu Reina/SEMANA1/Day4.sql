-- ¿Cuál es el producto más pedido del menú y cuantas veces ha sido pedido? -- 

SELECT 
     PRODUCTO AS PRODUCTO_MAS_PEDIDO
    ,NUMERO_PEDIDOS
FROM (
        SELECT 
             MENU.PRODUCT_NAME AS PRODUCTO
            ,NUMERO_PEDIDOS
            ,RANK() OVER (ORDER BY NUMERO_PEDIDOS DESC) AS RANKING_PEDIDOS  
        FROM(
            SELECT 
                 SALES.PRODUCT_ID
                ,COUNT(PRODUCT_ID) AS NUMERO_PEDIDOS
            FROM CASE01.SALES
            GROUP BY PRODUCT_ID)A
        LEFT JOIN CASE01.MENU 
               ON A.PRODUCT_ID = MENU.PRODUCT_ID)B
WHERE RANKING_PEDIDOS = 1;
