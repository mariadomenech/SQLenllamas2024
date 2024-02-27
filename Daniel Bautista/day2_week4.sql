WITH Combinacion_productos AS (
    SELECT 
        a.txn_id,
        LISTAGG(b.product_name, ', ') WITHIN GROUP (ORDER BY b.product_name) AS productos
    FROM 
        SQL_EN_LLAMAS.CASE04.SALES AS a
    INNER JOIN 
        SQL_EN_LLAMAS.CASE04.PRODUCT_DETAILS AS b ON a.prod_id = b.product_id
    GROUP BY 
        a.txn_id
    HAVING 
        COUNT(DISTINCT b.product_name) >= 3
)
, Combinacion_conteo AS (
    SELECT 
        productos, 
        COUNT(*) AS conteo
    FROM 
        Combinacion_productos
    GROUP BY 
        productos
    ORDER BY 
        conteo DESC
    LIMIT 1
)
SELECT * FROM Combinacion_conteo;
