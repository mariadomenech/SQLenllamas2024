/*Las tablas no están muy limpias, crea un procedimiento almacenado que informando el nombre de la tabla, nos devuelva el número de posibles duplicados*/


CREATE OR REPLACE PROCEDURE contar_duplicados_daniel_jimenez2(tabla_nombre STRING)
RETURNS STRING
LANGUAGE SQL
AS

DECLARE
  total_duplicados INTEGER;
BEGIN
  CASE :tabla_nombre
    WHEN 'PRODUCT_DETAILS' THEN
      SELECT COUNT(*)
      INTO total_duplicados
      FROM (
        SELECT PRODUCT_ID, PRICE, PRODUCT_NAME, CATEGORY_ID, SEGMENT_ID, STYLE_ID, CATEGORY_NAME, SEGMENT_NAME, STYLE_NAME
        FROM PRODUCT_DETAILS
        GROUP BY PRODUCT_ID, PRICE, PRODUCT_NAME, CATEGORY_ID, SEGMENT_ID, STYLE_ID, CATEGORY_NAME, SEGMENT_NAME, STYLE_NAME
        HAVING COUNT(PRODUCT_ID) > 1
      );
    WHEN 'PRODUCT_HIERARCHY' THEN
      SELECT COUNT(*)
      INTO total_duplicados
      FROM (
        SELECT PARENT_ID, LEVEL_TEXT, LEVEL_NAME
        FROM PRODUCT_HIERARCHY
        GROUP BY PARENT_ID, LEVEL_TEXT, LEVEL_NAME
        HAVING COUNT(PARENT_ID) > 1
      );
    WHEN 'PRODUCT_PRICES' THEN
      SELECT COUNT(*)
      INTO total_duplicados
      FROM (
        SELECT PRODUCT_ID, PRICE
        FROM PRODUCT_PRICES
        GROUP BY PRODUCT_ID, PRICE
        HAVING COUNT(PRODUCT_ID) > 1
      );
    WHEN 'SALES' THEN
      SELECT COUNT(*)
      INTO total_duplicados
      FROM (
        SELECT PROD_ID, QTY, PRICE, DISCOUNT, MEMBER, TXN_ID, START_TXN_TIME
        FROM SALES
        GROUP BY PROD_ID, QTY, PRICE, DISCOUNT, MEMBER, TXN_ID, START_TXN_TIME
        HAVING COUNT(PROD_ID) > 1
      );
    ELSE
      RETURN 'La tabla ' || tabla_nombre || ' no es válida.';
  END CASE;

  RETURN 'La tabla ' || tabla_nombre || ' tiene ' || total_duplicados || ' filas duplicadas.';
END;
/*Después de pensar que lo había terminado me puse a revisar tablas y creo que ahora SÍ cuenta bien los duplicados, en la versión anterior en la tabla HIERARCHY me daba 2 duplicados*/

CALL contar_duplicados_daniel_jimenez2 ('SALES');
CALL contar_duplicados_daniel_jimenez2 ('PRODUCT_PRICES');
CALL contar_duplicados_daniel_jimenez2 ('PRODUCT_HIERARCHY');
CALL contar_duplicados_daniel_jimenez2 ('PRODUCT_DETAILS');
