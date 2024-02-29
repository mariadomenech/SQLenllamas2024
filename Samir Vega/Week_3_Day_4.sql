-----------------------------------TABLA ORIGEN-------------------------------------
CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT AS
    SELECT
        *
    FROM CUSTOMER_TRANSACTIONS
        PIVOT (COUNT(TXN_TYPE)
                 FOR TXN_TYPE IN ('deposit','purchase','withdrawal'))
                    AS A (CUSTOMER_ID, TXN_DATE, TXN_AMOUNT, DEPOSIT, PURCHASE, WITHDRAWAL);

--------------------------------------------------------------DIA_4----------------------------------------------------------

CREATE OR REPLACE PROCEDURE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CALCULOS_X_CLIENTE_Y_MES (TIPO CHAR(20), CUSTOMER_ID INT, MES INT)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
  total_compras INT;
  total_depositos INT;
  total_retiros INT;
  balance INT;
  nombre_mes CHAR(4);
BEGIN

    SELECT TOP 1
        MONTHNAME(TXN_DATE) INTO nombre_mes
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT
    WHERE MONTH(TXN_DATE) = :MES;

    SELECT
        ZEROIFNULL(SUM(TXN_AMOUNT)) INTO total_compras
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT
    WHERE CUSTOMER_ID = :CUSTOMER_ID
        AND MONTH(TXN_DATE) = :MES
        AND PURCHASE = 1
    GROUP BY CUSTOMER_ID, MONTH(TXN_DATE);

    SELECT
        ZEROIFNULL(SUM(TXN_AMOUNT)) INTO total_depositos
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT
    WHERE CUSTOMER_ID = :CUSTOMER_ID
        AND MONTH(TXN_DATE) = :MES
        AND DEPOSIT = 1
    GROUP BY CUSTOMER_ID, MONTH(TXN_DATE);

    SELECT
        ZEROIFNULL(SUM(TXN_AMOUNT)) INTO total_retiros
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT
    WHERE CUSTOMER_ID = :CUSTOMER_ID
        AND MONTH(TXN_DATE) = :MES
        AND WITHDRAWAL = 1
    GROUP BY CUSTOMER_ID, MONTH(TXN_DATE);

    balance := ZEROIFNULL(total_depositos) - ZEROIFNULL(total_compras) - ZEROIFNULL(total_retiros);

    CASE
        WHEN UPPER(TRIM(:TIPO)) = 'BALANCE' AND (total_depositos IS NOT NULL OR total_compras IS NOT NULL OR total_retiros IS NOT NULL)
            THEN
                RETURN 'El balance del cliente '||:CUSTOMER_ID||' es de '||balance||' euros durante el mes de '||nombre_mes||'.';
        
        WHEN UPPER(TRIM(:TIPO)) = 'TOTALDEPOSITADO' AND total_depositos IS NOT NULL
            THEN
                RETURN 'El cliente '||:CUSTOMER_ID||' ha depositado un total de '||total_depositos||' euros durante el mes de '||nombre_mes||'.';
            
        WHEN UPPER(TRIM(:TIPO)) = 'TOTALDECOMPRAS' AND total_compras IS NOT NULL
            THEN
                RETURN 'El cliente '||:CUSTOMER_ID||' se ha gastado un total de '||total_compras||' euros en compras durante el mes de '||nombre_mes||'.';
            
        WHEN UPPER(TRIM(:TIPO)) = 'TOTALDERETIROS' AND total_retiros IS NOT NULL
            THEN
                RETURN 'El cliente '||:CUSTOMER_ID||' ha retirado un total de '||total_retiros||' euros durante el mes de '||nombre_mes||'.';
        ELSE
            RETURN 'No se puede calcular este valor para el cliente '||:CUSTOMER_ID||' durante el mes de '||nombre_mes||'.';
    END CASE;
END;

------------------------------COMPROBACIÓN--------------------------------


CALL  ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CALCULOS_X_CLIENTE_Y_MES ('balance',6,2);
CALL  ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.CALCULOS_X_CLIENTE_Y_MES ('Total de retiros',1,3);

/*COMENTARIOS JUANPE: TODO CORRECTO Y BIEN ORGANIZADO EL CÓDIGO*/
