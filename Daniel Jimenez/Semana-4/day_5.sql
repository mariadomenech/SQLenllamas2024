/*DÍA 5. Crear una función que, introduciéndole una categoría y segmento, muestre el producto mas vendido de cada categoría y segmento.*/


CREATE OR REPLACE FUNCTION prueba_top_ventas_djr (p_category_id INT , p_segment_id INT)
RETURNS TABLE (
    category_id INT
,   segment_id INT
,   product_id VARCHAR
,   product_name VARCHAR
,   total_ventas NUMERIC
)
AS 
$$
SELECT  CAT.ID AS CATEGORY_ID
    ,   SEG.ID AS SEGMENT_ID
    ,   CAST(P.PRODUCT_ID AS VARCHAR) AS PRODUCT_ID
    ,   CONCAT(STYLE.LEVEL_TEXT, ' ', SEG.LEVEL_TEXT, ' - ' , CAT.LEVEL_TEXT) AS PRODUCT_NAME
    ,   SUM(QTY) AS total_ventas
FROM SALES S
INNER JOIN PRODUCT_PRICES P
    ON S.PROD_ID = P.PRODUCT_ID
LEFT JOIN PRODUCT_HIERARCHY STYLE
    ON STYLE.ID = P.ID AND STYLE.LEVEL_NAME = 'Style'
LEFT JOIN PRODUCT_HIERARCHY SEG
    ON SEG.ID = STYLE.PARENT_ID AND SEG.LEVEL_NAME = 'Segment'
LEFT JOIN PRODUCT_HIERARCHY CAT 
    ON CAT.ID = SEG.PARENT_ID AND CAT.LEVEL_NAME = 'Category'
WHERE SEG.ID = p_segment_id
AND CAT.ID = p_category_id
GROUP BY
    CAT.ID
,   SEG.ID
,   P.PRODUCT_ID
,   CONCAT(STYLE.LEVEL_TEXT, ' ', SEG.LEVEL_TEXT, ' - ', CAT.LEVEL_TEXT)
ORDER BY
total_ventas DESC
LIMIT 1
$$;

SELECT * FROM TABLE(prueba_top_ventas_djr(2, 6)); --Me fijo en PRODUCT_DETAILS para ver los ID que paso de parámetros y comprobar que los resultados son correctos.
