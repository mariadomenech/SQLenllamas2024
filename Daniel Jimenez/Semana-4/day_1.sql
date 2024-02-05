/*Las tablas no están muy limpias, crea un procedimiento almacenado que informando el nombre de la tabla, nos devuelva el número de posibles duplicados*/


CREATE OR REPLACE PROCEDURE contar_duplicados(tabla_nombre STRING)
RETURNS STRING
LANGUAGE SQL
AS

DECLARE
  total_duplicados INTEGER;
BEGIN
  CASE :tabla_nombre
    WHEN 'PRODUCT_DETAILS' THEN
      SELECT COUNT(*) - COUNT(DISTINCT PRODUCT_ID , PRICE , PRODUCT_NAME , CATEGORY_ID , SEGMENT_ID , STYLE_ID , CATEGORY_NAME , SEGMENT_NAME , STYLE_NAME) INTO total_duplicados FROM PRODUCT_DETAILS; -- Al restar el número total de filas únicas del numero total de filas obtenemos el número de filas que están duplicadas.
    WHEN 'PRODUCT_HIERARCHY' THEN
      SELECT COUNT(*) - COUNT(DISTINCT ID , PARENT_ID , LEVEL_TEXT , LEVEL_NAME) INTO total_duplicados FROM PRODUCT_HIERARCHY;
    WHEN 'PRODUCT_PRICES' THEN
      SELECT COUNT(*) - COUNT(DISTINCT ID , PRODUCT_ID , PRICE) INTO total_duplicados FROM PRODUCT_PRICES;
    WHEN 'SALES' THEN
      SELECT COUNT(*) - COUNT(DISTINCT PROD_ID , QTY , PRICE , DISCOUNT , MEMBER , TXN_ID , START_TXN_TIME) INTO total_duplicados FROM SALES;
    ELSE
      RETURN 'La tabla ' || :tabla_nombre || ' no es válida.';
  END CASE;

  RETURN 'La tabla ' || :tabla_nombre || ' tiene ' || total_duplicados || ' filas duplicadas.';
END;

CALL contar_duplicados ('SALES');
CALL contar_duplicados ('PRODUCT_PRICES');
CALL contar_duplicados ('PRODUCT_HIERARCHY');
CALL contar_duplicados ('PRODUCT_DETAILS');
