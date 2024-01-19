-- ¿Cuántos puntos tiene cada cliente si cada € gastado equivale a 10 puntos y el sushi tiene un multiplicador de 2 puntos?
WITH CTE AS(
    SELECT 
         PRODUCT_ID
        , PRODUCT_NAME
        , CASE
            WHEN PRODUCT_NAME = 'sushi' THEN 2 -- Si es sushi tiene un multiplicador de x2 puntos
            ELSE 1
           END AS MULTIPLICADOR
        , PRICE
        , (PRICE * 10 * MULTIPLICADOR) AS CHUPIPUNTOS -- 1€ = 10 puntos
    FROM MENU
)
SELECT 
    CUSTOMER_ID
    , SUM(CHUPIPUNTOS) AS TOTAL_CHUPIPUNTOS
FROM SALES S
    LEFT JOIN CTE C
        ON S.PRODUCT_ID = C.PRODUCT_ID
GROUP BY 
    CUSTOMER_ID
;
