    SELECT 
        S.CUSTOMER_ID AS CLIENTE,
        SUM(CASE 
            WHEN M.PRODUCT_NAME = 'sushi' then M.PRICE * 10 * 2
            ELSE M.PRICE * 10
        END) AS PUNTOS
    FROM SALES S
    JOIN MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
    GROUP BY 1

------------- Si queremos que los clientes que no han realizado ningún pedido o compra aparezcan con 0 puntos-------------------------
        
   WITH CALCULO_PUNTOS AS 
   (SELECT 
        S.CUSTOMER_ID  AS CLIENTE_CP,
        SUM(CASE 
            WHEN M.PRODUCT_NAME = 'sushi' then M.PRICE * 10 * 2
            ELSE M.PRICE * 10
        END) AS SUMA_PUNTOS
    FROM SALES S
    JOIN MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
    GROUP BY 1
 )
 SELECT 
    C.CUSTOMER_ID,
    CASE
        WHEN CALCULO_PUNTOS.SUMA_PUNTOS IS NULL THEN '0'
        ELSE CALCULO_PUNTOS.SUMA_PUNTOS
    END AS PUNTOS
FROM MEMBERS C
LEFT JOIN CALCULO_PUNTOS
    ON C.CUSTOMER_ID = CALCULO_PUNTOS.CLIENTE_CP
