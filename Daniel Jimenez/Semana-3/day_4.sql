/*Evoluciona el procedimiento de ayer para que podamos elegir el tipo de cálculo que nos devuelva por mes y cliente:
-BALANCE: DEPÓSITO - COMPRA - RETIRO
-TOTAL DEPOSITADO
-TOTAL DE COMPRAS
-TOTAL DE RETIROS*/


CREATE OR REPLACE PROCEDURE calcular_compras_daniel_jimenez_2(CUSTOMER_ID INT, mes INT)
RETURNS VARCHAR
LANGUAGE SQL
AS

DECLARE
  total_compras INTEGER;
  total_depositado INTEGER;
  total_retiros INTEGER;
  balance INTEGER;
  mes_nombre STRING;
BEGIN
  SELECT COALESCE(SUM(TXN_AMOUNT), 0)-- He usado COALESCE a modo preventivo para tratar posibles NULLS, tras una revisión he comprobado que no hay casillas NULLS jeje 
  INTO total_depositado
  FROM (
    SELECT TXN_AMOUNT
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE CUSTOMER_ID = :CUSTOMER_ID AND TXN_TYPE = 'deposit' AND EXTRACT(MONTH FROM TXN_DATE) = :mes
    UNION ALL
    SELECT 0 --He tenido que insertar registros a 0 en aquellos customer que no tenían registros de tal tipo, de esta forma he manejado el control de campos inexistentes
  );

  SELECT COALESCE(SUM(TXN_AMOUNT), 0) 
  INTO total_compras
  FROM (
    SELECT TXN_AMOUNT
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE CUSTOMER_ID = :CUSTOMER_ID AND TXN_TYPE = 'purchase' AND EXTRACT(MONTH FROM TXN_DATE) = :mes
    UNION ALL
    SELECT 0
  );

  SELECT COALESCE(SUM(TXN_AMOUNT), 0) 
  INTO total_retiros
  FROM (
    SELECT TXN_AMOUNT
    FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS
    WHERE CUSTOMER_ID = :CUSTOMER_ID AND TXN_TYPE = 'withdrawal' AND EXTRACT(MONTH FROM TXN_DATE) = :mes
    UNION ALL
    SELECT 0
  );
  
  balance := total_depositado - total_compras - total_retiros;

    
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
  
  RETURN 'El cliente ' || :CUSTOMER_ID || ' se ha gastado un total de ' || :total_compras || ' EUR en compras de productos en el mes de ' || :mes_nombre || '. Su balance actual es de ' || :balance || ' EUR, habiendo depositado un total de ' || :total_depositado || ' EUR y retirado un total de ' || :total_retiros || ' EUR.';
END;
