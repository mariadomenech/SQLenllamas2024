-----------------------------------TABLA ORIGEN-------------------------------------
CREATE OR REPLACE TEMP TABLE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT AS
    SELECT
        *
    FROM CUSTOMER_TRANSACTIONS
        PIVOT (COUNT(TXN_TYPE)
                 FOR TXN_TYPE IN ('deposit','purchase','withdrawal'))
                    AS A (CUSTOMER_ID, TXN_DATE, TXN_AMOUNT, DEPOSIT, PURCHASE, WITHDRAWAL);

-----------------------------------PROCEDURE-------------------------------------
CREATE OR REPLACE PROCEDURE ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.COMPRAS_X_CLIENTE_Y_MES (CUSTOMER_ID INT, MES INT)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
  total_compras INT;
  nombre_mes CHAR(4);
BEGIN
    SELECT
        ZEROIFNULL(SUM(TXN_AMOUNT)) INTO total_compras
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT
    WHERE CUSTOMER_ID = :CUSTOMER_ID
        AND MONTH(TXN_DATE) = :MES
        AND PURCHASE = 1
    GROUP BY CUSTOMER_ID, MONTH(TXN_DATE);

    SELECT TOP 1
        MONTHNAME(TXN_DATE) INTO nombre_mes
    FROM ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.TXN_PIVOT
    WHERE MONTH(TXN_DATE) = :MES;
    
    RETURN 'El cliente '||:CUSTOMER_ID||' se ha gastado un total de '||total_compras||' euros en compras durante el mes de '||nombre_mes||'.';

END;

CALL  ESPECIALIDAD_SQL_BRONZE_DB_SVM.PRUEBAS.COMPRAS_X_CLIENTE_Y_MES (1,3);