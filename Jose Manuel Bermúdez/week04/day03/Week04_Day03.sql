USE SQL_EN_LLAMAS;
USE SCHEMA case04;

CREATE TEMPORARY TABLE SQL_EN_LLAMAS.CASE04.JMBA_PRODUCT_DETAILS AS (
	WITH categories AS (
		SELECT id AS categ_id,
				level_text AS categ_text
		FROM product_hierarchy 
		WHERE lower(level_name) = 'category'
	),
	segments AS (
		SELECT parent_id AS categ_id,
				id AS segm_id,
				level_text AS segm_text
		FROM product_hierarchy 
		WHERE lower(level_name) = 'segment'
	),
	styles AS (
		SELECT parent_id AS segm_id,
				id AS style_id,
				level_text AS style_text
		FROM product_hierarchy 
		WHERE lower(level_name) = 'style'
	),
	prod_final AS (
		SELECT cat.categ_id AS category_id,
				categ_text AS category_name,
				seg.segm_id AS segment_id,
				segm_text AS segment_name,
				style_id,
				style_text AS style_name
		FROM categories cat
		JOIN segments seg
			on cat.categ_id = seg.categ_id
		JOIN styles sty
			on seg.segm_id = sty.segm_id
	)
	SELECT product_id,
			price,
			concat(style_name, ' ', segment_name, ' - ', category_name) AS product_name,
			category_id,
			segment_id,
			style_id,
			category_name,
			segment_name,
			style_name
	FROM prod_final pf
	JOIN product_prices pp
		ON pf.style_id = pp.id
);

SELECT * FROM JMBA_PRODUCT_DETAILS;