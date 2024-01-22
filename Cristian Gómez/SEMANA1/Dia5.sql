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
SELECT 
    C.CUSTOMER_ID  AS CLIENTE_CP,
    COALESCE(SUM(CASE 
        WHEN M.PRODUCT_NAME = 'sushi' then M.PRICE * 10 * 2
        ELSE M.PRICE * 10
    END), 0) AS SUMA_PUNTOS
FROM MEMBERS C
LEFT JOIN SALES S
    ON S.CUSTOMER_ID = C.CUSTOMER_ID
LEFT JOIN MENU M
    ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY 1
        
-------- OTRA FORMA PERO MAS LARGA (SI, ES EL RESULTADO DE PROBAR COSAS)-------------
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

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

La segunda opción es la mejor, ya que controlas tanto los nulos como los clientes sin pedidos. Lo único que cambiaría sería el CASE por un IFF, personalmente usaría CASE cuando haya un control de casuísticas
o cuando la condición de la única casuística es compleja:

SELECT 
      C.CUSTOMER_ID AS CLIENTE
    , SUM(IFNULL(IFF(M.PRODUCT_NAME = 'sushi', 2*10*M.PRICE, 10*M.PRICE), 0)) AS PUNTOS
FROM MEMBERS C
    LEFT JOIN SALES S
        ON S.CUSTOMER_ID = C.CUSTOMER_ID
    LEFT JOIN MENU M
        ON S.PRODUCT_ID = M.PRODUCT_ID
GROUP BY CLIENTE;

*/
