USE SQL_EN_LLAMAS;
USE SCHEMA CASE03;
CREATE OR REPLACE PROCEDURE customer_purchase_pmz(cust INTEGER, mes INTEGER)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
    LET mes_desc VARCHAR :=
    (SELECT DISTINCT TO_CHAR(txn_date, 'MMMM')
        FROM sql_en_llamas.case03.customer_transactions
        WHERE MONTH(txn_date)= :mes);
        
    LET res FLOAT :=
        (SELECT amount 
            FROM( 
            (SELECT customer_id,
                    MONTH(txn_date) tx_mes,
                    SUM(txn_amount) amount
                FROM   sql_en_llamas.case03.customer_transactions
                WHERE txn_type='purchase'
                GROUP BY 1,2)
        )
        WHERE customer_id = :cust
        AND tx_mes = :mes);
        
      RETURN 'El cliente ' || cust || ' se ha gastado un total de ' || ZEROIFNULL(res) || ' EUR en compras de producto en el mes de ' || mes_desc;
END;


CALL customer_purchase_pmz(100,3);


/*
COMEMENTARIOS JUANPE:
Todo correcto aunque hubiera estado bien un mensaje de error si se pide un cliente que no existe.
*/
