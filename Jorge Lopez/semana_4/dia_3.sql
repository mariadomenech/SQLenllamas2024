/*Día 3 Crear en una única consulta la tabla PRODUCT_DETAILS usando las otras datos de dos tablas 

Me ha costado mucho sacar según que valores de columnas. Quizá esta no es la manera más optima, eso si, el resultado es el que se pide, jeje.

Actualización: He visto que puedo usar la tabla temporal y filtrarla al volverla a cruzar para quedarme solo con los segmentos. 
Al principio creaba otra temporal solo con los segmentos, pero no hace falta.
*/

SELECT * FROM CASE04.PRODUCT_DETAILS;
SELECT * FROM CASE04.PRODUCT_HIERARCHY; 
SELECT * FROM CASE04.PRODUCT_PRICES; 

-- Las tres consultas anteriores son para tener referencias.

WITH 
    ALL_CATEG AS (
        SELECT ID, LEVEL_TEXT, "'Style'"AS STYLE, "'Segment'" AS SEGMENT, "'Category'" AS CATEGORY
        FROM CASE04.PRODUCT_HIERARCHY AS H
        PIVOT (
            MAX(LEVEL_NAME) FOR LEVEL_NAME IN ('Category', 'Segment', 'Style')
        ) AS PT
        ORDER BY ID
    )
    
SELECT  
    PROD_ID,
    PRICE,
    CONCAT(STYLE_NAME,' ',SEGMENT_NAME,'-',CATEGORY_NAME) AS PRODUCT_NAME,
    CATEGORY_ID, 
    SEGMENT_ID,
    STYLE_ID,
    CATEGORY_NAME,
    SEGMENT_NAME,
    STYLE_NAME
FROM
    (SELECT 
        PROD_ID,
        PRICE,
        CATEGORY_ID, 
        SEGMENT_ID,
        STYLE_ID,
        CASE WHEN CATEGORY_ID = 1 THEN 'Womens' ELSE 'Mens' END AS CATEGORY_NAME,
        S.LEVEL_TEXT AS SEGMENT_NAME,
        STYLE_NAME
    FROM
        (SELECT 
            CASE WHEN H.PARENT_ID BETWEEN 3 AND 4 THEN 1 ELSE 2 END AS CATEGORY_ID,
            H.PARENT_ID AS SEGMENT_ID,
            H.LEVEL_TEXT AS L_TEXT,
            H.LEVEL_NAME AS L_NAME,
            A.ID AS STYLE_ID,
            A.LEVEL_TEXT AS STYLE_NAME,
            P.PRICE AS PRICE,
            P.PRODUCT_ID AS PROD_ID
        FROM CASE04.PRODUCT_HIERARCHY AS H
        INNER JOIN ALL_CATEG AS A
        ON H.ID = A.ID
        LEFT JOIN CASE04.PRODUCT_PRICES AS P
        ON P.ID = H.ID)
    INNER JOIN ALL_CATEG AS S
    ON S.ID = SEGMENT_ID
    AND SEGMENT IS NOT NULL)
WHERE PROD_ID IS NOT NULL;
