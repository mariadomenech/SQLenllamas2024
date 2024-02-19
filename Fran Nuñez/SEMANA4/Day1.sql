/*SEMANA 4 - DÍA 1*/

USE SCHEMA SQL_EN_LLAMAS.CASE04;

CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE04.DUPLICATES_FNM(DUP VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS OWNER
AS

DECLARE
  DUPLICATES_TOTAL INTEGER;
BEGIN
  CASE :DUP
    WHEN 'PRODUCT_DETAILS' THEN
      SELECT COUNT(*) - COUNT(DISTINCT PRODUCT_ID,
      PRICE,
      PRODUCT_NAME,
      CATEGORY_ID,
      SEGMENT_ID,
      STYLE_ID,
      CATEGORY_NAME,
      SEGMENT_NAME,
      STYLE_NAME) INTO DUPLICATES_TOTAL
FROM PRODUCT_DETAILS;
    WHEN 'SALES' THEN
      SELECT COUNT(*) - COUNT(DISTINCT PROD_ID,
      QTY,
      PRICE,
      DISCOUNT,
      MEMBER,
      TXN_ID,
      START_TXN_TIME) INTO DUPLICATES_TOTAL
FROM SALES;
    ELSE
      RETURN 'The table ' || :DUP || ' is not a valid table identifier.';
  END CASE;

  RETURN 'The table ' || :DUP || ' has ' || DUPLICATES_TOTAL || ' duplicates.';
END;

/*AHORA LLAMAMOS A LAS TABLAS CORRESPONDIENTES, COMO SE PUEDE VER EN EL TERCER CALL, LA TABLA ES INCORRECTA Y DEVUELVE EL MENSAJE DE ERROR*()*/

CALL DUPLICATES_FNM ('SALES');
CALL DUPLICATES_FNM ('PRODUCT_DETAILS');
CALL DUPLICATES_FNM ('CONSUMERS')

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

perfecto!



*/
