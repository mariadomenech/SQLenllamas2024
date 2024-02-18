CREATE OR REPLACE PROCEDURE CRISTIAN_COMPRAS_CLIENTE_MES(CUSTOMER_ID INT, MES STRING) -- EN ESTE CASO EL MES DEBERIAN INTRODUCIRLO NUMERICO <1 - 12>
    RETURNS STRING
    LANGUAGE SQL
    EXECUTE AS CALLER
AS
DECLARE
    TOTAL_AMOUNT DECIMAL;
    MESSAGE STRING;
BEGIN
    LET MES_NAME VARCHAR :=
    (SELECT DISTINCT MONTHNAME(TXN_DATE)
    FROM CUSTOMER_TRANSACTIONS
    WHERE MONTH(TXN_DATE)= :mes);
    
    SELECT
        COALESCE(SUM(TXN_AMOUNT), 0) INTO TOTAL_AMOUNT
    FROM CUSTOMER_TRANSACTIONS
    WHERE CUSTOMER_ID = :CUSTOMER_ID 
        AND TXN_TYPE = 'purchase'
        AND (MONTH, TXN_DATE) = :MES;

    RETURN 'El cliente ' || :CUSTOMER_ID || ' se ha gastado un total de ' || :TOTAL_AMOUNT || ' euros en compras de productos en el mes de ' || :MES_NAME;
 
END;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado es correcto pero he tenido que corregir una errata:

Antes: AND (MONTH, TXN_DATE) = :MES; --Da error
Ahora: AND MONTH(TXN_DATE) = :MES;

*/
