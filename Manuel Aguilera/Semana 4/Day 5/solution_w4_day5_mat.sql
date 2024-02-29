CREATE OR REPLACE FUNCTION SQL_EN_LLAMAS.CASE04.FUNCION_DAY5_WEEK4_MAT (category INTEGER, segment INTEGER)
  RETURNS TABLE(PROD_ID STRING, CANTIDAD INTEGER) 
  AS 
  $$
        WITH SALES_CLEAN AS (
        SELECT *
            FROM SQL_EN_LLAMAS.CASE04.SALES 
        GROUP BY PROD_ID, QTY, PRICE, DISCOUNT, MEMBER, TXN_ID, START_TXN_TIME
        )
        SELECT 
            PROD_ID, 
            CANTIDAD
        FROM(
        select 
            PROD_ID, 
            SUM(QTY) AS CANTIDAD,
            RANK() OVER (ORDER BY CANTIDAD DESC) AS ORDEN
        FROM SALES_CLEAN A
        INNER JOIN SQL_EN_LLAMAS.CASE04.PRODUCT_DETAILS B
            ON (A.PROD_ID = B.PRODUCT_ID)
        WHERE CATEGORY_ID=category AND SEGMENT_ID=segment
        GROUP BY 1)
        WHERE ORDEN = 1
  $$
  ;

SELECT * FROM TABLE(SQL_EN_LLAMAS.CASE04.FUNCION_DAY5_WEEK4_MAT(1,3));

/*COMENTARIOS JUANPE: TODO CORRECTO*/
