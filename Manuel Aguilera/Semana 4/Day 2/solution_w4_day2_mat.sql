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

/*
COMENTARIOS JUANPE:
Todo correcto, de hecho me gusta mucho tu versión simple y clara y bien la salida en un array. Pero cuidado con el LIMIT 1, en este caso no hay problema pero en caso de empates, solo
obtienes un resultado. Es mejor en este tipo de ejercicios usar algo tipo rank o una subconsulta para filtrar por el/los máximos.
*/
