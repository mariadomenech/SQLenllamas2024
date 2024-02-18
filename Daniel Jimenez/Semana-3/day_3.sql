/*Crear un procedimiento almacenado que al introducir el identificador del cliente y el mes, calcule el total de compras (purchase) y que te devuelva el siguiente mensaje:
"El cliente 1 se ha gastado un total de 1276 EUR en compras de productos en el mes de marzo"*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;
CREATE OR REPLACE PROCEDURE calcular_compras_daniel_jimenez(CUSTOMER_ID INT, mes INT)
RETURNS VARCHAR
LANGUAGE SQL
AS

DECLARE
  total_compras INTEGER;
  mes_nombre STRING;
BEGIN
  SELECT SUM(TXN_AMOUNT) INTO total_compras
  FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
  WHERE CUSTOMER_ID = :CUSTOMER_ID AND TXN_TYPE = 'purchase' AND EXTRACT(MONTH FROM TXN_DATE) = :mes;

  SELECT CASE
    WHEN :mes = 1 THEN 'ENERO'
    WHEN :mes = 2 THEN 'FEBRERO'
    WHEN :mes = 3 THEN 'MARZO'
    WHEN :mes = 4 THEN 'ABRIL'
    WHEN :mes = 5 THEN 'MAYO'
    WHEN :mes = 6 THEN 'JUNIO'
    WHEN :mes = 7 THEN 'JULIO'
    WHEN :mes = 8 THEN 'AGOSTO'
    WHEN :mes = 9 THEN 'SEPTIEMBRE'
    WHEN :mes = 10 THEN 'OCTUBRE'
    WHEN :mes = 11 THEN 'NOVIEMBRE'
    WHEN :mes = 12 THEN 'DICIEMBRE'
  END INTO mes_nombre;
  
  RETURN 'El cliente ' || :CUSTOMER_ID || ' se ha gastado un total de ' || :total_compras || ' EUR en compras de productos en el mes de ' || :mes_nombre;
END;
CALL calcular_compras_daniel_jimenez (1,3);--Es un ejemplo, se pueden cambiar los parámetros de entrada para que el PROCEDURE actúe según lo que el usuario requiera. Vaya, lo que hace un procedure jajaja

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto. 

*/
