----------- NO FUNCIONA, ESTOY BUSCANDO EL ERROR ----------------



CREATE OR REPLACE PROCEDURE sql_en_llamas.case03.dia3_fernandoramos (customer_id INT, mes int)

RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
  total_compras INT;
  mes_ CHAR(10);
BEGIN

    select
          CUSTOMER_ID
        , (SUM(TXN_AMOUNT)) INTO total_compras
    from 
    
        (
            select 
                *
            from SQL_EN_LLAMAS.CASE03.customer_transactions
                PIVOT (count(txn_type)
                    FOR txn_type IN ('deposit','purchase','withdrawal'))
                        AS A (customer_id, txn_date, txn_amount, deposit, purchase, withdrawall)
        )

    where CUSTOMER_ID = :CUSTOMER_ID
        AND MONTH(TXN_DATE) = :MES
    group by CUSTOMER_ID, MONTH(TXN_DATE);
    
    select top 1
        MONTHNAME(TXN_DATE) INTO mes_
    from 
    
        (
            select 
                *
            from SQL_EN_LLAMAS.CASE03.customer_transactions
                PIVOT (count(txn_type)
                    FOR txn_type IN ('deposit','purchase','withdrawal'))
                        AS A (customer_id, txn_date, txn_amount, deposit, purchase, withdrawall)
        )

    where MONTH(TXN_DATE) = :MES;
    
    CASE
        WHEN total_compras IS NULL
            THEN RETURN 'No hay compras para el cliente '||:CUSTOMER_ID||' durante el mes de '||mes_||'.';
        ELSE
            RETURN 'El cliente '||:CUSTOMER_ID||' se ha gastado un total de '||total_compras||' EUR en compras durante el mes de '||mes_||'.';
    END CASE;
END;
