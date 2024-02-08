--Se limpia la tabla para eliminar duplicados
WITH SALES_CLEAN AS (
SELECT *
    FROM SQL_EN_LLAMAS.CASE04.SALES 
GROUP BY PROD_ID, QTY, PRICE, DISCOUNT, MEMBER, TXN_ID, START_TXN_TIME
)
SELECT 
    TXN_ID, 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY INGRESO_TOTAL) AS PERCENTIL_25, 
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY INGRESO_TOTAL) AS PERCENTIL_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY INGRESO_TOTAL) AS PERCENTIL_75
FROM(
    SELECT  
        PROD_ID,
        TXN_ID,
        SUM(PRICE * QTY * (1 - DISCOUNT/100)) AS INGRESO_TOTAL -- Calcula el ingreso por cada producto y transacción. 
    FROM SALES_CLEAN
    GROUP BY 1,2
)
GROUP BY 1;