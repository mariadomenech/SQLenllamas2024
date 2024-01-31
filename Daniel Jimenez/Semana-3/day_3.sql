/*Crear un procedimiento almacenado que al introducir el identificador del cliente y el mes, calcule el total de compras (purchase) y que te devuelva el siguiente mensaje:
"El cliente 1 se ha gastado un total de 1276 EUR en compras de productos en el mes de marzo"*/

USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;
CREATE OR REPLACE PROCEDURE calcular_compras_daniel_jimenez(CUSTOMER_ID INT, mes VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
  total_compras INTEGER;
BEGIN
    SELECT SUM(TXN_AMOUNT) INTO total_compras
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE CUSTOMER_ID = :CUSTOMER_ID AND TXN_TYPE = 'purchase' AND EXTRACT(MONTH FROM TXN_DATE) = CAST (:mes AS INT);
  
  RETURN 'El cliente ' || :CUSTOMER_ID || ' se ha gastado un total de ' || total_compras || ' EUR en compras de productos en el mes de ' || :mes;
END;
CALL calcular_compras_daniel_jimenez (1,3); --Es un ejemplo, se pueden cambiar los parámetros de entrada para que el PROCEDURE actúe según lo que el usuario requiera. Vaya, lo que hace un procedure jajaja
