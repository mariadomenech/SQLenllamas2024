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
