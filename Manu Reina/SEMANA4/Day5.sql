--DAY 5--
/*CREA UNA FUNCION QUE INTRODUCIENDOLE UNA CATEGORIA Y SEGMENTO
MUESTRE EL PRODUCTO MAS VENDIDO DE CADA CATEGORIA Y SEGMENTO*/


CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE04.MRA_PRODUCTO_MAS_VENDIDO_CAT_SEG(categoria VARCHAR, segmento VARCHAR)
RETURNS TABLE(PROD_ID VARCHAR, PRODUCT_NAME VARCHAR, VENDIDOS INT)
LANGUAGE SQL
AS 
$$
    WITH CLEANED_SALES AS
    (
        SELECT
            DISTINCT *
        FROM SQL_EN_LLAMAS.CASE04.SALES
    )
    SELECT
         PROD_ID
        ,PRODUCT_NAME
        ,VENDIDOS
    FROM (
            SELECT
                S.PROD_ID
               ,SUM(QTY) AS VENDIDOS
               ,PD.PRODUCT_NAME
               ,PD.CATEGORY_ID
               ,PD.CATEGORY_NAME
               ,PD.SEGMENT_ID
               ,PD.SEGMENT_NAME
               ,RANK() OVER(ORDER BY VENDIDOS DESC) AS RANKING_PRODUCTOS
            FROM CLEANED_SALES S
            INNER JOIN SQL_EN_LLAMAS.CASE04.PRODUCT_DETAILS PD
                   ON S.PROD_ID = PD.PRODUCT_ID
                  AND UPPER(TRIM(CATEGORY_NAME)) = UPPER(TRIM(categoria))
                  AND UPPER(TRIM(SEGMENT_NAME)) = UPPER(TRIM(segmento))
            GROUP BY 1,3,4,5,6,7)A
    WHERE RANKING_PRODUCTOS = 1
$$;


SELECT * FROM TABLE(SQL_EN_LLAMAS.CASE04.MRA_PRODUCTO_MAS_VENDIDO_CAT_SEG('MENS','SOCKS'));

/*COMENTARIOS JUANPE: TODO CORRECTO*/
