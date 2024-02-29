
-- DAY 5--

CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.MESES AS
    SELECT
      1 AS MONTH_NUMBER, 'ENERO' AS MONTH_NAME
    UNION ALL SELECT 2, 'FEBRERO'
    UNION ALL SELECT 3, 'MARZO'
    UNION ALL SELECT 4, 'ABRIL'
    UNION ALL SELECT 5, 'MAYO'
    UNION ALL SELECT 6, 'JUNIO'
    UNION ALL SELECT 7, 'JULIO'
    UNION ALL SELECT 8, 'AGOSTO'
    UNION ALL SELECT 9, 'SEPTIEMBRE'
    UNION ALL SELECT 10, 'OCTUBRE'
    UNION ALL SELECT 11, 'NOVIEMBRE'
    UNION ALL SELECT 12, 'DICIEMBRE';

CREATE OR REPLACE FUNCTION ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_COMPRA_CLIENTE_MES(id_cliente INT, mes VARCHAR)
  RETURNS INT
  LANGUAGE SQL
  AS ' 
  SELECT 
        COALESCE(SUM(GASTO_CLIENTE),0) AS COMPRA_TOTAL
  FROM (
        SELECT 
            CUSTOMER_ID
           ,MONTH(TXN_DATE) AS MES
           ,M.MONTH_NAME
           ,TXN_AMOUNT AS GASTO_CLIENTE
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS CT
        LEFT JOIN  ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.MESES M
               ON MONTH(CT.TXN_DATE) = M.MONTH_NUMBER
        WHERE CT.TXN_TYPE = ''purchase''
        AND CUSTOMER_ID = id_cliente
        AND MONTH_NAME = mes)';

        
        
CREATE OR REPLACE FUNCTION ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_DEPOSITO_CLIENTE_MES(id_cliente INT, mes VARCHAR)
  RETURNS INT
  LANGUAGE SQL
  AS ' 
  SELECT 
        COALESCE(SUM(DEPOSITO),0) AS DEPOSITO_CLIENTE
  FROM (
        SELECT 
            CUSTOMER_ID
           ,MONTH(TXN_DATE) AS MES
           ,M.MONTH_NAME
           ,TXN_AMOUNT AS DEPOSITO
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS CT
        LEFT JOIN  ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.MESES M
               ON MONTH(CT.TXN_DATE) = M.MONTH_NUMBER
        WHERE CT.TXN_TYPE = ''deposit''
        AND CUSTOMER_ID = id_cliente
        AND MONTH_NAME = mes)';

        
CREATE OR REPLACE FUNCTION ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_RETIRO_CLIENTE_MES(id_cliente INT, mes VARCHAR)
  RETURNS INT
  LANGUAGE SQL
  AS ' 
  SELECT 
        COALESCE(SUM(RETIRO),0) AS RETIRO_CLIENTE
  FROM (
        SELECT 
            CUSTOMER_ID
           ,MONTH(TXN_DATE) AS MES
           ,M.MONTH_NAME
           ,TXN_AMOUNT AS RETIRO
        FROM SQL_EN_LLAMAS.CASE03.CUSTOMER_TRANSACTIONS CT
        LEFT JOIN  ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.MESES M
               ON MONTH(CT.TXN_DATE) = M.MONTH_NUMBER
        WHERE CT.TXN_TYPE = ''withdrawal''
        AND CUSTOMER_ID = id_cliente
        AND MONTH_NAME = mes)';




CREATE OR REPLACE FUNCTION ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_BALANCE_CLIENTE_MES(id_cliente INT, mes VARCHAR)
  RETURNS INT
  LANGUAGE SQL
  AS
  '
  SELECT (
    ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_DEPOSITO_CLIENTE_MES(id_cliente, mes) -
    ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_COMPRA_CLIENTE_MES(id_cliente, mes) -
    ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_RETIRO_CLIENTE_MES(id_cliente, mes)
  )';




CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE03.MRA_CALCULO_CLIENTE(id_cliente INTEGER, mes VARCHAR,tipo_calculo varchar)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE

    BALANCE INT;
    TOTAL_DEPOSITADO INT;
    TOTAL_COMPRAS INT;
    TOTAL_RETIRADO INT;
    
BEGIN

    TOTAL_DEPOSITADO := ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_DEPOSITO_CLIENTE_MES(:id_cliente,:mes);
    TOTAL_COMPRAS := ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_COMPRA_CLIENTE_MES(:id_cliente,:mes);
    TOTAL_RETIRADO := ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_RETIRO_CLIENTE_MES(:id_cliente,:mes);    
    BALANCE := ESPECIALIDAD_SQL_BRONZE_DB_MRA.RETO.GET_BALANCE_CLIENTE_MES(:id_cliente, :mes);

    IF (UPPER(TRIM(:tipo_calculo)) = 'BALANCE')
        THEN RETURN 'EL BALANCE ASOCIADO AL CLIENTE ' ||:id_cliente|| ' EN EL MES DE ' ||:mes|| ' ES DE ' ||:BALANCE|| ' EUR.';
        
    ELSEIF (UPPER(TRIM(:tipo_calculo)) = 'TOTALCOMPRAS')
        THEN RETURN  'EL IMPORTE TOTAL DE LA COMPRA DEL CLIENTE ' ||:id_cliente|| ' EN EL MES DE ' ||:mes|| ' ASCIENDE A' ||:TOTAL_COMPRAS|| ' EUR.';

    ELSEIF (UPPER(TRIM(:tipo_calculo)) = 'TOTALDEPOSITADO')
        THEN RETURN 'EL CLIENTE ' ||:id_cliente|| ' HA DEPOSITADO ' ||:TOTAL_DEPOSITADO|| ' EUR EN EL MES DE ' ||:mes|| '.';

    ELSEIF (UPPER(TRIM(:tipo_calculo)) = 'TOTALRETIRADO')
        THEN RETURN  'EL CLIENTE ' ||:id_cliente|| ' HA RETIRADO ' ||:TOTAL_RETIRADO|| ' EUR EN EL MES DE ' ||:mes|| '.';
        
    ELSE
        RETURN 'NO ES POSIBLE DEVOLVER ESTE TIPO DE CÁLCULO';
    END IF;

END;

/*COMENTARIOS JUANPE: TODO CORRECTO*/


CALL SQL_EN_LLAMAS.CASE03.MRA_CALCULO_CLIENTE(1, 'MARZO','totalcompras');
CALL SQL_EN_LLAMAS.CASE03.MRA_CALCULO_CLIENTE(1,'MARZO','balance');

