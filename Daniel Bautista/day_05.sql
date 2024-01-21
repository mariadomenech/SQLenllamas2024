WITH puntos AS (
SELECT
    a.customer_id,
    b.product_name,
    CASE 
        WHEN product_name = 'sushi' THEN b.price * 10 * 2
        ELSE b.price * 10
    END AS puntos
FROM
    SQL_EN_LLAMAS.CASE01.SALES as a
INNER JOIN
    SQL_EN_LLAMAS.CASE01.MENU as b
ON
    a.product_id = b.product_id
)

SELECT 
c.customer_id,
SUM(c.puntos) AS puntos_totales

FROM 
puntos c

GROUP BY 
c.customer_id

ORDER BY 
puntos_totales DESC;
