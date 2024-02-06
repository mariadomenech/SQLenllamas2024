WITH PRODUCTOS_TRANSACCION AS (
    SELECT 
		TXN_ID, 
		COUNT(DISTINCT PROD_ID) AS PRODUCTOS_REPETIDOS
    FROM SQL_EN_LLAMAS.CASE04.SALES
    GROUP BY 1 HAVING COUNT(DISTINCT PROD_ID)>=3
),
PRODUCTOS_COMBINACION AS (
	SELECT 
		TXN_ID, 
		ARRAY_AGG(PROD_ID) WITHIN GROUP (ORDER BY PROD_ID) AS PRODUCTOS
	FROM SQL_EN_LLAMAS.CASE04.SALES
	GROUP BY 1
)
SELECT 
    PRODUCTOS, 
    COUNT(*) AS NUM_TRANSACCIONES
FROM PRODUCTOS_COMBINACION A 
INNER JOIN PRODUCTOS_TRANSACCION B
    ON (A.TXN_ID=B.TXN_ID)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;