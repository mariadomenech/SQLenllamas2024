/* Poder elgir el tipo de calculo que nos devuelva por mes y cliente
    -BALANCE
    -TOTAL DEPOSITADO
    -TOTAL COMPRAS 
    -TOTAL RETIRADO*/

CREATE OR REPLACE TEMPORARY TABLE ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.MONTHS AS
    SELECT DISTINCT
        MONTH(txn_date) as month_num                                               
        ,DECODE(MONTH(txn_date),
        1,'ENERO',
        2,'FEBRERO',
        3,'MARZO',
        4,'ABRIL',
        5,'MAYO',
        6,'JUNIO',
        7,'JULIO',
        8,'AGOSTO',
        9,'SEPTIEMBRE',
        10,'OCTUBRE',
        11,'NOVIEMBRE',
        12,'DICIEMBRE') as month_name_sp
    FROM case03.customer_transactions
    ORDER BY 1;



CREATE OR REPLACE PROCEDURE SQL_EN_LLAMAS.CASE03.BEA_EXPOSITO_CALCULATIONS (customer_ident NUMBER, month_name VARCHAR, txn_choose VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS 
DECLARE
    TOTAL_COMPRAS NUMBER;
    TOTAL_DEPOSITADO NUMBER;
    TOTAL_RETIRADO NUMBER;
    BALANCE NUMBER;

BEGIN 
       SELECT 
        SUM(CASE WHEN txn_type = 'purchase' THEN COALESCE(txn_amount, 0) ELSE 0 END) AS SUMA_COMPRAS 
        ,SUM(CASE WHEN txn_type = 'deposit' THEN COALESCE(txn_amount, 0) ELSE 0 END) AS SUMA_DEPOSITOS
        ,SUM(CASE WHEN txn_type = 'withdrawal' THEN COALESCE(txn_amount, 0) ELSE 0 END) AS SUMA_RETIROS
        ,(SUMA_DEPOSITOS - SUMA_COMPRAS - SUMA_RETIROS) AS SUMA_TOTAL
        INTO 
        TOTAL_COMPRAS
        ,TOTAL_DEPOSITADO
        ,TOTAL_RETIRADO
        ,BALANCE
        FROM  
               (
            SELECT customer_id 
                   ,MONTH (txn_date ) AS month_num
                   ,INITCAP(B.month_name_sp) AS month_name_sp
                   ,txn_amount
                   ,txn_type
            FROM case03.customer_transactions A
            LEFT JOIN ESPECIALIDAD_SQL_BRONZE_DB_BEA.RETO.MONTHS B
                ON MONTH (A.txn_date )  = B.month_num
            WHERE  A.customer_id = :customer_ident
                AND B.month_name_sp = UPPER(:month_name)
                );

        CASE
            WHEN UPPER(TRIM(:txn_choose)) = 'BALANCE' AND (TOTAL_DEPOSITADO IS NOT NULL OR TOTAL_COMPRAS IS NOT NULL OR TOTAL_RETIRADO IS NOT NULL) and balance < 0
                THEN
                    RETURN 'El Balance del cliente ' || :customer_ident || ' en ' || INITCAP(:month_name) || ' es de ' || BALANCE|| ' euros. El cliente presenta pérdidas';     
            WHEN UPPER(TRIM(:txn_choose)) = 'BALANCE' AND (TOTAL_DEPOSITADO IS NOT NULL OR TOTAL_COMPRAS IS NOT NULL OR TOTAL_RETIRADO IS NOT NULL) and balance > 0
                THEN
                    RETURN 'El Balance del cliente ' || :customer_ident || ' en ' || INITCAP(:month_name) || ' es de ' || BALANCE|| ' euros. El cliente presenta ganancias';                      
            WHEN UPPER(TRIM(:txn_choose)) = 'TOTAL_DEPOSITADO' AND TOTAL_DEPOSITADO IS NOT NULL
                THEN
                    RETURN 'El cliente ' || :customer_ident || ' ha depositado un total de ' || TOTAL_DEPOSITADO || ' euros en ' || INITCAP(:month_name) || '.';    
            WHEN UPPER(TRIM(:txn_choose)) = 'TOTAL_COMPRAS' AND TOTAL_COMPRAS IS NOT NULL
                THEN
                   RETURN 'El cliente ' || :customer_ident || ' ha realizado compras por el valor de ' || TOTAL_COMPRAS || ' euros en ' || INITCAP(:month_name) || '.';    
            WHEN UPPER(TRIM(:txn_choose)) = 'TOTAL_RETIRADO' AND TOTAL_RETIRADO IS NOT NULL
                THEN
                    RETURN 'El cliente ' || :customer_ident || ' ha retirado un total de ' || TOTAL_RETIRADO || ' euros en ' || INITCAP(:month_name) || '.';
            ELSE
                RETURN 'No se puede calcular este valor para el cliente '||:customer_ident||' durante el mes de '||:month_name||'.';
        END CASE;
END;

CALL SQL_EN_LLAMAS.CASE03.BEA_EXPOSITO_CALCULATIONS (1, 'marzo','BALANCE');
