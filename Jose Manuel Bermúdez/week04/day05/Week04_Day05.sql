USE SQL_EN_LLAMAS;
USE SCHEMA case04;

CREATE OR REPLACE FUNCTION JMBA_GET_MOST_SOLD_PRODUCT_CATEG_AND_SEGM (category_id INTEGER, segment_id INTEGER)
	RETURNS TABLE("PRODUCTO MÁS VENDIDO PARA LA CATEGORÍA Y SEGMENTO ESPECIFICADOS EN LA LLAMADA A LA FUNCIÓN" STRING, "CANTIDAD" INTEGER) 
	AS
		$$
			SELECT TOP 1 product_name,
							SUM(qty)
			FROM sales s 
			JOIN product_details pd
				ON s.prod_id = pd.product_id
			WHERE pd.category_id = category_id AND
					pd.segment_id = segment_id
			GROUP BY product_name
			ORDER BY SUM(qty) DESC
		$$
	;

SELECT * FROM TABLE(JMBA_GET_MOST_SOLD_PRODUCT_CATEG_AND_SEGM(1, 3));
