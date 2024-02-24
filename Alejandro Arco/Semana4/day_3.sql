/* Day 3
    Crea una única consulta sql para replicar la tabla product_details. Hay que transformar los conjuntos
    de datos product_hierarchy y product_prices.
*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE04;

WITH product_styles AS (
    SELECT
        id AS id_style,
        parent_id,
        level_text AS style_name
    FROM product_hierarchy
    WHERE level_name = 'Style'
),

product_segments AS (
    SELECT
        id AS id_segment,
        parent_id,
        level_text AS segment_name
    FROM product_hierarchy
    WHERE level_name = 'Segment' 
),

product_category AS (
    SELECT
        id AS id_category,
        level_text AS category_name
    FROM product_hierarchy
    WHERE level_name = 'Category'
)

SELECT
    p.product_id AS product_id,
    p.price AS price,
    CONCAT(psty.style_name, ' ', pcat.category_name,' - ',pcat.category_name) AS product_name,
    pcat.id_category AS category_id,
    pseg.id_segment AS segment_id,
    psty.id_style AS style_id,
    pcat.category_name AS category_name,
    pseg.segment_name AS segment_name,
    psty.style_name AS style_name
FROM product_prices AS p
LEFT JOIN product_styles AS psty
ON p.id = psty.id_style
LEFT JOIN product_segments AS pseg
ON psty.parent_id = pseg.id_segment
LEFT JOIN product_category AS pcat
ON pseg.parent_id = pcat.id_category;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto.

*/
